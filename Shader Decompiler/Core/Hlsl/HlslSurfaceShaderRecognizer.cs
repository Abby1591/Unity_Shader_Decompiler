using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Parser.DXBC.Metadata;

using Parser.DXBC.IR;
namespace Parser.Core.Hlsl.Ast;

// Stage 13.5 — Surface-shader recognition.
//
// Unity compiles a `#pragma surface surf <model>` source into the same
// per-pass vertex/fragment HLSL this decompiler emits, so a pass can be
// recognized by the boilerplate the surface pipeline stamps onto it:
//   - the fragment always ends with a `o.sv_Target0.xyz = ...` lighting
//     expression built from _LightColor0 (Lambert: nDotL * albedo * light;
//     Standard: the GGX BRDF + reflection-probe decode);
//   - the albedo is folded into that expression as a product of a vertex
//     interpolator (usually COLOR) with shader properties.
// When such a signature is found, the raw lit pass is rewritten back into
// the canonical CGPROGRAM surface form: the #pragma surface line, the Input
// struct, and a reconstructed surf() body. Hand-written shaders (no
// _LightColor0 chain) are left untouched and null is returned.
public static class HlslSurfaceShaderRecognizer
{
    // keepPasses: when false the verified compiled passes are omitted from
    // the output (the reconstructed #pragma surface source is the whole
    // file), so surface shaders collapse to their original line count. The
    // passes stay recoverable with --keep-passes.
    public static string? TryReconstruct(string shaderText, ShaderMetadata metadata, bool keepPasses)
    {
        string[] lines = shaderText.Split('\n');
        // Property names come from the Metadata layer (the one place that
        // parses metadata.json) — not re-scanned from the printed text.
        var properties = new HashSet<string>(metadata.Properties.Select(p => p.Name));

        int subShader = IndexOfLine(lines, "SubShader");
        if (subShader < 0)
            return null;

        int subShaderEnd = FindClosingBrace(lines, subShader);
        if (subShaderEnd < 0)
            return null;

        string rawSubShader = string.Join("\n", lines.Skip(subShader).Take(subShaderEnd - subShader + 1));

        // The lit pass is the first fragment that carries a lighting model.
        foreach (string frag in FragmentRegions(lines))
        {
            if (TryClassify(frag, out string model, out string? metGloss))
            {
                string surf = ReconstructSurf(frag, model, metGloss, properties);
                string input = ReconstructInput(frag);
                if (surf is null || input is null)
                    continue;

                string subShaderBlock = BuildSubShader(model, input, surf, rawSubShader, metadata, keepPasses);
                return Splice(lines, subShader, subShaderEnd, subShaderBlock);
            }
        }

        return null;
    }

    // -- detection -------------------------------------------------------

    // Returns true and the detected lighting model ("Standard"/"Lambert")
    // when the fragment looks like a Unity surface-shader fragment.
    private static bool TryClassify(string frag, out string model, out string? metGloss)
    {
        model = "";
        metGloss = null;

        bool hasOutput = frag.Contains("o.sv_Target0");
        if (!hasOutput)
            return false;

        // Standard workflow: the GGX metallic BRDF. Keyed on the material
        // uniforms plus Unity's fingerprint constants (0.2209163 is the
        // perceptual F0 used by UnityStandardBRDF) or the reflection-probe
        // names, so the _LightColor0-free emissive variants still match.
        bool isStandard = frag.Contains("_Metallic")
            && frag.Contains("_Gloss")
            && (frag.Contains("unity_SpecCube0") || frag.Contains("0.2209163"));
        if (isStandard)
        {
            model = "Standard";
            metGloss = (frag.Contains("_Metallic") ? "M" : "") + (frag.Contains("_Gloss") ? "G" : "");
            return true;
        }

        // Lambert: diffuse-only — needs the light color, no reflection
        // probes, no specular, and the classic max(dot(N, L), 0) against
        // the light position.
        bool hasLight = frag.Contains("_LightColor0");
        bool lambert = hasLight
            && frag.Contains("_WorldSpaceLightPos0")
            && !frag.Contains("unity_SpecCube0")
            && !frag.Contains("_SpecColor")
            && Regex.IsMatch(frag, @"max\(.*dot\(.*_WorldSpaceLightPos0", RegexOptions.Singleline);
        if (lambert)
        {
            model = "Lambert";
            return true;
        }

        return false;
    }

    // -- surf body reconstruction ----------------------------------------

    // Returns the reconstructed surf() function body statements, or null
    // when no trustworthy albedo expression can be found.
    private static string? ReconstructSurf(string frag, string model, string? metGloss, HashSet<string> properties)
    {
        var statements = new List<string>();
        string? field = null;
        string? albedoProp = null;

        Match albedo = Regex.Match(frag, @"i\.(\w+)\.xyzx \* (_\w+)\.xyzx");
        if (albedo.Success)
        {
            field = InterpolatorField(albedo.Groups[1].Value);
            albedoProp = ResolveProperty(albedo.Groups[2].Value, properties);
            statements.Add($"o.Albedo = (IN.{field}.rgb * {albedoProp}.rgb);");
        }
        else
        {
            // No vertex-colour albedo; a texture-sampled albedo is not
            // reconstructed yet, so bail rather than emit a wrong body.
            return null;
        }

        if (model == "Standard")
        {
            if (metGloss?.Contains('M') == true)
                statements.Add("o.Metallic = _Metallic;");
            if (metGloss?.Contains('G') == true)
                statements.Add($"o.Smoothness = {ResolveProperty("_Gloss", properties)};");
        }

        // Emission: the surface pipeline folds o.Emission into the
        // ForwardBase fragment as an add of the albedo register scaled by a
        // "one-minus-alpha" glow, compiled to
        //     float T1 = (-i.<field>.w + 1);
        //     float T2 = (T1 * _<prop>);
        //     o.sv_Target0.xyz = (mad(<albedoReg>.xyzx, T2.xxxx, ...)).xyz;
        // Faithful reconstruction is o.Emission = albedo * (1 - a) * prop;
        // every step must line up before it is emitted.
        Match oneMinus = Regex.Match(frag, @"float (\w+) = \(-i\.(\w+)\.w \+ 1\);");
        if (oneMinus.Success)
        {
            string oneMinusTemp = oneMinus.Groups[1].Value;
            Match glow = Regex.Match(frag, $@"float (\w+) = \((?:{oneMinusTemp}) \* (_\w+)\);");
            if (glow.Success)
            {
                Match albedoReg = Regex.Match(frag, @"float3 (\w+) = \(\(i\.\w+\.xyzx \* _\w+\.xyzx\)\)\.xyz;");
                Match finalWrite = Regex.Match(frag, @"o\.sv_Target0\.xyz = ([^;]+);");
                if (albedoReg.Success && finalWrite.Success
                    && finalWrite.Groups[1].Value.Contains(albedoReg.Groups[1].Value + ".xyzx")
                    && finalWrite.Groups[1].Value.Contains(glow.Groups[1].Value + ".xxxx"))
                {
                    string glowProp = ResolveProperty(glow.Groups[2].Value, properties);
                    statements.Add($"o.Emission = (IN.{field}.rgb * {albedoProp}.rgb) * (1 - IN.{field}.a) * {glowProp};");
                }
            }
        }

        Match alpha = Regex.Match(frag, @"sv_Target0\.w = ([^;]+);");
        if (alpha.Success)
            statements.Add($"o.Alpha = {alpha.Groups[1].Value.Trim()};");

        return string.Join("\n", statements.Select(s => "            " + s));
    }

    // Input struct: the interpolators the surf actually references (the
    // colour product above). worldPos/worldNormal are handled by Unity's
    // generated lighting and are not part of the user's Input.
    private static string? ReconstructInput(string frag)
    {
        var fields = new List<string>();
        Match color = Regex.Match(frag, @"i\.color0");
        if (color.Success)
            fields.Add("            float4 vertexColor : COLOR;");
        // TODO: uv_* fields for texture-sampled albedos.

        if (fields.Count == 0)
            return null;

        return "        struct Input\n        {\n" + string.Join("\n", fields) + "\n        };";
    }

    // -- emission of the rewritten subshader ------------------------------

    private static string BuildSubShader(string model, string input, string surf, string raw, ShaderMetadata metadata, bool keepPasses)
    {
        string output = model == "Standard" ? "SurfaceOutputStandard" : "SurfaceOutput";
        var sb = new StringBuilder();
        sb.AppendLine("    SubShader");
        sb.AppendLine("    {");

        // Real SubShader metadata (RenderType/Queue tags, LOD) from the
        // serialized form, not guessed.
        SubShaderMetadata? ss = metadata.SubShaders.FirstOrDefault();
        if (ss is not null)
        {
            if (ss.Tags.Count > 0)
            {
                sb.Append("        Tags { ");
                foreach (var (k, v) in ss.Tags)
                    sb.Append('"').Append(k).Append("\"=\"").Append(v).Append("\" ");
                sb.Append("}\n");
            }
            if (ss.Lod is { } lod)
                sb.Append("        LOD ").Append(lod).Append('\n');
        }

        sb.AppendLine("        CGPROGRAM");
        sb.AppendLine("        #include \"UnityCG.cginc\"");
        sb.AppendLine($"        #pragma surface surf {model}");
        if (model == "Standard")
            sb.AppendLine("        #pragma target 3.0");

        var usedProps = new List<(string Name, string Type)>();
        foreach (ShaderProperty p in metadata.Properties)
        {
            if (!surf.Contains(p.Name)) continue;
            string type = p.Type switch
            {
                "2" or "3" => "float",
                "0" or "1" => "float4",
                _ => "float4"
            };
            usedProps.Add((p.Name, type));
        }
        if (usedProps.Count > 0)
        {
            sb.AppendLine();
            foreach (var (name, type) in usedProps.OrderBy(x => x.Name))
                sb.AppendLine($"        uniform {type} {name};");
        }

        sb.AppendLine();
        sb.AppendLine(input);
        sb.AppendLine();
        sb.AppendLine($"        void surf(Input IN, inout {output} o)");
        sb.AppendLine("        {");
        sb.AppendLine(surf);
        sb.AppendLine("        }");
        sb.AppendLine("        ENDCG");
        if (keepPasses)
        {
            sb.AppendLine();
            sb.AppendLine("        /*");
            sb.AppendLine("        The passes below are the compiled surface-shader");
            sb.AppendLine("        output (the literal bytecode we decompiled). They");
            sb.AppendLine("        are what the #pragma surface source above generates.");
            sb.AppendLine("        */");
            sb.AppendLine("        /*");
            foreach (string line in raw.Split('\n'))
                sb.AppendLine(line);
            sb.AppendLine("        */");
        }
        else
        {
            sb.AppendLine();
            sb.AppendLine("        // Compiled passes omitted for size. Rerun with");
            sb.AppendLine("        // --keep-passes to include the verified passes.");
        }
        sb.AppendLine("    }");
        return sb.ToString();
    }

    // -- helpers ----------------------------------------------------------

    private static string ResolveProperty(string cbufferName, HashSet<string> properties)
    {
        if (properties.Contains(cbufferName))
            return cbufferName;
        // Unity's Standard surface pipeline names the smoothness cbuffer
        // variable _Gloss while the property is _Smoothness / _Glossiness.
        if (cbufferName == "_Gloss")
        {
            if (properties.Contains("_Smoothness"))
                return "_Smoothness";
            if (properties.Contains("_Glossiness"))
                return "_Glossiness";
        }
        return cbufferName;
    }

    private static string InterpolatorField(string name) => name switch
    {
        "color0" => "vertexColor",
        "texcoord0" => "uv",
        "texcoord1" => "uv2",
        _ => name,
    };

    // Yields the text of every `#pragma fragment frag` function up to the
    // next ENDHLSL, so classification runs once per pass.
    private static IEnumerable<string> FragmentRegions(string[] lines)
    {
        for (int i = 0; i < lines.Length; i++)
        {
            if (!lines[i].Contains("#pragma fragment frag"))
                continue;
            var sb = new StringBuilder();
            for (int j = i + 1; j < lines.Length; j++)
            {
                if (lines[j].Contains("ENDHLSL"))
                    break;
                sb.AppendLine(lines[j]);
            }
            yield return sb.ToString();
        }
    }

    private static int IndexOfLine(string[] lines, string needle)
    {
        for (int i = 0; i < lines.Length; i++)
            if (lines[i].Trim().StartsWith(needle))
                return i;
        return -1;
    }

    // Brace-matching close for the block opening on `start` (the SubShader
    // line) or the first '{' after it.
    private static int FindClosingBrace(string[] lines, int start)
    {
        int brace = -1;
        for (int i = start; i < lines.Length; i++)
        {
            int open = lines[i].IndexOf('{');
            if (open >= 0) { brace = i; break; }
        }
        if (brace < 0)
            return -1;

        int depth = 0;
        for (int i = brace; i < lines.Length; i++)
        {
            string line = lines[i];
            foreach (char c in line)
            {
                if (c == '{') depth++;
                else if (c == '}') depth--;
            }
            if (depth == 0)
                return i;
        }
        return -1;
    }

    private static string Splice(string[] lines, int start, int end, string replacement)
    {
        var head = string.Join("\n", lines.Take(start));
        var tail = string.Join("\n", lines.Skip(end + 1));
        return head + "\n" + replacement.TrimEnd('\n') + "\n" + tail;
    }
}