using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using UnityShaderDecompiler.Core.DXBC.Chunks;
using UnityShaderDecompiler.Core.DXBC.Instructions;
using UnityShaderDecompiler.Core.DXBC.IR;
using UnityShaderDecompiler.Core.Analysis;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Core.Hlsl.Ast;

// Stage 13 (statement/expression -> text formatting) + Stage 14 (ShaderLab
// wrapper) together — splitting them into separate files would mean
// threading a StringBuilder/indent state back and forth between two
// classes for no real benefit, since "print the pass" and "wrap the pass
// in Pass{HLSLPROGRAM...ENDHLSL}" are the same recursive walk.
//
// IMPORTANT — things this printer does NOT invent, and instead flags
// with a `/* TODO ... */` comment in the emitted text so it's visible
// in the output, not just buried in source comments:
//   - Range property bounds when the metadata carried no default value
//     (no slots → no min/max to recover; falls back to Float)
//   - The handful of TextureOperation kinds without a confirmed 1:1 HLSL
//     method mapping (Lod, ResInfo, SampleInfo, SamplePos, BufInfo)
//   - DistanceVector / MaskedSumOfAbsoluteDifferences intrinsics (no
//     standard HLSL builtin — DXBC-specific)
//
// SSA note: DXBC's SSA form means the same logical register (e.g. r0)
// can hold several genuinely different values across a function. HLSL
// has no SSA, so each distinct SSA "version" is emitted as its own
// declared local (name carries the version suffix, e.g. `r0_1`, or
// `worldPos_2` if Stage 12 recovered a name) rather than collapsing them
// onto one mutable variable — collapsing them would be a real semantic
// bug (later reads would see the wrong generation's value), not just a
// cosmetic one.
public static partial class HlslPrettyPrinter
{
    // Cap for Stage 13.5 temp fusion: a def is only inlined into its one
    // consumer when the resulting expression stays under this many IR
    // nodes. Keeps long transform chains readable instead of collapsing
    // into one giant nested expression.
    private const int MaxFuseNodes = 16;

    public static string Print(HlslShaderNode shader, bool fuseTemps = true, bool stripRegisterBindings = false)
    {
        var sb = new StringBuilder();
        sb.Append("Shader \"").Append(shader.Name).Append("\"\n{\n");

        PrintProperties(sb, shader.Properties);

        foreach (HlslSubShaderNode ss in shader.SubShaders)
            PrintSubShader(sb, ss, fuseTemps, stripRegisterBindings);

        if (!string.IsNullOrEmpty(shader.Fallback))
            sb.Append("    Fallback \"").Append(shader.Fallback).Append("\"\n");

        if (!string.IsNullOrEmpty(shader.CustomEditor))
            sb.Append("    CustomEditor \"").Append(shader.CustomEditor).Append("\"\n");

        foreach (string dep in shader.Dependencies)
            sb.Append("    Dependency \"").Append(dep).Append("\"\n");

        sb.Append("}\n");
        return sb.ToString();
    }

    // ---------- Stage 4: Properties ----------

    private static void PrintProperties(StringBuilder sb, List<HlslPropertyNode> props)
    {
        sb.Append("    Properties\n    {\n");
        foreach (HlslPropertyNode p in props)
        {
            foreach (string attr in p.Attributes)
                sb.Append("        [").Append(attr).Append("]\n");

            sb.Append("        ").Append(p.Name).Append(" (\"")
              .Append(p.Description ?? p.Name).Append("\", ")
              .Append(PropertyTypeText(p)).Append(") = ")
              .Append(PropertyDefaultText(p)).Append('\n');
        }
        sb.Append("    }\n");
    }

    private static string PropertyTypeText(HlslPropertyNode p) => p.Kind switch
    {
        HlslPropertyKind.Color => "Color",
        HlslPropertyKind.Vector => "Vector",
        HlslPropertyKind.Float => "Float",
        HlslPropertyKind.Range when p.Range is { } r => $"Range({r.Min}, {r.Max})",
        // Range with no recovered bounds (metadata carried no default value,
        // so min/max slots are absent) — emit as Float rather than
        // fabricate a (0,1) that might be wrong.
        HlslPropertyKind.Range => "Float /* TODO: Range bounds not recovered */",
        HlslPropertyKind.Texture => p.TextureDimension switch
        {
            HlslTextureDimension.Tex3D => "3D",
            HlslTextureDimension.Cube => "Cube",
            HlslTextureDimension.Tex2DArray => "2DArray",
            HlslTextureDimension.CubeArray => "CubeArray",
            _ => "2D",
        },
        _ => "Float /* TODO: unknown property kind */",
    };

    private static string PropertyDefaultText(HlslPropertyNode p)
    {
        if (p.Kind == HlslPropertyKind.Texture)
            return "\"\" {}";

        // Typed default (Metadata layer, float[4] — the same {x,y,z,w} the
        // printer used to read out of the raw JsonElement below).
        if (p.DefaultComponents.Length == 4)
        {
            float x = p.DefaultComponents[0], y = p.DefaultComponents[1],
                  z = p.DefaultComponents[2], w = p.DefaultComponents[3];
            return p.Kind is HlslPropertyKind.Color or HlslPropertyKind.Vector
                ? $"({x},{y},{z},{w})"
                : x.ToString();
        }

        if (p.DefaultValue is not { } dv || dv.ValueKind != JsonValueKind.Object)
            return "0";

        double X() => dv.TryGetProperty("x", out var x) ? x.GetDouble() : 0;
        double Y() => dv.TryGetProperty("y", out var y) ? y.GetDouble() : 0;
        double Z() => dv.TryGetProperty("z", out var z) ? z.GetDouble() : 0;
        double W() => dv.TryGetProperty("w", out var w) ? w.GetDouble() : 0;

        return p.Kind is HlslPropertyKind.Color or HlslPropertyKind.Vector
            ? $"({X()},{Y()},{Z()},{W()})"
            : X().ToString();
    }

    // ---------- Stage 5: SubShader ----------

    private static void PrintSubShader(StringBuilder sb, HlslSubShaderNode ss, bool fuseTemps, bool stripRegisterBindings)
    {
        sb.Append("    SubShader\n    {\n");
        PrintTags(sb, ss.Tags, indent: "        ");
        if (ss.Lod is { } lod)
            sb.Append("        LOD ").Append(lod).Append('\n');

        foreach (HlslPassNode pass in ss.Passes)
            PrintPass(sb, pass, fuseTemps, stripRegisterBindings);

        sb.Append("    }\n");
    }

    private static void PrintTags(StringBuilder sb, Dictionary<string, string> tags, string indent)
    {
        if (tags.Count == 0) return;
        sb.Append(indent).Append("Tags { ");
        foreach (var (k, v) in tags)
            sb.Append('"').Append(k).Append("\"=\"").Append(v).Append("\" ");
        sb.Append("}\n");
    }

    // ---------- Stage 6/14: Pass ----------

    private static void PrintPass(StringBuilder sb, HlslPassNode pass, bool fuseTemps, bool stripRegisterBindings)
    {
        sb.Append("        Pass\n        {\n");
        if (!string.IsNullOrEmpty(pass.Name))
            sb.Append("            Name \"").Append(pass.Name).Append("\"\n");

        PrintTags(sb, pass.Tags, indent: "            ");
        PrintRenderState(sb, pass.State);

        // A pass whose program is not in the blob (no decompiled functions)
        // keeps its name, tags, render state and index, but gets no HLSL:
        // anything emitted here would be invented code that matches nothing.
        bool hasAnyFunction = pass.VertexFunction is not null || pass.FragmentFunction is not null
            || pass.GeometryFunction is not null || pass.HullFunction is not null
            || pass.DomainFunction is not null || pass.ComputeFunction is not null;

        if (!hasAnyFunction)
        {
            sb.Append("        }\n");
            return;
        }

        sb.Append("            HLSLPROGRAM\n");

        // Interpolator hand-off map: the vertex stage records which semantic
        // fields carry named values (worldPos, worldNormal, ...) so the
        // fragment stage can seed the matching input registers.
        var stageInterpolators = new Dictionary<string, string>();

        // Build cross-stage cbuffer variable rename mapping: when vert and
        // frag have different variables at the same byte offset within a
        // merged cbuffer, one variable is declared and the other's references
        // in the function body are redirected.
        var cbufferRenames = BuildCbufferRenameMap(pass);

        foreach (HlslResourceNode res in pass.Resources)
            PrintResource(sb, res, stripRegisterBindings, cbufferRenames);

        foreach (HlslStructNode s in pass.Structs)
            PrintStruct(sb, s);

        if (pass.VertexFunction is not null)
        {
            sb.Append("            #pragma vertex vert\n");
            PrintFunction(sb, pass.VertexFunction, pass.Cbuffers, fuseTemps, stageOutputs: stageInterpolators, resources: pass.Resources, cbufferRenames: cbufferRenames);
        }
        if (pass.FragmentFunction is not null)
        {
            sb.Append("            #pragma fragment frag\n");
            PrintFunction(sb, pass.FragmentFunction, pass.Cbuffers, fuseTemps, stageInputs: stageInterpolators, resources: pass.Resources, cbufferRenames: cbufferRenames);
        }
        foreach (HlslFunctionNode? f in new[] { pass.GeometryFunction, pass.HullFunction, pass.DomainFunction, pass.ComputeFunction })
            if (f is not null)
                PrintFunction(sb, f, pass.Cbuffers, fuseTemps, resources: pass.Resources, cbufferRenames: cbufferRenames);

        sb.Append("            ENDHLSL\n");
        sb.Append("        }\n");
    }

    private static void PrintRenderState(StringBuilder sb, HlslRenderState s)
    {
        sb.Append("            Cull ").Append(s.Cull).Append('\n');
        sb.Append("            ZTest ").Append(ZTestText(s.ZTest)).Append('\n');
        sb.Append("            ZWrite ").Append(s.ZWrite ? "On" : "Off").Append('\n');

        if (s.Lighting)
            sb.Append("            Lighting On\n");

        if (s.AlphaToMask)
            sb.Append("            AlphaToMask On\n");

        if (s.OffsetFactor != 0 || s.OffsetUnits != 0)
            sb.Append("            Offset ").Append(s.OffsetFactor).Append(", ").Append(s.OffsetUnits).Append('\n');

        if (!(s.Blend.SrcBlend == HlslBlendMode.One && s.Blend.DstBlend == HlslBlendMode.Zero))
        {
            sb.Append("            Blend ").Append(s.Blend.SrcBlend).Append(' ').Append(s.Blend.DstBlend);
            if (s.Blend.SrcBlendAlpha != s.Blend.SrcBlend || s.Blend.DstBlendAlpha != s.Blend.DstBlend)
                sb.Append(", ").Append(s.Blend.SrcBlendAlpha).Append(' ').Append(s.Blend.DstBlendAlpha);
            sb.Append('\n');
        }

        if (s.Blend.BlendOp != HlslBlendOp.Add)
            sb.Append("            BlendOp ").Append(s.Blend.BlendOp).Append('\n');

        if (s.StencilRef != 0 || s.StencilReadMask != 255 || s.StencilWriteMask != 255)
        {
            sb.Append("            Stencil\n            {\n");
            sb.Append("                Ref ").Append(s.StencilRef).Append('\n');
            sb.Append("                ReadMask ").Append(s.StencilReadMask).Append('\n');
            sb.Append("                WriteMask ").Append(s.StencilWriteMask).Append('\n');
            sb.Append("                Comp ").Append(ZTestText(s.StencilFront.Comp)).Append('\n');
            sb.Append("                Pass ").Append(s.StencilFront.Pass).Append('\n');
            sb.Append("                Fail ").Append(s.StencilFront.Fail).Append('\n');
            sb.Append("                ZFail ").Append(s.StencilFront.ZFail).Append('\n');
            sb.Append("            }\n");
        }
    }

    // Unity's ShaderLab spells the "always pass" compare function
    // "Always" like the others, but LessEqual is written "LEqual" and
    // GreaterEqual is "GEqual" — the one irregularity in an otherwise
    // 1:1 name mapping.
    private static string ZTestText(HlslCompareFunction f) => f switch
    {
        HlslCompareFunction.LessEqual => "LEqual",
        HlslCompareFunction.GreaterEqual => "GEqual",
        _ => f.ToString(),
    };

    // ---------- Stage 7: Resources ----------

    // When vert and frag have different variables at the same byte offset
    // within a merged cbuffer, one must be declared and the other's
    // references redirected.  Returns a map from the dropped variable name
    // to the declared variable name (possibly with an array index for
    // matrix-row renames).
    private static Dictionary<string, string> BuildCbufferRenameMap(HlslPassNode pass)
    {
        var renames = new Dictionary<string, string>();

        // Collect all variables per slot with their full metadata.
        // key = slot, value = list of (name, offset, sizeBytes, stage, isMatrix)
        var bySlot = new Dictionary<int, List<(string Name, int Offset, int SizeBytes, string Stage, bool IsMatrix)>>();
        foreach (var (key, cb) in pass.Cbuffers)
        {
            if (!bySlot.TryGetValue(key.Slot, out var list))
            {
                list = new List<(string, int, int, string, bool)>();
                bySlot[key.Slot] = list;
            }
            foreach (var v in cb.Variables)
                list.Add((v.Name, v.Offset, v.SizeBytes, key.Stage, v.IsMatrix));
        }

        bool IsMatrixName(string name) =>
            name.Contains("ObjectToWorld") || name.Contains("WorldToObject") ||
            name.Contains("MatrixVP") || name.Contains("MatrixV") ||
            name.Contains("MatrixMVP");

        foreach (var (_, vars) in bySlot)
        {
            // ---- Pass 1: exact-offset collisions (two names at same offset) ----
            var byOffset = vars.GroupBy(v => v.Offset);
            foreach (var og in byOffset)
            {
                var uniqueNames = og.Select(v => v.Name).Distinct().ToList();
                if (uniqueNames.Count <= 1) continue;

                bool hasMatrix = og.Any(v => v.IsMatrix || IsMatrixName(v.Name));
                string kept;
                if (hasMatrix)
                    kept = og.First(v => v.IsMatrix || IsMatrixName(v.Name)).Name;
                else if (og.Any(v => v.Stage == "Fragment"))
                    kept = og.First(v => v.Stage == "Fragment").Name;
                else
                    kept = uniqueNames[0];

                foreach (string removed in uniqueNames.Where(n => n != kept))
                {
                    bool keptIsMatrix = og.First(v => v.Name == kept).IsMatrix || IsMatrixName(kept);
                    string target = keptIsMatrix ? $"{kept}[0]" : kept;
                    renames[removed] = target;
                }
            }

            // ---- Pass 2: range overlaps (non-matrix var inside matrix span) ----
            var matrices = vars.Where(v => v.IsMatrix || IsMatrixName(v.Name))
                               .GroupBy(v => v.Name)
                               .Select(g => g.First())
                               .ToList();
            var nonMatrices = vars.Where(v => !(v.IsMatrix || IsMatrixName(v.Name))).ToList();

            foreach (var nv in nonMatrices)
            {
                if (renames.ContainsKey(nv.Name)) continue; // already handled
                foreach (var mv in matrices)
                {
                    if (nv.Offset >= mv.Offset && nv.Offset < mv.Offset + mv.SizeBytes)
                    {
                        int row = (nv.Offset - mv.Offset) / 16;
                        renames[nv.Name] = $"{mv.Name}[{row}]";
                        break;
                    }
                }
            }
        }

        return renames;
    }

    private static void PrintResource(StringBuilder sb, HlslResourceNode res, bool stripRegisterBindings, Dictionary<string, string>? cbufferRenames = null)
    {
        // Unity standard cbuffers are assigned to per-stage slots by Unity's
        // compiler from the cbuffer NAME alone — an explicit register binding
        // would conflict when vertex and fragment map the same name to
        // different slots (e.g. UnityPerCamera at b0 in vertex, b1 in
        // fragment).  Only emit register(bN) for non-Unity cbuffers.
        string reg = stripRegisterBindings && res.Kind is HlslResourceKind.Texture or HlslResourceKind.Sampler
            ? ""
            : (res.Kind == HlslResourceKind.ConstantBuffer && IsUnityCbuffer(res.Name))
                ? ""
                : RegisterBinding(res);
        string regSuffix = string.IsNullOrEmpty(reg) ? "" : " : " + reg;

        switch (res.Kind)
        {
            case HlslResourceKind.ConstantBuffer:
                // Unity's shader compilation pipeline auto-injects standard
                // cbuffers (UnityPerDraw, UnityPerFrame, UnityPerCamera, etc.)
                // before our HLSLPROGRAM code runs. Re-declaring them with the
                // same name causes "Duplicate constant buffer declaration".
                // Rename them while keeping ALL variables and the register
                // binding so the bytecode still reads from the correct slot.
                string cbufferName = IsUnityCbuffer(res.Name)
                    ? $"_{res.Name.TrimStart('_')}CB_b{res.Slot}"
                    : res.Name;

                sb.Append("            cbuffer ").Append(cbufferName);
                if (!string.IsNullOrEmpty(reg))
                    sb.Append(" : ").Append(reg);
                sb.Append("\n            {\n");
                // Emit packoffset for all non-synthetic variables.  When two
                // variables from different stages collide at the same register,
                // keep only the one that IS the rename target (the other stage's
                // references are redirected via CbufferVarRenames).
                var orderedAll = res.Variables
                    .OrderBy(v => v.Name == $"cb{res.Slot}_values" ? 1 : 0)
                    .ThenBy(v => v.Offset)
                    .ToList();

                bool hasSynthetic = orderedAll.Any(v =>
                    v.Name.StartsWith("cb") && v.Name.Contains("_values"));

                // Collect the set of names that are rename TARGETS — these
                // are the ones we keep when a collision happens.
                var renameTargets = new HashSet<string>();
                if (cbufferRenames is not null)
                    foreach (string target in cbufferRenames.Values)
                        renameTargets.Add(target);

                // Build the set of variable names to SKIP (the ones that
                // were renamed away).  A variable is skipped when:
                //  (a) it appears as a KEY in the rename map, AND
                //  (b) its target is also declared in this cbuffer.
                var skipNames = new HashSet<string>();
                if (cbufferRenames is not null)
                {
                    var declaredNames = new HashSet<string>(orderedAll.Select(v => v.Name));
                    foreach (var (old, target) in cbufferRenames)
                    {
                        string bareTarget = target.Contains('[') ? target[..target.IndexOf('[')] : target;
                        if (declaredNames.Contains(old) && declaredNames.Contains(bareTarget))
                            skipNames.Add(old);
                    }
                }

                // Emit packoffset for all non-synthetic cbuffers so each
                // variable lands at the byte offset the DXBC expects.
                // The overlap check below disables it when variables from
                // different physical cbuffers would collide (e.g. PicaVoxel
                // $Globals merged with UnityPerDraw at the same slot).
                bool needPackoffset = !hasSynthetic;
                if (needPackoffset)
                {
                    // Check for overlapping packoffset ranges among the
                    // non-skipped, non-synthetic variables.
                    var poRanges = new List<(uint start, uint end, string name)>();
                    foreach (HlslCBufferVariable v in orderedAll)
                    {
                        if (skipNames.Contains(v.Name) || (v.Name.StartsWith("cb") && v.Name.Contains("_values")))
                            continue;
                        bool isScalar = (v.TypeName == "float" || v.TypeName == "int" || v.TypeName == "uint")
                                        && v.Size <= 4 && v.ArraySize is null;
                        uint vSize = isScalar ? 4u : v.Size;
                        if (vSize == 0) vSize = 16;
                        uint start = v.Offset;
                        uint end = start + vSize;
                        foreach (var (ps, pe, pn) in poRanges)
                        {
                            if (start < pe && end > ps)
                            {
                                needPackoffset = false;
                                break;
                            }
                        }
                        if (!needPackoffset) break;
                        poRanges.Add((start, end, v.Name));
                    }
                }

                // Track which packoffset values are already taken to avoid
                // duplicate packoffset annotations.
                var usedPackOffsets = new HashSet<string>();

                foreach (HlslCBufferVariable v in orderedAll)
                {
                    if (skipNames.Contains(v.Name))
                        continue;
                    if (v.Name.StartsWith("cb") && v.Name.Contains("_values"))
                    {
                        // Synthetic fallback — no packoffset.
                        sb.Append("                ").Append(v.TypeName).Append(' ').Append(v.Name);
                        if (v.ArraySize is { } n)
                            sb.Append('[').Append(n).Append(']');
                        sb.Append(";\n");
                        continue;
                    }

                    sb.Append("                ").Append(v.TypeName).Append(' ').Append(v.Name);
                    if (v.ArraySize is { } arrLen)
                        sb.Append('[').Append(arrLen).Append(']');

                    if (needPackoffset)
                    {
                        uint cReg = v.Offset / 16;
                        uint withinReg = v.Offset % 16;
                        bool isScalar = (v.TypeName == "float" || v.TypeName == "int" || v.TypeName == "uint")
                                        && v.Size <= 4 && v.ArraySize is null;
                        string po;
                        if (withinReg > 0 || isScalar)
                        {
                            string comp = (withinReg / 4) switch
                            {
                                1 => ".y",
                                2 => ".z",
                                3 => ".w",
                                _ => ".x"
                            };
                            po = $"c{cReg}{comp}";
                        }
                        else
                        {
                            po = $"c{cReg}";
                        }

                        if (usedPackOffsets.Add(po))
                            sb.Append(" : packoffset(").Append(po).Append(')');
                    }
                    sb.Append(";\n");
                }
                sb.Append("            };\n");
                break;

            case HlslResourceKind.Texture:
                sb.Append("            ").Append(res.TypeHint ?? "Texture2D").Append(' ').Append(res.Name).Append(regSuffix).Append(";\n");
                break;

            case HlslResourceKind.Sampler:
                // TypeHint distinguishes a comparison sampler (used by
                // SampleCmp/GatherCmp) from a regular one.
                sb.Append("            ").Append(res.TypeHint ?? "SamplerState").Append(' ').Append(res.Name).Append(regSuffix).Append(";\n");
                break;

            case HlslResourceKind.Uav:
                sb.Append("            ").Append(res.TypeHint ?? "RWTexture2D").Append(' ').Append(res.Name).Append(" : ").Append(reg).Append(";\n");
                break;
        }
    }

    // Explicit register slot for a resource, recovered from the bytecode's
    // dcl_constantbuffer/dcl_resource/dcl_sampler (or the metadata slot map
    // for cbuffers): register(b0), register(t1), register(s2), ...
    private static string RegisterBinding(HlslResourceNode res) => res.Kind switch
    {
        HlslResourceKind.ConstantBuffer => $"register(b{res.Slot})",
        HlslResourceKind.Texture => $"register(t{res.Slot})",
        HlslResourceKind.Sampler => $"register(s{res.Slot})",
        HlslResourceKind.Uav => $"register(u{res.Slot})",
        _ => "",
    };

    // Unity auto-injects these standard cbuffers into HLSLPROGRAM blocks.
    // Re-declaring them causes "Duplicate constant buffer declaration".
    // $Globals (sanitized to _Globals) is Unity's per-material block that
    // is also auto-injected.
    private static bool IsUnityCbuffer(string name) =>
        name.StartsWith("Unity", StringComparison.Ordinal) || name == "_Globals";

    // ---------- Stage 8: Structs ----------

    private static void PrintStruct(StringBuilder sb, HlslStructNode s)
    {
        sb.Append("            struct ").Append(s.Name).Append("\n            {\n");
        foreach (HlslFieldNode f in s.Fields)
            sb.Append("                ").Append(f.TypeHint).Append(' ').Append(f.Name)
              .Append(" : ").Append(f.Semantic).Append(";\n");
        sb.Append("            };\n");
    }

    // ---------- Stage 9/10/11: Functions, statements, expressions ----------

    // Per-function mutable state the printer threads through recursion:
    // which (identifier) names have already been declared (so re-writes
    // to the same SSA generation don't re-declare).
    private sealed class PrintContext
    {
        public HashSet<string> Declared { get; } = new();

        // Cbuffer layout from the ShaderLab metadata (slot -> buffer),
        // used to render RDEF-less cbN[slot] reads as real variable names.
        public Dictionary<int, CbufferMetadata> Cbuffers { get; set; } = new();

        // Identifier each defining instruction actually declared for a
        // value, keyed by the value's structural identity (storage location
        // + SSA version), NOT by its rendered name string. Reads resolve
        // against this so a component that was written as part of a vector
        // renders as a swizzle off the DECLARED vector name (r0_xyz_5.x),
        // never as a view string that was never declared. Keying by
        // location rather than BaseIdentifier is essential: synthesized
        // registers (phi operands/destinations from IRStorageLocation
        // .ToRegister()) carry no SymbolicName, and name recovery can name
        // one instance differently from another — a string key would miss
        // and emit the raw temp name as a phantom identifier. "Same version
        // number" is NOT enough to infer co-write either: versions are
        // per-component counters (see IRSsaRenaming), so x and y can
        // independently reach the same version via separate writes.
        public Dictionary<(IRStorageLocation Location, int Version), (string Name, List<int> ActiveComponents)> DeclaredViews { get; } = new();

        // Shader stage of the function being printed — needed for
        // stage-sensitive HLSL (e.g. implicit-LOD Sample is invalid in a
        // vertex shader, which must use SampleLevel(..., 0)).
        public HlslShaderStage Stage { get; init; }

        // ISGN/OSGN elements grouped by register index, used to route
        // input/output component accesses to the correct struct field when
        // a register is packed with multiple disjoint-mask elements.
        public Dictionary<uint, List<SignatureElement>> InputElements { get; init; } = new();
        public Dictionary<uint, List<SignatureElement>> OutputElements { get; init; } = new();

        // Unity source macros whose recognized bytecode idioms were reverted
        // to macro calls (e.g. UnityObjectToClipPos). The printer emits a
        // #define for each before the function body so the pass still
        // compiles standalone. The define body is chosen to reproduce the
        // bytecode exactly, not a convenience approximation.
        public HashSet<string> Macros { get; } = new();

        // Texture resource type by register slot (e.g. "Texture2D",
        // "TextureCube"), so a texture op can render its coordinate with the
        // component count the intrinsic demands.
        public Dictionary<int, string> TextureTypeBySlot { get; } = new();

        // Sampler variable name by register slot — used so RenderRegisterRead
        // emits the same name the declaration used (Unity-recognised inline
        // names like "sampler_linear_clamp" instead of bare "s0").
        public Dictionary<int, string> SamplerNameBySlot { get; } = new();

        // Texture variable name by register slot — used so RenderRegisterRead
        // emits the Property-matched name (e.g. "_MainTex") instead of "t0".
        public Dictionary<int, string> TextureNameBySlot { get; } = new();

        // Cross-stage cbuffer variable renames: when vert and frag have
        // different variables at the same packoffset within a merged
        // cbuffer, one variable is declared and the other's references in
        // the function body are redirected here.
        public Dictionary<string, string> CbufferVarRenames { get; } = new();
    }

    private static void PrintFunction(
        StringBuilder sb,
        HlslFunctionNode fn,
        Dictionary<(int Slot, string Stage), CbufferMetadata> allCbuffers,
        bool fuseTemps,
        Dictionary<string, string>? stageInputs = null,
        Dictionary<string, string>? stageOutputs = null,
        List<HlslResourceNode>? resources = null,
        Dictionary<string, string>? cbufferRenames = null)
    {
        string outType = fn.OutputStruct?.Name ?? "void";
        string inType = fn.InputStruct?.Name ?? "";
        string inParam = fn.InputStruct is null ? "" : $"{inType} i";

        sb.Append("            ").Append(outType).Append(' ').Append(fn.Name).Append('(').Append(inParam).Append(")\n            {\n");

        // Filter the pass-wide cbuffer table down to the ones this stage
        // actually binds (its own stage, plus any shared "" entries) —
        // different stages can bind different buffers to the same slot.
        string stage = fn.Stage.ToString();
        var cbuffers = new Dictionary<int, CbufferMetadata>();
        foreach (var (key, cb) in allCbuffers)
            if (key.Stage == stage || key.Stage == "")
                cbuffers[key.Slot] = cb;

        var ctx = new PrintContext
        {
            Cbuffers = cbuffers,
            Stage = fn.Stage,
            InputElements = fn.InputElementsByRegister,
            OutputElements = fn.OutputElementsByRegister,
        };
        if (cbufferRenames is not null)
            foreach (var (old, fresh) in cbufferRenames)
                ctx.CbufferVarRenames[old] = fresh;
        if (resources is not null)
            foreach (HlslResourceNode res in resources)
            {
                if (res.Kind == HlslResourceKind.Texture)
                {
                    ctx.TextureTypeBySlot[(int)res.Slot] = res.TypeHint ?? "Texture2D";
                    ctx.TextureNameBySlot[(int)res.Slot] = res.Name;
                }
                if (res.Kind == HlslResourceKind.Sampler)
                    ctx.SamplerNameBySlot[(int)res.Slot] = res.Name;
            }

        if (fn.OutputStruct is not null)
            sb.Append("                ").Append(outType).Append(" o = (").Append(outType).Append(")0;\n");

        HlslSemanticNaming.Apply(fn.Statements, cbuffers, stageInputs, stageOutputs);

        if (fuseTemps)
            HlslFuseTemps.Apply(fn.Statements, MaxFuseNodes);

        // Buffer the body so the Unity macro defines collected during
        // printing (ctx.Macros) can be emitted ahead of the statements that
        // use them. Preprocessor directives are legal anywhere in a
        // function body, so the standalone-compile contract is preserved.
        var body = new StringBuilder();
        PrintBlock(body, fn.Statements, indent: 4, ctx);

        // DXBC functions return through a `ret` instruction; a switch (or an
        // if whose merge tail got attached to the last case) can leave the
        // printer's last case holding the return, so the function falls
        // through. A trailing return is harmless when unreachable.
        if (fn.OutputStruct is not null
            && (fn.Statements.Statements.Count == 0 || fn.Statements.Statements[^1] is not HlslReturnStatement))
            body.Append("                return o;\n");

        foreach (string name in ctx.Macros.OrderBy(n => n))
            sb.Append("                ").Append(MacroDefine(name)).Append('\n');

        // Whole-function passes. First scalar lane splits whose uses are all
        // clean collapse back into vector swizzle uses (CollapseScalarLanes),
        // then 4x4 outer-product accumulation blocks rebuild into matrix
        // multiplies (CollapseMatrixMul), then common math idioms (normalize,
        // dot, lerp, vector-by-matrix mul) simplify. Must run after
        // PrintBlock so every use in the body is visible.
        sb.Append(HlslMathSimplify.Simplify(body.ToString()));
        sb.Append("            }\n");
    }

    // The #define for a recognized source macro. The body is the bytecode's
    // exact computation — UnityObjectToClipPos expands to mul(UNITY_MATRIX_MVP,
    // v), and the shipped D3D bytecode (and this decompiled output) uses
    // unity_MatrixVP, so mul(unity_MatrixVP, v) reproduces the instructions.
    // UnityObjectToWorldPos appends w=1, which is exactly what the bytecode's
    // bare `+ unity_ObjectToWorld[3]` translation tail implies.
    private static string MacroDefine(string name) => name switch
    {
        "UnityObjectToClipPos" => "#define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)",
        "UnityObjectToWorldPos" => "#define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))",
        "LinearEyeDepth" => "#define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))",
        "Linear01Depth" => "#define Linear01Depth(d) (1.0 / (_ZBufferParams.x * (d) + _ZBufferParams.y))",
        _ => $"#define {name}(v) /* TODO: unrecognized macro {name} */ (v)",
    };

    private static void PrintBlock(StringBuilder sb, HlslBlockStatement block, int indent, PrintContext ctx)
    {
        string pad = new(' ', indent * 4);
        List<HlslStatementNode> stmts = block.Statements;
        int i = 0;
        while (i < stmts.Count)
        {
            // Runs of consecutive assignment statements are rendered together
            // so consecutive single-component extracts off the same full
            // expression can be collapsed into one vector temp (see
            // CollapseExtractChains) — the bytecode computes the value once
            // into a register, and re-rendering the RHS per lane multiplies
            // both the fetch cost and the output size.
            if (stmts[i] is HlslAssignmentStatement or HlslMultiAssignmentStatement)
            {
                int j = i;
                while (j < stmts.Count && stmts[j] is HlslAssignmentStatement or HlslMultiAssignmentStatement)
                    j++;

                var lines = new List<string>();
                for (int k = i; k < j; k++)
                    lines.AddRange(RenderStatementLines(stmts[k], ctx));

                foreach (string line in CollapseExtractChains(RevertUnityMacros(lines, ctx), ctx))
                    sb.Append(pad).Append(line).Append('\n');
                i = j;
            }
            else
            {
                PrintStatement(sb, stmts[i], indent, ctx);
                i++;
            }
        }
    }

    private static IEnumerable<string> RenderStatementLines(HlslStatementNode stmt, PrintContext ctx) => stmt switch
    {
        HlslAssignmentStatement a => RenderAssignmentLines(a.Destination, a.Expression, ctx),
        HlslMultiAssignmentStatement ma => ma.Destinations
            .Zip(ma.Expressions)
            .Where(p => p.First is not null)
            .SelectMany(p => RenderAssignmentLines(p.First!, p.Second, ctx)),
        _ => throw new InvalidOperationException($"not an assignment: {stmt.GetType().Name}"),
    };

}
