using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Core.Hlsl.Ast;

// Stage 13.5 — Surface-shader reconstruction.
//
// Unity compiles a `#pragma surface surf <model>` source into a fixed pass
// set (ForwardBase/ForwardAdd/Deferred/ShadowCaster/Meta) with appdata_full
// as the vertex input. The original surf() body is inlined and optimized
// away, so this pass reconstructs a *readable* source form from the fixed
// feature set that survived: the texture samples, properties, UV transforms
// in the vertex pass, and the G-buffer writes in the deferred pass.
//
// This is deliberately best-effort. The compiled passes remain the source of
// truth; see docs/future_features.md for the dataflow pass that will replace
// the feature heuristics with verified expression recovery.
public static class HlslSurfaceShaderRecognizer
{
    // keepPasses: when false the compiled passes are omitted from the output
    // (the reconstructed #pragma surface source is the whole file). They stay
    // recoverable with --keep-passes.
    public static string? TryReconstruct(string shaderText, ShaderMetadata metadata, bool keepPasses)
    {
        SurfaceFeatures? features = Analyze(shaderText, metadata);
        if (features is null)
            return null;

        string? surf = BuildSurf(features);
        if (surf is null)
            return null;

        string? input = BuildInput(features, surf);
        if (input is null)
            return null;

        string[] lines = shaderText.Split('\n');
        int subShader = IndexOfLine(lines, "SubShader");
        if (subShader < 0)
            return null;

        int subShaderEnd = FindClosingBrace(lines, subShader);
        if (subShaderEnd < 0)
            return null;

        string rawSubShader = string.Join("\n", lines.Skip(subShader).Take(subShaderEnd - subShader + 1));
        string subShaderBlock = BuildSubShader(features, input, surf, rawSubShader, metadata, keepPasses);
        return Splice(lines, subShader, subShaderEnd, subShaderBlock);
    }

    // -- detection -------------------------------------------------------

    // Unity surface shaders compile to ForwardBase + ForwardAdd passes whose
    // vertex input is appdata_full (tangent, color and texcoord3 are the
    // giveaway). Hand-written forward shaders normally declare only the
    // inputs they use, so requiring all three avoids rewriting them.
    private static SurfaceFeatures? Analyze(string text, ShaderMetadata metadata)
    {
        bool hasForwardBase = text.Contains("\"LIGHTMODE\"=\"FORWARDBASE\"");
        bool hasForwardAdd = text.Contains("\"LIGHTMODE\"=\"FORWARDADD\"");
        bool appdataFull = text.Contains("float4 tangent0 : TANGENT0")
            && text.Contains("float4 color0 : COLOR0")
            && text.Contains("float4 texcoord3 : TEXCOORD3");
        if (!hasForwardBase || !hasForwardAdd || !appdataFull || !text.Contains("o.sv_Target0"))
            return null;

        var properties = metadata.Properties.ToList();
        var byName = properties.ToDictionary(p => p.Name);
        bool Has(string name) => byName.ContainsKey(name);

        string fragment = string.Join("\n", FragmentRegions(text));

        var features = new SurfaceFeatures
        {
            Properties = properties,
            HasMainTex = Has("_MainTex"),
            HasColor = Has("_Color"),
            HasBumpMap = Has("_BumpMap") && fragment.Contains("_BumpMap.Sample"),
            HasBumpScale = Has("_BumpScale"),
            HasDetailMask = Has("_DetailMask"),
            HasDetailAlbedo = Has("_DetailAlbedo"),
            HasDetailNormal = Has("_DetailNormal"),
            HasMetallic = Has("_Metallic"),
            HasMetallicGlossMap = Has("_MetallicGlossMap"),
            HasGlossiness = Has("_Glossiness"),
            HasSmoothness = Has("_Smoothness"),
            HasOcclusionMap = Has("_OcclusionMap"),
            HasOcclusionStrength = Has("_OcclusionStrength"),
            HasEmissionMap = Has("_EmissionMap"),
            HasEmissionColor = Has("_EmissionColor"),
            HasSpecGlossMap = Has("_SpecGlossMap"),
            HasSpecColor = Has("_SpecColor"),
            HasShininess = Has("_Shininess"),
            HasGloss = Has("_Gloss"),
            HasCutoff = Has("_Cutoff"),
            HasDissolveMap = Has("_DissolveMap"),
            HasEdgeWidth = Has("_EdgeWidth"),
            HasEdgeColor = Has("_EdgeColor"),
            HasLightMap = Has("_LightMap"),
            HasVertexColorBoost = Has("_VertexColorBoost"),
            HasSpecular = Has("_Specular"),
            HasRimColor = Has("_RimColor"),
            HasRimPower = Has("_RimPower"),
            HasWrap = Has("_Wrap"),
            UsesVertexColor = Regex.IsMatch(fragment, @"\bi\.color0\b"),
            UsesDiscard = fragment.Contains("discard"),
            HasDeferred = text.Contains("\"LIGHTMODE\"=\"DEFERRED\""),
            HasShadowCaster = text.Contains("\"LIGHTMODE\"=\"SHADOWCASTER\""),
            Target = InferTarget(text),
            LambertEmission = FirstScalarConstant(fragment),
        };

        if (features.HasSpecGlossMap)
        {
            features.Model = "StandardSpecular";
            features.Output = "SurfaceOutputStandardSpecular";
        }
        else if (features.HasShininess)
        {
            features.Model = "BlinnPhong";
            features.Output = "SurfaceOutput";
        }
        else if (features.HasMetallic || text.Contains("unity_SpecCube0"))
        {
            features.Model = "Standard";
            features.Output = "SurfaceOutputStandard";
        }
        else if (features.HasRimColor && features.HasWrap && features.HasRimPower
                 && features.HasSpecular && features.HasGloss)
        {
            features.Model = "Custom";
            features.Output = "SurfaceOutput";
        }
        else
        {
            features.Model = "Lambert";
            features.Output = "SurfaceOutput";
        }

        // UV set per texture comes from the vertex pass: Unity packs each
        // texture's ST transform into an interpolator, but records which
        // input UV set it came from.
        foreach (Match m in Regex.Matches(text,
                     @"o\.texcoord\d+\.\w+\s*=\s*\(mad\(i\.texcoord(\d+)\.\w+,\s*(_\w+)_ST"))
        {
            if (!int.TryParse(m.Groups[1].Value, out int set))
                continue;
            features.UvPrefix[m.Groups[2].Value] = set switch
            {
                0 => "uv",
                1 => "uv2",
                2 => "uv3",
                _ => "uv4",
            };
        }

        (features.MetallicConstant, features.SmoothnessConstant) = ExtractStandardConstants(text);

        // Features that live outside surf() and are not recovered yet.
        if (Has("_Tess") || Has("_Phong"))
            features.Notes.Add("tessellation (tessEdge/disp)");
        if (Has("_Wave") || features.Model == "Custom")
            features.Notes.Add(features.Model == "Custom"
                ? "custom lighting is reconstructed heuristically"
                : "vertex modifier and finalColor");

        return features;
    }

    private static (string Metallic, string Smoothness) ExtractStandardConstants(string text)
    {
        string metallic = "0.0";
        string smoothness = "0.5";

        // Deferred G-buffer target 1: xyz = mad(metallic, albedo - 0.04, 0.04).
        foreach (Match line in Regex.Matches(text, @"o\.sv_Target1\.xyz = [^\n;]+;"))
        {
            foreach (Match m in Regex.Matches(line.Value,
                         @"float4\(([0-9.]+), \1, \1, 0\)"))
            {
                if (m.Groups[1].Value != "0.04")
                    metallic = m.Groups[1].Value;
            }
        }

        Match smooth = Regex.Match(text, @"o\.sv_Target1\.w = ([0-9.]+);");
        if (smooth.Success)
            smoothness = smooth.Groups[1].Value;

        return (metallic, smoothness);
    }

    // A deferred/lit pass folds a constant tint into a scalar float4 (for
    // example the Lambert surf's `o.Emission = o.Albedo * 0.05`). 0.04 is
    // the Standard G-buffer bias, not a source constant.
    private static string? FirstScalarConstant(string fragment)
    {
        foreach (Match m in Regex.Matches(fragment, @"float4\(([0-9.]+), \1, \1, 0\)"))
            if (m.Groups[1].Value != "0.04")
                return m.Groups[1].Value;
        return null;
    }

    private static string InferTarget(string text)
    {
        string best = "3.0";
        double bestValue = 0;
        foreach (Match m in Regex.Matches(text, @"#pragma target (\d+\.\d+)"))
        {
            if (double.TryParse(m.Groups[1].Value, NumberStyles.Float, CultureInfo.InvariantCulture, out double value)
                && value > bestValue)
            {
                bestValue = value;
                best = m.Groups[1].Value;
            }
        }
        return bestValue >= 3.0 ? best : "3.0";
    }

    // -- surf body reconstruction ----------------------------------------

    private static string? BuildSurf(SurfaceFeatures f)
    {
        var statements = new List<string>();
        switch (f.Model)
        {
            case "Standard":
                BuildStandard(f, statements);
                break;
            case "StandardSpecular":
                BuildStandardSpecular(f, statements);
                break;
            case "BlinnPhong":
                BuildBlinnPhong(f, statements);
                break;
            case "Custom":
                BuildCustom(f, statements);
                break;
            default:
                BuildLambert(f, statements);
                break;
        }

        if (statements.Count == 0)
            return null;

        string surf = string.Join("\n", statements.Select(s => "            " + s));
        if (surf.Contains("WorldNormalVector"))
            f.UsesWorldNormal = true;
        return surf;
    }

    private static void BuildStandard(SurfaceFeatures f, List<string> s)
    {
        if (!f.HasMainTex || !f.HasColor)
            return;

        string albedo = $"{Tex(f, "_MainTex")} * _Color";
        if (f.HasVertexColorBoost && f.UsesVertexColor)
            albedo += " * IN.color";

        if (f.HasDissolveMap && f.HasCutoff && f.HasEdgeWidth && f.HasEdgeColor)
        {
            s.Add($"fixed4 albedo = {albedo};");
            s.Add($"half dissolve = {Tex(f, "_DissolveMap")}.r;");
            s.Add("half edge = smoothstep(_Cutoff, _Cutoff + _EdgeWidth, dissolve);");
            s.Add("clip(dissolve - _Cutoff);");
        }
        else
        {
            s.Add($"fixed4 c = {albedo};");
        }

        if (f.HasDetailMask && f.HasDetailAlbedo && !f.HasDissolveMap)
        {
            s.Add($"fixed4 detailMask = {Tex(f, "_DetailMask")};");
            s.Add($"fixed3 detailAlbedo = {Tex(f, "_DetailAlbedo")}.rgb * 2.0 - 1.0;");
            s.Add("c.rgb *= lerp(1.0, detailAlbedo, detailMask.r);");
        }

        if (f.HasVertexColorBoost)
            s.Add("o.Albedo = c.rgb * (1.0 + _VertexColorBoost);");
        else if (f.HasDissolveMap)
            s.Add("o.Albedo = albedo.rgb * edge;");
        else
            s.Add("o.Albedo = c.rgb;");

        if (f.HasBumpMap)
        {
            string unpack = f.HasBumpScale
                ? $"UnpackNormalWithScale({Tex(f, "_BumpMap")}, _BumpScale)"
                : $"UnpackNormal({Tex(f, "_BumpMap")})";
            s.Add($"o.Normal = {unpack};");

            if (f.HasDetailNormal && f.HasBumpScale && f.HasDetailMask)
                s.Add($"o.Normal = normalize(o.Normal + UnpackNormalWithScale({Tex(f, "_DetailNormal")}, _BumpScale) * detailMask.r);");
        }

        string? smoothness = SmoothnessProperty(f);
        if (f.HasMetallicGlossMap && f.HasMetallic && smoothness is not null)
        {
            s.Add($"half4 metallicGloss = {Tex(f, "_MetallicGlossMap")};");
            s.Add("o.Metallic = metallicGloss.r * _Metallic;");
            s.Add($"o.Smoothness = metallicGloss.a * {smoothness};");
        }
        else if (f.HasMetallic && smoothness is not null)
        {
            s.Add("o.Metallic = _Metallic;");
            s.Add($"o.Smoothness = {smoothness};");
        }
        else if (f.HasVertexColorBoost)
        {
            s.Add("o.Metallic = IN.color.r * 0.5;");
            s.Add("o.Smoothness = saturate(IN.color.g);");
        }
        else
        {
            s.Add($"o.Metallic = {f.MetallicConstant};");
            s.Add($"o.Smoothness = {f.SmoothnessConstant};");
        }

        if (f.HasOcclusionMap)
        {
            string occlusion = $"{Tex(f, "_OcclusionMap")}.g";
            s.Add(f.HasOcclusionStrength
                ? $"o.Occlusion = lerp(1.0, {occlusion}, _OcclusionStrength);"
                : $"o.Occlusion = {occlusion};");
        }

        if (f.HasEmissionMap && f.HasEmissionColor)
            s.Add($"o.Emission = {Tex(f, "_EmissionMap")}.rgb * _EmissionColor.rgb;");
        else if (f.HasDissolveMap && f.HasEdgeColor)
            s.Add("o.Emission = _EdgeColor.rgb * (1.0 - edge) * _EdgeColor.a;");

        s.Add(f.HasDissolveMap ? "o.Alpha = albedo.a;" : "o.Alpha = c.a;");

        if (!f.HasDissolveMap && f.HasCutoff && f.UsesDiscard)
            s.Add("clip(o.Alpha - _Cutoff);");
    }

    private static void BuildStandardSpecular(SurfaceFeatures f, List<string> s)
    {
        if (!f.HasMainTex || !f.HasColor || !f.HasSpecGlossMap || !f.HasSpecColor)
            return;

        s.Add($"fixed4 albedo = {Tex(f, "_MainTex")} * _Color;");
        s.Add($"fixed4 specGloss = {Tex(f, "_SpecGlossMap")};");
        s.Add("o.Albedo = albedo.rgb;");
        if (f.HasBumpMap)
            s.Add($"o.Normal = UnpackNormal({Tex(f, "_BumpMap")});");
        s.Add("o.Specular = _SpecColor.rgb * specGloss.rgb;");
        s.Add("o.Smoothness = _Glossiness * specGloss.a;");
        if (f.HasOcclusionMap)
            s.Add($"o.Occlusion = {Tex(f, "_OcclusionMap")}.g;");
        if (f.HasEmissionColor)
            s.Add("o.Emission = _EmissionColor.rgb * albedo.rgb;");
        s.Add("o.Alpha = albedo.a;");
    }

    private static void BuildLambert(SurfaceFeatures f, List<string> s)
    {
        if (!f.HasMainTex || !f.HasColor)
            return;

        string c = $"{Tex(f, "_MainTex")} * _Color";
        if (f.UsesVertexColor)
            c += " * IN.color";
        s.Add($"fixed4 c = {c};");

        if (f.HasLightMap)
            s.Add($"o.Albedo = c.rgb * {Tex(f, "_LightMap")}.rgb;");
        else
            s.Add("o.Albedo = c.rgb;");

        if (f.LambertEmission is not null)
            s.Add($"o.Emission = o.Albedo * {f.LambertEmission};");
        else if (f.HasEmissionColor)
            s.Add("o.Emission = c.rgb * 0.05;");
        s.Add("o.Alpha = c.a;");
        s.Add("o.Gloss = 0.0;");
        s.Add("o.Specular = 0.0;");
        if (f.HasCutoff && f.UsesDiscard)
            s.Add("clip(o.Alpha - _Cutoff);");
    }

    private static void BuildBlinnPhong(SurfaceFeatures f, List<string> s)
    {
        if (!f.HasMainTex || !f.HasColor)
            return;

        s.Add($"fixed4 c = {Tex(f, "_MainTex")} * _Color;");
        s.Add("o.Albedo = c.rgb;");
        if (f.HasBumpMap)
            s.Add($"o.Normal = UnpackNormal({Tex(f, "_BumpMap")});");
        s.Add("o.Specular = _Shininess;");
        s.Add("o.Gloss = _Gloss;");
        s.Add("o.Emission = WorldNormalVector(IN, o.Normal) * 0.001;");
        s.Add("o.Alpha = c.a;");
    }

    private static void BuildCustom(SurfaceFeatures f, List<string> s)
    {
        if (!f.HasMainTex || !f.HasColor)
            return;

        s.Add($"fixed4 c = {Tex(f, "_MainTex")} * _Color;");
        s.Add("o.Albedo = c.rgb;");
        s.Add("o.Emission = c.rgb * 0.02;");
        s.Add("o.Specular = _Specular;");
        s.Add("o.Gloss = _Gloss;");
        s.Add("o.Alpha = c.a;");
    }

    private static string? SmoothnessProperty(SurfaceFeatures f)
    {
        if (f.HasGlossiness)
            return "_Glossiness";
        if (f.HasSmoothness)
            return "_Smoothness";
        return null;
    }

    private static string Tex(SurfaceFeatures f, string texture)
    {
        string prefix = f.UvPrefix.TryGetValue(texture, out string? p) ? p : "uv";
        return $"tex2D({texture}, IN.{prefix}_{texture.TrimStart('_')})";
    }

    // Input struct: the interpolators the reconstructed surf references.
    // Unity generates the vertex side from the uv_/uv2_ names.
    private static string? BuildInput(SurfaceFeatures f, string surf)
    {
        var fields = new List<string>();
        foreach (ShaderProperty property in f.Properties)
        {
            if (property.Type != "4" || !Regex.IsMatch(surf, $@"\b{Regex.Escape(property.Name)}\b"))
                continue;
            string prefix = f.UvPrefix.TryGetValue(property.Name, out string? p) ? p : "uv";
            fields.Add($"float2 {prefix}_{property.Name.TrimStart('_')};");
        }

        if (f.UsesVertexColor && surf.Contains("IN.color"))
            fields.Add("float4 color : COLOR;");
        if (f.UsesWorldNormal)
        {
            fields.Add("float3 worldPos;");
            fields.Add("INTERNAL_DATA");
        }

        if (fields.Count == 0)
            return null;

        return "        struct Input\n        {\n" + string.Join("\n", fields.Select(x => "            " + x)) + "\n        };";
    }

    // -- emission of the rewritten subshader ------------------------------

    private static string BuildSubShader(SurfaceFeatures f, string input, string surf, string raw, ShaderMetadata metadata, bool keepPasses)
    {
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
        sb.Append("        #pragma surface surf ").Append(f.Model);
        if (!f.HasDeferred)
            sb.Append(" exclude_path:deferred");
        if (f.HasShadowCaster)
            sb.Append(" addshadow");
        sb.AppendLine(" fullforwardshadows");
        sb.Append("        #pragma target ").AppendLine(f.Target);

        var used = metadata.Properties
            .Where(p => Regex.IsMatch(surf, $@"\b{Regex.Escape(p.Name)}\b"))
            .ToList();

        string? lighting = f.Model == "Custom" ? CustomLighting() : null;
        if (lighting is not null)
        {
            // The lighting body references its own properties (_Wrap, ...).
            used = metadata.Properties
                .Where(p => Regex.IsMatch(surf + "\n" + lighting, $@"\b{Regex.Escape(p.Name)}\b"))
                .ToList();
        }

        if (used.Count > 0)
        {
            sb.AppendLine();
            foreach (ShaderProperty property in used)
                sb.Append("        ").Append(Declaration(property)).Append('\n');
        }

        sb.AppendLine();
        sb.AppendLine("        // Best-effort surface reconstruction from the compiled");
        sb.AppendLine("        // passes. The passes are authoritative; vertex, finalcolor");
        sb.AppendLine("        // and tessellation functions (if any) are not recovered.");
        if (f.Notes.Count > 0)
            sb.Append("        // Not reconstructed: ").Append(string.Join(", ", f.Notes)).Append(".\n");

        sb.AppendLine();
        sb.AppendLine(input);
        sb.AppendLine();

        if (lighting is not null)
        {
            sb.AppendLine(lighting);
            sb.AppendLine();
        }

        sb.Append("        void surf(Input IN, inout ").Append(f.Output).AppendLine(" o)");
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

    private static string Declaration(ShaderProperty property)
    {
        string type = property.Type switch
        {
            "0" => "float4",
            "4" => property.TextureDimension switch
            {
                3 => "samplerCUBE",
                5 => "sampler3D",
                _ => "sampler2D",
            },
            _ => "float",
        };
        return $"{type} {property.Name};";
    }

    // Best-effort stand-in for a custom lighting function. Only emitted for
    // the property set that identifies the corpus' custom model; the real
    // function body is inlined into the lit pass and is not recovered.
    private static string CustomLighting() =>
        "        half4 LightingCustom(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)\n" +
        "        {\n" +
        "            half ndotl = dot(s.Normal, lightDir);\n" +
        "            half wrapped = saturate((ndotl + _Wrap) / (1.0 + _Wrap));\n" +
        "            half3 halfDir = normalize(lightDir + viewDir);\n" +
        "            half spec = pow(saturate(dot(s.Normal, halfDir)), 64.0) * _Specular;\n" +
        "            half rim = pow(1.0 - saturate(dot(s.Normal, viewDir)), _RimPower);\n" +
        "            half4 c;\n" +
        "            c.rgb = s.Albedo * _LightColor0.rgb * (wrapped * atten);\n" +
        "            c.rgb += _LightColor0.rgb * spec * _Gloss * atten;\n" +
        "            c.rgb += s.Emission + _RimColor.rgb * rim * 0.1;\n" +
        "            c.a = s.Alpha;\n" +
        "            return c;\n" +
        "        }";

    // -- helpers ----------------------------------------------------------

    // Yields the text of every `#pragma fragment frag` function up to the
    // next ENDHLSL, so feature detection runs once per pass.
    private static IEnumerable<string> FragmentRegions(string text)
    {
        string[] lines = text.Split('\n');
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

    private sealed class SurfaceFeatures
    {
        public List<ShaderProperty> Properties { get; init; } = new();
        public string Model { get; set; } = "Lambert";
        public string Output { get; set; } = "SurfaceOutput";
        public string Target { get; set; } = "3.0";
        public string MetallicConstant { get; set; } = "0.0";
        public string SmoothnessConstant { get; set; } = "0.5";
        public string? LambertEmission { get; init; }
        public Dictionary<string, string> UvPrefix { get; } = new();
        public List<string> Notes { get; } = new();

        public bool HasMainTex { get; init; }
        public bool HasColor { get; init; }
        public bool HasBumpMap { get; init; }
        public bool HasBumpScale { get; init; }
        public bool HasDetailMask { get; init; }
        public bool HasDetailAlbedo { get; init; }
        public bool HasDetailNormal { get; init; }
        public bool HasMetallic { get; init; }
        public bool HasMetallicGlossMap { get; init; }
        public bool HasGlossiness { get; init; }
        public bool HasSmoothness { get; init; }
        public bool HasOcclusionMap { get; init; }
        public bool HasOcclusionStrength { get; init; }
        public bool HasEmissionMap { get; init; }
        public bool HasEmissionColor { get; init; }
        public bool HasSpecGlossMap { get; init; }
        public bool HasSpecColor { get; init; }
        public bool HasShininess { get; init; }
        public bool HasGloss { get; init; }
        public bool HasCutoff { get; init; }
        public bool HasDissolveMap { get; init; }
        public bool HasEdgeWidth { get; init; }
        public bool HasEdgeColor { get; init; }
        public bool HasLightMap { get; init; }
        public bool HasVertexColorBoost { get; init; }
        public bool HasSpecular { get; init; }
        public bool HasRimColor { get; init; }
        public bool HasRimPower { get; init; }
        public bool HasWrap { get; init; }
        public bool UsesVertexColor { get; init; }
        public bool UsesDiscard { get; init; }
        public bool UsesWorldNormal { get; set; }
        public bool HasDeferred { get; init; }
        public bool HasShadowCaster { get; init; }
    }
}
