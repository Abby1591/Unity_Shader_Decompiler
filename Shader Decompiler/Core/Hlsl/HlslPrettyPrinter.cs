using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Parser.DXBC.Chunks;
using Parser.DXBC.Instructions;
using Parser.DXBC.IR;
using Parser.Core.Analysis;
using Parser.DXBC.Metadata;

namespace Parser.Core.Hlsl.Ast;

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
public static class HlslPrettyPrinter
{
    // Cap for Stage 13.5 temp fusion: a def is only inlined into its one
    // consumer when the resulting expression stays under this many IR
    // nodes. Keeps long transform chains readable instead of collapsing
    // into one giant nested expression.
    private const int MaxFuseNodes = 16;

    public static string Print(HlslShaderNode shader, bool fuseTemps = true)
    {
        var sb = new StringBuilder();
        sb.Append("Shader \"").Append(shader.Name).Append("\"\n{\n");

        PrintProperties(sb, shader.Properties);

        foreach (HlslSubShaderNode ss in shader.SubShaders)
            PrintSubShader(sb, ss, fuseTemps);

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

    private static void PrintSubShader(StringBuilder sb, HlslSubShaderNode ss, bool fuseTemps)
    {
        sb.Append("    SubShader\n    {\n");
        PrintTags(sb, ss.Tags, indent: "        ");
        if (ss.Lod is { } lod)
            sb.Append("        LOD ").Append(lod).Append('\n');

        foreach (HlslPassNode pass in ss.Passes)
            PrintPass(sb, pass, fuseTemps);

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

    private static void PrintPass(StringBuilder sb, HlslPassNode pass, bool fuseTemps)
    {
        sb.Append("        Pass\n        {\n");
        if (!string.IsNullOrEmpty(pass.Name))
            sb.Append("            Name \"").Append(pass.Name).Append("\"\n");

        PrintTags(sb, pass.Tags, indent: "            ");
        PrintRenderState(sb, pass.State);

        sb.Append("            HLSLPROGRAM\n");

        // Interpolator hand-off map: the vertex stage records which semantic
        // fields carry named values (worldPos, worldNormal, ...) so the
        // fragment stage can seed the matching input registers.
        var stageInterpolators = new Dictionary<string, string>();

        foreach (HlslResourceNode res in pass.Resources)
            PrintResource(sb, res);

        foreach (HlslStructNode s in pass.Structs)
            PrintStruct(sb, s);

        if (pass.VertexFunction is not null)
        {
            sb.Append("            #pragma vertex vert\n");
            PrintFunction(sb, pass.VertexFunction, pass.Cbuffers, fuseTemps, stageOutputs: stageInterpolators, resources: pass.Resources);
        }
        if (pass.FragmentFunction is not null)
        {
            sb.Append("            #pragma fragment frag\n");
            PrintFunction(sb, pass.FragmentFunction, pass.Cbuffers, fuseTemps, stageInputs: stageInterpolators, resources: pass.Resources);
        }
        foreach (HlslFunctionNode? f in new[] { pass.GeometryFunction, pass.HullFunction, pass.DomainFunction, pass.ComputeFunction })
            if (f is not null)
                PrintFunction(sb, f, pass.Cbuffers, fuseTemps, resources: pass.Resources);

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

    private static void PrintResource(StringBuilder sb, HlslResourceNode res)
    {
        string reg = RegisterBinding(res);

        switch (res.Kind)
        {
            case HlslResourceKind.ConstantBuffer:
                // Raw `cbuffer` (not Unity's CBUFFER_START/END macros) so the
                // output compiles standalone — ShaderLab accepts it too. The
                // register binding pins it to the slot the bytecode actually
                // reads (dcl_constantbuffer cbN), not declaration order.
                sb.Append("            cbuffer ").Append(res.Name).Append(" : ").Append(reg).Append("\n            {\n");
                // HLSL infers each member's byte offset from its textual
                // declaration order when there's no : packoffset(...), so the
                // order must match the reflected layout. Sort by real offset;
                // the synthesized cbN_values fallback array has a fake Offset
                // (0) and is pure filler for reads that didn't resolve to a
                // named member, so pin it to the end where it can't shift a
                // real member's inferred offset.
                var ordered = res.Variables
                    .OrderBy(v => v.Name == $"cb{res.Slot}_values" ? 1 : 0)
                    .ThenBy(v => v.Offset)
                    .ToList();
                foreach (HlslCBufferVariable v in ordered)
                    sb.Append("                ").Append(v.TypeName).Append(' ').Append(v.Name)
                      .Append(v.ArraySize is { } n ? $"[{n}]" : "").Append(";\n");
                sb.Append("            };\n");
                break;

            case HlslResourceKind.Texture:
                sb.Append("            ").Append(res.TypeHint ?? "Texture2D").Append(' ').Append(res.Name).Append(" : ").Append(reg).Append(";\n");
                break;

            case HlslResourceKind.Sampler:
                // TypeHint distinguishes a comparison sampler (used by
                // SampleCmp/GatherCmp) from a regular one.
                sb.Append("            ").Append(res.TypeHint ?? "SamplerState").Append(' ').Append(res.Name).Append(" : ").Append(reg).Append(";\n");
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
    }

    private static void PrintFunction(
        StringBuilder sb,
        HlslFunctionNode fn,
        Dictionary<(int Slot, string Stage), CbufferMetadata> allCbuffers,
        bool fuseTemps,
        Dictionary<string, string>? stageInputs = null,
        Dictionary<string, string>? stageOutputs = null,
        List<HlslResourceNode>? resources = null)
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
        if (resources is not null)
            foreach (HlslResourceNode res in resources)
                if (res.Kind == HlslResourceKind.Texture)
                    ctx.TextureTypeBySlot[(int)res.Slot] = res.TypeHint ?? "Texture2D";

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

        foreach (string name in ctx.Macros.OrderBy(n => n))
            sb.Append("                ").Append(MacroDefine(name)).Append('\n');

        // Whole-function passes. First scalar lane splits whose uses are all
        // clean collapse back into vector swizzle uses (CollapseScalarLanes),
        // then 4x4 outer-product accumulation blocks rebuild into matrix
        // multiplies (CollapseMatrixMul). Must run after PrintBlock so every
        // use in the body is visible.
        sb.Append(CollapseMatrixMul(CollapseScalarLanes(body.ToString())));
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

    // Collapses runs of consecutive single-component extracts that render the
    // SAME full-width RHS, e.g.
    //
    //     float r1_x_9 = (t2.Sample(s0, float4(...))).x;
    //     float r1_y_10 = (t2.Sample(s0, float4(...))).y;
    //     float r1_z_9 = (t2.Sample(s0, float4(...))).z;
    //     float r1_w_3 = (t2.Sample(s0, float4(...))).w;
    //
    // into
    //
    //     float4 r1_xyzw_9 = t2.Sample(s0, float4(...));
    //     float r1_x_9 = r1_xyzw_9.x;
    //     float r1_y_10 = r1_xyzw_9.y;
    //     float r1_z_9 = r1_xyzw_9.z;
    //     float r1_w_3 = r1_xyzw_9.w;
    //
    // This is strictly faithful: every extract computed the identical value
    // (the rendered RHS is textually the same), the lanes are the destination
    // register's own lanes (same base name), and the bytecode holds the value
    // in one register — one materialization + lane reads is what the source
    // instructions actually did. The temp is named after the destination
    // register's first lane version (r1_xyzw_9); a name collision with a real
    // co-write of the same register is impossible going forward (versions only
    // increase, and a shared co-write version exceeds every lane's) and is
    // skipped if an earlier declaration already owns it.
    private static readonly System.Text.RegularExpressions.Regex ExtractChainPattern =
        new(@"^(?<decl>float )?(?<dest>[A-Za-z_][A-Za-z0-9_]*_[xyzw](?:_[0-9]+)?) = \((?<expr>.+)\)\.(?<comp>[xyzw]);$");

    private static List<string> CollapseExtractChains(List<string> lines, PrintContext ctx)
    {
        var result = new List<string>(lines.Count);
        int i = 0;
        while (i < lines.Count)
        {
            System.Text.RegularExpressions.Match m = ExtractChainPattern.Match(lines[i]);
            // A chain-eligible line must re-render a "heavy" RHS (a call or
            // constructor) — a bare register read extract (E = "r4_xyzw_5")
            // has no `(` and is left alone (it is already as compact as the
            // direct resolve would be).
            if (!m.Success || !m.Groups["expr"].Value.Contains('('))
            {
                result.Add(lines[i]);
                i++;
                continue;
            }

            int j = i + 1;
            while (j < lines.Count)
            {
                System.Text.RegularExpressions.Match m2 = ExtractChainPattern.Match(lines[j]);
                if (!m2.Success || m2.Groups["expr"].Value != m.Groups["expr"].Value)
                    break;
                j++;
            }

            if (j - i < 2)
            {
                result.Add(lines[i]);
                i++;
                continue;
            }

            // Only collapse when every lane writes the same base register
            // (r1_x_9, r1_y_10, ... all from r1) so the temp name is the
            // register's own and the reads are plain lane swizzles.
            string baseName = ExtractChainPattern.Match(lines[i]).Groups["dest"].Value;
            bool sameBase = true;
            for (int k = i + 1; k < j; k++)
            {
                string other = ExtractChainPattern.Match(lines[k]).Groups["dest"].Value;
                if (LaneBaseName(other) != LaneBaseName(baseName))
                {
                    sameBase = false;
                    break;
                }
            }
            if (!sameBase)
            {
                result.Add(lines[i]);
                i++;
                continue;
            }

            string temp = TempName(baseName, ctx);
            if (temp is null)
            {
                result.Add(lines[i]);
                i++;
                continue;
            }
            ctx.Declared.Add(temp);

            result.Add($"float4 {temp} = {m.Groups["expr"].Value};");
            for (int k = i; k < j; k++)
            {
                System.Text.RegularExpressions.Match mk = ExtractChainPattern.Match(lines[k]);
                string decl = mk.Groups["decl"].Success ? "float " : "";
                result.Add($"{decl}{mk.Groups["dest"].Value} = {temp}.{mk.Groups["comp"].Value};");
            }
            i = j;
        }

        return result;
    }

    private static string LaneBaseName(string laneName) =>
        System.Text.RegularExpressions.Regex.Replace(laneName, @"_[xyzw](?:_[0-9]+)?$", "");

    private static string? TempName(string dest, PrintContext ctx)
    {
        // dest is a single-lane name like "r1_x_9" or "r1_x".
        string bare = LaneBaseName(dest);
        string version = System.Text.RegularExpressions.Regex.Match(dest, @"_([xyzw])_([0-9]+)$") is { Success: true } m
            ? m.Groups[2].Value
            : "";
        string candidate = version.Length > 0 ? $"{bare}_xyzw_{version}" : $"{bare}_xyzw";
        return ctx.Declared.Contains(candidate) ? null : candidate;
    }

    // ---------- Scalar-lane collapsing ----------
    //
    // When the bytecode consumes the lanes of a vector individually, the
    // leave-SSA materialization renders the value as a vector temp plus four
    // scalar lane reads:
    //
    //     float4 r5_xyzw_5 = (r4_y_9.xxxx * unity_ObjectToWorld[1]);
    //     float r5_x_5 = r5_xyzw_5.x;
    //     float r5_y_4 = r5_xyzw_5.y;
    //     float r5_z_4 = r5_xyzw_5.z;
    //     float r5_w_1 = r5_xyzw_5.w;
    //     float4 r5_xyzw_6 = mad(unity_ObjectToWorld[0], r4_x_7.xxxx, float4(r5_x_5, r5_y_4, r5_z_4, r5_w_1));
    //
    // Every downstream use of those scalars is equivalent to the same use of
    // the vector's lanes, so when all uses are one of
    //   (a) a float2/3/4(...) constructor whose every argument is a lane of
    //       this vector     -> V.xyzw (or the matching swizzle; plain V when
    //                            the swizzle is the identity xyzw)
    //   (b) a same-lane splat like r5_y_4.xxxx   -> V.yyyy
    //   (c) a bare scalar reference              -> V.y
    // the whole detour collapses: constructors/splats/refs are rewritten and
    // the four split declarations are dropped. Strictly faithful — each case
    // selects exactly the same lanes of the same register. Runs once per
    // function body (temp names repeat across vertex/fragment stages), so
    // uses anywhere in the same body are visible; any unexpected use aborts
    // the whole group and leaves it untouched.
    private static readonly System.Text.RegularExpressions.Regex ScalarSplitGroupPattern =
        new(@"^float (?<sx>\w+_x_\d+) = (?<V>\w+_xyzw_\d+)\.x;" +
            @"\nfloat (?<sy>\w+_y_\d+) = \k<V>\.y;" +
            @"\nfloat (?<sz>\w+_z_\d+) = \k<V>\.z;" +
            @"\nfloat (?<sw>\w+_w_\d+) = \k<V>\.w;$");

    private static readonly System.Text.RegularExpressions.Regex ScalarCtorPattern =
        new(@"float(?:2|3|4)\(\s*(?<args>[^()]+?)\s*\)");

    private static readonly System.Text.RegularExpressions.Regex ScalarNamePattern =
        new(@"\b\w+_[xyzw]_\d+\b");

    private static readonly System.Text.RegularExpressions.Regex ScalarSplatPattern =
        new(@"\.[xyzw]+");

    // ---------- Matrix-multiply reconstruction ----------
    //
    // The D3D compiler sometimes scalarizes a 4x4 matrix multiply into an
    // outer-product accumulation, one result row at a time, materializing
    // each row as a separate float3 temp with four mad/mul steps:
    //
    //     float3 objectToView0_xyz_1 = ((unity_ObjectToWorld[0].yyyy * unity_MatrixV[1].xyzx)).xyz;
    //     float3 objectToView0_xyz_2 = (mad(unity_MatrixV[0].xyzx, unity_ObjectToWorld[0].xxxx, objectToView0_xyz_1.xyzx)).xyz;
    //     float3 objectToView0_xyz_3 = (mad(unity_MatrixV[2].xyzx, unity_ObjectToWorld[0].zzzz, objectToView0_xyz_2.xyzx)).xyz;
    //     float3 objectToView0_xyz_4 = (mad(unity_MatrixV[3].xyzx, unity_ObjectToWorld[0].wwww, objectToView0_xyz_3.xyzx)).xyz;
    //     ... rows 1..3 identically ...
    //
    // Row i accumulates Σ_k A[i][k] * M[k].xyz — exactly row i of mul(A, M) —
    // where A is the operand whose row index tracks the result row ([i]) and M
    // is the operand whose row index is summed ([k]). When all four rows are
    // present and consistent, the 16 statements collapse to
    //
    //     float4x4 objectToView = mul(unity_ObjectToWorld, unity_MatrixV);
    //
    // and the four final row temps (version _4, the only ones ever consumed
    // downstream) are rewritten to P[0..3]. Strictly faithful: mul(A,M)[i].xyz
    // selects exactly the same lanes. Guards: A's component swizzle is a splat
    // of one of x/y/z/w, M's swizzle starts with xyz (so the .xyz cast selects
    // the matrix-product components), the (component, M-index) pairs cover
    // exactly {(x,0),(y,1),(z,2),(w,3)}, the same A and M across all rows, and
    // the intermediate row temps (_1.._3) never appear outside the block.
    private static readonly System.Text.RegularExpressions.Regex MatrixMulLine =
        new(@"^\s*float3 (?<T>\w+?)(?<r>[0-3])_xyz_1 = \(\((?<a>\S+?) \* (?<b>\S+?)\)\)\.xyz;\s*$");
    private static readonly System.Text.RegularExpressions.Regex MatrixMadLine =
        new(@"^\s*float3 (?<T>\w+?)(?<r>[0-3])_xyz_(?<v>[2-4]) = \(mad\((?<m1>\S+?), (?<m2>\S+?), (?<acc>\w+?)\.[xyzw]+\)\)\.xyz;\s*$");
    private static readonly System.Text.RegularExpressions.Regex MatrixTermPattern =
        new(@"^(?<m>\w+)\[(?<idx>\d+)\]\.(?<swz>[xyzw]+)$");

    private readonly record struct MatrixTerm(string Matrix, int Index, string Swizzle);

    private static string CollapseScalarLanes(string body)
    {
        // Fixpoint: each single pass collapses the vector->scalar splits whose
        // uses are all clean. A pass that rewrites a scalar-copy chain (e.g.
        // r5_x_6 = r4_x_4 -> r5_x_6 = r4_xyzw_4.x) can leave a fresh 4-line
        // group behind for the next pass, so iterate until stable. Every pass
        // only removes lines and rewrites uses to vector lane reads — the text
        // strictly shrinks, so this terminates.
        while (true)
        {
            string next = CollapseScalarLanesOnce(body);
            if (next == body)
                return body;
            body = next;
        }
    }

    private static string CollapseScalarLanesOnce(string body)
    {
        string[] lines = body.Split('\n');
        var drop = new bool[lines.Length];
        var edits = new Dictionary<int, List<(int Start, int Len, string Rep)>>();
        int i = 0;
        while (i + 3 < lines.Length)
        {
            string four = string.Join("\n",
                new[] { lines[i], lines[i + 1], lines[i + 2], lines[i + 3] }.Select(l => l.Trim()));
            System.Text.RegularExpressions.Match m = ScalarSplitGroupPattern.Match(four);
            if (!m.Success)
            {
                i++;
                continue;
            }

            string V = m.Groups["V"].Value;
            string sx = m.Groups["sx"].Value, sy = m.Groups["sy"].Value,
                   sz = m.Groups["sz"].Value, sw = m.Groups["sw"].Value;
            var lane = new Dictionary<string, char> { { sx, 'x' }, { sy, 'y' }, { sz, 'z' }, { sw, 'w' } };

            bool clean = true;
            var groupEdits = new List<(int Line, int Start, int Len, string Rep)>();
            for (int k = 0; k < lines.Length && clean; k++)
            {
                if (k >= i && k <= i + 3)
                    continue;
                string t = lines[k];

                // (a) whole-constructor units first, so their args aren't
                // re-processed as bare refs below.
                var covered = new List<(int Start, int Len)>();
                foreach (System.Text.RegularExpressions.Match cm in ScalarCtorPattern.Matches(t))
                {
                    string[] args = cm.Groups["args"].Value.Split(',').Select(a => a.Trim()).ToArray();
                    if (args.All(a => lane.ContainsKey(a)))
                    {
                        string swz = string.Concat(args.Select(a => lane[a]));
                        groupEdits.Add((k, cm.Index, cm.Length, swz == "xyzw" ? V : $"{V}.{swz}"));
                        covered.Add((cm.Index, cm.Length));
                    }
                }

                // (b)+(c) individual occurrences.
                foreach (System.Text.RegularExpressions.Match nm in ScalarNamePattern.Matches(t))
                {
                    if (!lane.TryGetValue(nm.Value, out char lc))
                        continue;
                    if (covered.Any(c => nm.Index >= c.Start && nm.Index < c.Start + c.Len))
                        continue;

                    int after = nm.Index + nm.Value.Length;
                    if (after < t.Length && t[after] == '.')
                    {
                        System.Text.RegularExpressions.Match sm = ScalarSplatPattern.Match(t, after);
                        if (!sm.Success || sm.Index != after)
                        {
                            clean = false;
                            break;
                        }
                        string suffix = sm.Value.Substring(1);
                        if (suffix.Any(c => c != suffix[0]))
                        {
                            clean = false; // mixed swizzle on a scalar — not a clean lane splat
                            break;
                        }
                        groupEdits.Add((k, nm.Index, sm.Index + sm.Length - nm.Index, $"{V}.{new string(lc, suffix.Length)}"));
                    }
                    else if (after < t.Length &&
                             (char.IsLetterOrDigit(t[after]) || t[after] == '_' || t[after] == '[' || t[after] == '('))
                    {
                        clean = false; // unexpected attachment — leave the group alone
                        break;
                    }
                    else
                    {
                        groupEdits.Add((k, nm.Index, nm.Value.Length, $"{V}.{lc}"));
                    }
                }
            }

            if (clean)
            {
                drop[i] = drop[i + 1] = drop[i + 2] = drop[i + 3] = true;
                foreach ((int li, int st, int ln, string rep) in groupEdits)
                {
                    if (!edits.TryGetValue(li, out var list))
                        edits[li] = list = new List<(int, int, string)>();
                    list.Add((st, ln, rep));
                }
            }
            i += 4;
        }

        var sb = new StringBuilder(body.Length);
        bool first = true;
        for (int k = 0; k < lines.Length; k++)
        {
            if (drop[k])
                continue;
            // Skip the empty element produced by the input's trailing '\n';
            // it is restored below so the output's line structure matches.
            if (k == lines.Length - 1 && lines[k].Length == 0)
                continue;
            string line = lines[k];
            if (edits.TryGetValue(k, out var list))
                foreach ((int st, int ln, string rep) in list.OrderByDescending(e => e.Start))
                    line = line.Substring(0, st) + rep + line.Substring(st + ln);
            if (!first)
                sb.Append('\n');
            sb.Append(line);
            first = false;
        }
        if (body.Length > 0 && body[body.Length - 1] == '\n')
            sb.Append('\n');
        return sb.ToString();
    }

    // Whole-function matrix-multiply reconstruction: collapse the 4x4 outer-
    // product accumulation blocks (16 statements) into `float4x4 P = mul(A,M);`
    // and rewrite the final row temps P{i}_xyz_4 to P[i]. See the pattern
    // documentation above the MatrixMulLine regex for the exact shape and the
    // faithfulness argument. Scans every 16-line window; a block that fails any
    // guard is left untouched.
    private static string CollapseMatrixMul(string body)
    {
        string[] lines = body.Split('\n');
        var drop = new bool[lines.Length];
        var insert = new Dictionary<int, string>();
        var renames = new List<(string Old, string New)>();

        int i = 0;
        while (i + 15 < lines.Length)
        {
            if (!TryParseMatrixBlock(lines, i, out string prefix, out string aMat, out string mMat))
            {
                i++;
                continue;
            }

            // Intermediates (_1.._3) must never be consumed outside the block,
            // and at least one final (_4) row must be, or the collapse is dead.
            string intermediatePattern = $@"(?<!\w){Regex.Escape(prefix)}[0-3]_xyz_[123](?!\w)";
            string finalPattern = $@"(?<!\w){Regex.Escape(prefix)}[0-3]_xyz_4(?!\w)";
            bool clean = true;
            bool anyUse = false;
            for (int k = 0; k < lines.Length && clean; k++)
            {
                if (k >= i && k < i + 16)
                    continue;
                if (Regex.IsMatch(lines[k], intermediatePattern))
                {
                    clean = false;
                    break;
                }
                if (Regex.IsMatch(lines[k], finalPattern))
                    anyUse = true;
            }
            if (!clean || !anyUse)
            {
                i++;
                continue;
            }

            for (int r = 0; r < 4; r++)
                for (int v = 1; v <= 4; v++)
                    drop[i + r * 4 + v - 1] = true;

            string indent = new(lines[i].TakeWhile(char.IsWhiteSpace).ToArray());
            insert[i] = $"{indent}float4x4 {prefix} = mul({aMat}, {mMat});";
            for (int r = 0; r < 4; r++)
                renames.Add(($"{prefix}{r}_xyz_4", $"{prefix}[{r}]"));
            i += 16;
        }

        if (!drop.Any(d => d))
            return body;

        var sb = new StringBuilder(body.Length);
        bool first = true;
        for (int k = 0; k < lines.Length; k++)
        {
            if (drop[k])
            {
                if (insert.TryGetValue(k, out string decl))
                    AppendBodyLine(sb, ref first, decl);
                continue;
            }
            if (k == lines.Length - 1 && lines[k].Length == 0)
                continue;
            string line = lines[k];
            foreach ((string old, string neu) in renames)
                line = Regex.Replace(line, $@"(?<!\w){Regex.Escape(old)}(?!\w)", neu);
            AppendBodyLine(sb, ref first, line);
        }
        if (body.Length > 0 && body[body.Length - 1] == '\n')
            sb.Append('\n');
        return sb.ToString();
    }

    private static void AppendBodyLine(StringBuilder sb, ref bool first, string line)
    {
        if (!first)
            sb.Append('\n');
        sb.Append(line);
        first = false;
    }

    // Parses the 4-row × 4-statement block at lines[start..start+15] as a
    // mul(A, M) accumulation. On success sets the shared prefix (result-matrix
    // name) and the two matrix operands.
    private static bool TryParseMatrixBlock(string[] lines, int start, out string prefix, out string aMat, out string mMat)
    {
        prefix = aMat = mMat = "";
        string? p = null, a = null, m = null;
        for (int r = 0; r < 4; r++)
        {
            if (!TryParseMatrixRow(lines, start + r * 4, r, out string rowPrefix, out string rowA, out string rowM))
                return false;
            if (p is null)
            {
                p = rowPrefix;
                a = rowA;
                m = rowM;
            }
            else if (rowPrefix != p || rowA != a || rowM != m)
            {
                return false;
            }
        }
        prefix = p!;
        aMat = a!;
        mMat = m!;
        return true;
    }

    // Parses one result row: the bare-mul statement (the seed term, one
    // (component, M-index) pair) plus the three mad accumulations. Row i must
    // be A[i].{splat} * M[k].xyz, summed over k = 0..3, with the A-operand the
    // one whose matrix index equals the row index.
    private static bool TryParseMatrixRow(string[] lines, int start, int r, out string prefix, out string aMat, out string mMat)
    {
        prefix = aMat = mMat = "";
        System.Text.RegularExpressions.Match mul = MatrixMulLine.Match(lines[start]);
        if (!mul.Success)
            return false;
        string t = mul.Groups["T"].Value;
        if (!TryParseMatrixTerm(mul.Groups["a"].Value, out MatrixTerm ta) ||
            !TryParseMatrixTerm(mul.Groups["b"].Value, out MatrixTerm tb))
            return false;

        // A's operand is a single-component splat (xxxx/yyyy/zzzz/wwww), M's is
        // a multi-component one starting with xyz. Classify by swizzle shape,
        // NOT by matrix index: the summed index k can equal the row index r
        // (row 0 sums M[0]), so the index alone is ambiguous.
        MatrixTerm a, m;
        if (IsSplat(ta.Swizzle) && tb.Swizzle.StartsWith("xyz")) { a = ta; m = tb; }
        else if (IsSplat(tb.Swizzle) && ta.Swizzle.StartsWith("xyz")) { a = tb; m = ta; }
        else
            return false;
        if (a.Index != r || m.Index is < 0 or > 3)
            return false;

        var pairs = new Dictionary<char, int> { [a.Swizzle[0]] = m.Index };
        for (int v = 2; v <= 4; v++)
        {
            System.Text.RegularExpressions.Match mad = MatrixMadLine.Match(lines[start + v - 1]);
            if (!mad.Success)
                return false;
            if (mad.Groups["T"].Value != t || mad.Groups["r"].Value != r.ToString() ||
                mad.Groups["v"].Value != v.ToString() ||
                mad.Groups["acc"].Value != $"{t}{r}_xyz_{v - 1}")
                return false;
            if (!TryParseMatrixTerm(mad.Groups["m1"].Value, out MatrixTerm t1) ||
                !TryParseMatrixTerm(mad.Groups["m2"].Value, out MatrixTerm t2))
                return false;

            MatrixTerm a2, m2;
            if (IsSplat(t1.Swizzle) && t2.Swizzle.StartsWith("xyz")) { a2 = t1; m2 = t2; }
            else if (IsSplat(t2.Swizzle) && t1.Swizzle.StartsWith("xyz")) { a2 = t2; m2 = t1; }
            else
                return false;
            if (a2.Matrix != a.Matrix || a2.Index != a.Index ||
                m2.Matrix != m.Matrix || m2.Index is < 0 or > 3)
                return false;
            pairs[a2.Swizzle[0]] = m2.Index;
        }

        if (pairs.Count != 4)
            return false;
        foreach (var (c, k) in pairs)
        {
            int expected = c switch { 'x' => 0, 'y' => 1, 'z' => 2, 'w' => 3, _ => -1 };
            if (k != expected)
                return false;
        }

        prefix = t;
        aMat = a.Matrix;
        mMat = m.Matrix;
        return true;
    }

    private static bool TryParseMatrixTerm(string s, out MatrixTerm term)
    {
        System.Text.RegularExpressions.Match m = MatrixTermPattern.Match(s);
        if (!m.Success)
        {
            term = default;
            return false;
        }
        term = new MatrixTerm(m.Groups["m"].Value, int.Parse(m.Groups["idx"].Value), m.Groups["swz"].Value);
        return true;
    }

    private static bool IsSplat(string swz) =>
        swz.Length == 4 && swz.All(c => c == swz[0]);

    // float4(x, x, x, x) with x a scalar stays as-is: d3dcompiler's strict
    // mode rejects the single-argument broadcast form float4(x) (X3014:
    // "incorrect number of arguments"), so there is no shorter faithful form.

    // ---------- Unity source-macro reversion ----------
    //
    // The Unity `UnityObjectToClipPos(v)` idiom is `mul(UNITY_MATRIX_MVP, v)`,
    // which the D3D compiler emits as a row-by-row mad chain:
    //
    //     float4 clipPos_xyzw_2 = mad(unity_MatrixVP[0], X.xxxx, (X.yyyy * unity_MatrixVP[1]));
    //     float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], X.zzzz, clipPos_xyzw_2);
    //     o.sv_Position0.xyzw = mad(unity_MatrixVP[3], X.wwww, clipPos_xyzw_3);
    //
    // (or fully inlined into one line, or ending in a temp that is copied to
    // the output). Recognized and reverted to:
    //
    //     o.sv_Position0.xyzw = UnityObjectToClipPos(X);
    //
    // with `#define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)` emitted
    // ahead of the body, so the reversion reproduces the bytecode's matrix
    // multiply exactly. Guards are strict — every row {0,1,2,3} used exactly
    // once, each multiplied by the matching single lane of the SAME source
    // register, all chain temps single-use, nothing else in the expression —
    // and any doubt leaves the statements untouched.
    private static readonly System.Text.RegularExpressions.Regex ClipPosOutLine =
        new(@"^o\.sv_Position0\.xyzw = (.+);$");
    private static readonly System.Text.RegularExpressions.Regex TempDefLine =
        new(@"^float4 (\w+) = (.+);$");
    private static readonly System.Text.RegularExpressions.Regex RowRead =
        new(@"^unity_MatrixVP\[([0-9]+)\]$");
    private static readonly System.Text.RegularExpressions.Regex ObjectToWorldRowRead =
        new(@"^unity_ObjectToWorld\[([0-9]+)\]$");
    private static readonly System.Text.RegularExpressions.Regex LaneSplat =
        new(@"^([A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)?)\.([xyzw])\3\3\3$");
    private static readonly System.Text.RegularExpressions.Regex SimpleIdentifier =
        new(@"^[A-Za-z_][A-Za-z0-9_]*$");
    private static readonly System.Text.RegularExpressions.Regex SimpleSource =
        new(@"^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)?$");
    // `LHS = (mad(unity_ObjectToWorld[3].xyzx, SRC.wwww, T.xyzx)).xyz;` — a
    // re-derivation of the translation-add tail. Since the chain's final add is
    // bare (SRC.w folded to 1), this equals `LHS = <final>.xyz;`.
    private static readonly System.Text.RegularExpressions.Regex RecomputeLine =
        new(@"^(?<lhs>[^=]+?) = \(mad\(unity_ObjectToWorld\[3\]\.xyzx, (?<src>[^,]+?)\.wwww, (?<t>[^,]+?)\.xyzx\)\)\.xyz;$");

    private static List<string> RevertUnityMacros(List<string> lines, PrintContext ctx)
    {
        if (lines.Count < 2)
            return lines;

        var result = new List<string>(lines.Count);
        var rewrites = new Dictionary<string, string>();
        int i = 0;
        while (i < lines.Count)
        {
            // A translation-tail re-derivation flagged by an earlier worldPos
            // collapse: `LHS = ... T.xyzx ... .xyz` → `LHS = final.xyz`.
            if (rewrites.TryGetValue(lines[i], out var rewrite))
            {
                result.Add(rewrite);
                i++;
                continue;
            }

            var outMatch = ClipPosOutLine.Match(lines[i]);
            if (outMatch.Success && TryCollapseClipTransform(lines, outMatch.Groups[1].Value, i, out var srcName, out var usedTemps))
            {
                ctx.Macros.Add("UnityObjectToClipPos");
                // The chain temps are now dead — remove their def lines from the
                // tail of the run (single-use check guarantees no other reference).
                for (int k = result.Count - 1; k >= 0; k--)
                {
                    var t = TempDefLine.Match(result[k]);
                    if (!t.Success || !usedTemps.Contains(t.Groups[1].Value))
                        break;
                    result.RemoveAt(k);
                }
                result.Add($"o.sv_Position0.xyzw = UnityObjectToClipPos({srcName});");
                i++;
                continue;
            }

            // UnityObjectToWorldPos: `float4 W = <mul chain over xyz> + unity_ObjectToWorld[3];`
            var worldMatch = TempDefLine.Match(lines[i]);
            if (worldMatch.Success && TryCollapseObjectToWorldPos(lines, worldMatch.Groups[2].Value, i, worldMatch.Groups[1].Value, out var worldSrc, out var worldTemps, out var worldRewrites))
            {
                ctx.Macros.Add("UnityObjectToWorldPos");
                foreach (var kv in worldRewrites)
                    rewrites[kv.Key] = kv.Value;
                for (int k = result.Count - 1; k >= 0; k--)
                {
                    var t = TempDefLine.Match(result[k]);
                    if (!t.Success || !worldTemps.Contains(t.Groups[1].Value))
                        break;
                    result.RemoveAt(k);
                }
                result.Add($"float4 {worldMatch.Groups[1].Value} = UnityObjectToWorldPos({worldSrc}.xyz);");
                i++;
                continue;
            }

            result.Add(lines[i]);
            i++;
        }
        return result;
    }

    // Returns true and sets srcName when lines[i] (o.sv_Position0.xyzw = E;)
    // is a pure mul(unity_MatrixVP, X) chain over the SAME vector register X.
    private static bool TryCollapseClipTransform(List<string> lines, string rhs, int i, out string srcName, out HashSet<string> usedTemps)
    {
        srcName = "";
        usedTemps = new HashSet<string>();

        // Build the map of float4 temp defs directly above the final line.
        var temps = new Dictionary<string, (string Expr, int Line)>();
        for (int k = i - 1; k >= 0; k--)
        {
            var td = TempDefLine.Match(lines[k]);
            if (!td.Success)
                break;
            temps[td.Groups[1].Value] = (td.Groups[2].Value, k);
        }

        var terms = new List<(int Row, string Src, char Lane)>();
        if (!ParseRowSum(rhs, temps, usedTemps, i, terms))
        {
            return false;
        }
        if (terms.Count != 4)
            return false;

        int[] rows = new int[4];
        string src = "";
        foreach (var (row, s, lane) in terms)
        {
            if (row < 0 || row > 3)
                return false;
            rows[row]++;
            // lane letter must match the row index (row i * lane i).
            if (lane != "xyzw"[row])
                return false;
            if (src.Length == 0)
                src = s;
            else if (src != s)
                return false; // lanes of different registers — skip
        }
        if (rows.Any(r => r != 1))
            return false;
        if (!SimpleIdentifier.IsMatch(src))
            return false;

        // Chain temps must be single-use: each must not appear anywhere in the
        // run outside its own definition and the consumed chain lines.
        foreach (string t in usedTemps)
        {
            if (!temps.TryGetValue(t, out var td))
                return false;
            int total = CountTokenOccurrences(lines, t);
            int inChain = CountTokenOccurrences(lines, td.Line, i, t);
            if (total != inChain)
                return false;
        }

        srcName = src;
        return true;
    }

    // Recursively decomposes a rendered RHS into the set of unity_MatrixVP
    // row terms it adds. Temp reads are inlined from their definitions.
    private static bool ParseRowSum(
        string expr,
        Dictionary<string, (string Expr, int Line)> temps,
        HashSet<string> usedTemps,
        int finalLine,
        List<(int Row, string Src, char Lane)> terms)
    {
        expr = expr.Trim();
        while (expr.StartsWith('(') && expr.EndsWith(')'))
            expr = expr[1..^1].Trim();

        // A temp accumulation read → inline its definition.
        if (SimpleIdentifier.IsMatch(expr) && temps.TryGetValue(expr, out var td))
        {
            usedTemps.Add(expr);
            return ParseRowSum(td.Expr, temps, usedTemps, finalLine, terms);
        }

        if (expr.StartsWith("mad(") && expr.EndsWith(')'))
        {
            List<string> args = SplitTopLevelArgs(expr[4..^1]);
            if (args.Count != 3)
                return false;
            if (!TryRowTerm(args[0], args[1], out var term))
                return false;
            terms.Add(term);
            return ParseRowSum(args[2], temps, usedTemps, finalLine, terms);
        }

        // A top-level mul is the base row term; a top-level add joins two
        // sub-sums. After paren-stripping the expr is already unparenthesized.
        int op = FindTopLevelOperator(expr);
        if (op < 0)
            return false;
        string left = expr[..op].Trim();
        string right = expr[(op + 1)..].Trim();
        if (expr[op] == '*')
            return TryRowTerm(left, right, out var mulTerm) && AddFinalTerm(mulTerm, terms);
        if (expr[op] == '+')
            return ParseRowSum(left, temps, usedTemps, finalLine, terms)
                && ParseRowSum(right, temps, usedTemps, finalLine, terms);
        return false;
    }

    private static bool AddFinalTerm((int Row, string Src, char Lane) term, List<(int Row, string Src, char Lane)> terms)
    {
        terms.Add(term);
        return true;
    }

    // One operand must be a unity_MatrixVP row read and the other a single-lane
    // splat of a register (X.xxxx) — the row term of the matrix multiply.
    private static bool TryRowTerm(string a, string b, out (int Row, string Src, char Lane) term)
    {
        term = default;
        var rowMatch = RowRead.Match(a.Trim());
        var laneMatch = LaneSplat.Match(b.Trim());
        if (rowMatch.Success && laneMatch.Success)
        {
            term = (int.Parse(rowMatch.Groups[1].Value), laneMatch.Groups[1].Value, laneMatch.Groups[3].Value[0]);
            return true;
        }
        rowMatch = RowRead.Match(b.Trim());
        laneMatch = LaneSplat.Match(a.Trim());
        if (rowMatch.Success && laneMatch.Success)
        {
            term = (int.Parse(rowMatch.Groups[1].Value), laneMatch.Groups[1].Value, laneMatch.Groups[3].Value[0]);
            return true;
        }
        return false;
    }

    private static List<string> SplitTopLevelArgs(string s)
    {
        var parts = new List<string>();
        int depth = 0;
        var sb = new System.Text.StringBuilder();
        foreach (char c in s)
        {
            if (c is '(' or '[') depth++;
            else if (c is ')' or ']') depth--;
            if (c == ',' && depth == 0) { parts.Add(sb.ToString()); sb.Clear(); }
            else sb.Append(c);
        }
        if (sb.Length > 0) parts.Add(sb.ToString());
        return parts;
    }

    // Index of the top-level '*' or '+' operator in an unparenthesized
    // expression (bracket depth tracked so unity_MatrixVP[1] doesn't count).
    private static int FindTopLevelOperator(string expr)
    {
        int depth = 0;
        for (int k = 0; k < expr.Length; k++)
        {
            char c = expr[k];
            if (c is '(' or '[') depth++;
            else if (c is ')' or ']') depth--;
            else if (depth == 0 && (c is '*' or '+')) return k;
        }
        return -1;
    }

    // Returns true and sets srcName when lines[i] (`float4 NAME = E;`) computes
    // mul(unity_ObjectToWorld, SRC) over lanes x,y,z plus the translation row —
    // Unity's UnityObjectToWorldPos. The bare `+ unity_ObjectToWorld[3]` tail
    // proves the w multiplier folded to the constant 1, so the macro's appended
    // 1.0 reproduces the bytecode exactly.
    private static bool TryCollapseObjectToWorldPos(List<string> lines, string rhs, int i, string finalName, out string srcName, out HashSet<string> usedTemps, out Dictionary<string, string> rewrites)
    {
        srcName = "";
        usedTemps = new HashSet<string>();
        rewrites = new Dictionary<string, string>();

        // Build the map of float4 temp defs directly above the final line.
        var temps = new Dictionary<string, (string Expr, int Line)>();
        for (int k = i - 1; k >= 0; k--)
        {
            var td = TempDefLine.Match(lines[k]);
            if (!td.Success)
                break;
            temps[td.Groups[1].Value] = (td.Groups[2].Value, k);
        }

        var terms = new List<(int Row, string Src, char Lane)>();
        bool hasTranslation = false;
        if (!ParseObjectToWorldSum(rhs, temps, usedTemps, terms, ref hasTranslation))
            return false;
        if (!hasTranslation || terms.Count != 3)
            return false;

        int[] rows = new int[3];
        string src = "";
        foreach (var (row, s, lane) in terms)
        {
            if (row < 0 || row > 2)
                return false;
            rows[row]++;
            // lane letter must match the row index (row i * lane i), and only
            // lanes x,y,z appear — the w row is the folded translation.
            if (lane != "xyz"[row])
                return false;
            if (src.Length == 0)
                src = s;
            else if (src != s)
                return false; // lanes of different registers — skip
        }
        if (rows.Any(r => r != 1))
            return false;
        if (!SimpleSource.IsMatch(src))
            return false;

        // Chain temps must be single-use: each must not appear anywhere in the
        // run outside its own definition and the consumed chain lines — except
        // for a re-derivation of the translation tail (`LHS = ... T.xyzx ...
        // .xyz`), which is equal to `LHS = finalName.xyz` and gets rewritten.
        foreach (string t in usedTemps)
        {
            if (!temps.TryGetValue(t, out var td))
                return false;
            int total = CountTokenOccurrences(lines, t);
            int inChain = CountTokenOccurrences(lines, td.Line, i, t);
            if (total < inChain)
                return false;
            for (int k = 0; k < lines.Count; k++)
            {
                if (k >= td.Line && k <= i)
                    continue;
                int occ = CountTokenOccurrences(lines, k, k, t);
                if (occ == 0)
                    continue;
                if (occ != 1 || !TryParseRecompute(lines[k], t, src, finalName, out var rep))
                    return false;
                rewrites[lines[k]] = rep;
            }
        }

        srcName = src;
        return true;
    }

    // Recognizes a translation-tail re-derivation `LHS = (mad(unity_ObjectToWorld
    // [3].xyzx, SRC.wwww, T.xyzx)).xyz;` and rewrites it to `LHS = <final>.xyz;`.
    private static bool TryParseRecompute(string line, string t, string src, string finalName, out string replacement)
    {
        replacement = "";
        var m = RecomputeLine.Match(line);
        if (!m.Success || m.Groups["t"].Value != t || m.Groups["src"].Value != src)
            return false;
        replacement = $"{m.Groups["lhs"].Value} = {finalName}.xyz;";
        return true;
    }

    // Recursively decomposes a rendered RHS into the set of unity_ObjectToWorld
    // row terms it sums (rows 0..2, lanes x..z) plus the translation tail
    // `+ unity_ObjectToWorld[3]`. Temp reads are inlined from their definitions.
    private static bool ParseObjectToWorldSum(
        string expr,
        Dictionary<string, (string Expr, int Line)> temps,
        HashSet<string> usedTemps,
        List<(int Row, string Src, char Lane)> terms,
        ref bool hasTranslation)
    {
        expr = expr.Trim();
        while (expr.StartsWith('(') && expr.EndsWith(')'))
            expr = expr[1..^1].Trim();

        // A temp accumulation read → inline its definition.
        if (SimpleIdentifier.IsMatch(expr) && temps.TryGetValue(expr, out var td))
        {
            usedTemps.Add(expr);
            return ParseObjectToWorldSum(td.Expr, temps, usedTemps, terms, ref hasTranslation);
        }

        if (expr.StartsWith("mad(") && expr.EndsWith(')'))
        {
            List<string> args = SplitTopLevelArgs(expr[4..^1]);
            if (args.Count != 3)
                return false;
            if (!TryObjectToWorldRowTerm(args[0], args[1], out var term))
                return false;
            terms.Add(term);
            return ParseObjectToWorldSum(args[2], temps, usedTemps, terms, ref hasTranslation);
        }

        // After paren-stripping the expr is already unparenthesized.
        int op = FindTopLevelOperator(expr);
        if (op < 0)
            return false;
        string left = expr[..op].Trim();
        string right = expr[(op + 1)..].Trim();
        if (expr[op] == '*')
            return TryObjectToWorldRowTerm(left, right, out var mulTerm) && AddFinalTerm(mulTerm, terms);
        if (expr[op] == '+')
        {
            // The translation tail: `... + unity_ObjectToWorld[3]`. A bare add
            // (no w-lane multiplier) is the proof w folded to the constant 1.
            if (right == "unity_ObjectToWorld[3]")
            {
                hasTranslation = true;
                return ParseObjectToWorldSum(left, temps, usedTemps, terms, ref hasTranslation);
            }
            return ParseObjectToWorldSum(left, temps, usedTemps, terms, ref hasTranslation)
                && ParseObjectToWorldSum(right, temps, usedTemps, terms, ref hasTranslation);
        }
        return false;
    }

    // One operand must be a unity_ObjectToWorld row read and the other a
    // single-lane splat of a register (X.xxxx) — the row term of the multiply.
    private static bool TryObjectToWorldRowTerm(string a, string b, out (int Row, string Src, char Lane) term)
    {
        term = default;
        var rowMatch = ObjectToWorldRowRead.Match(a.Trim());
        var laneMatch = LaneSplat.Match(b.Trim());
        if (rowMatch.Success && laneMatch.Success)
        {
            term = (int.Parse(rowMatch.Groups[1].Value), laneMatch.Groups[1].Value, laneMatch.Groups[3].Value[0]);
            return true;
        }
        rowMatch = ObjectToWorldRowRead.Match(b.Trim());
        laneMatch = LaneSplat.Match(a.Trim());
        if (rowMatch.Success && laneMatch.Success)
        {
            term = (int.Parse(rowMatch.Groups[1].Value), laneMatch.Groups[1].Value, laneMatch.Groups[3].Value[0]);
            return true;
        }
        return false;
    }

    private static int CountTokenOccurrences(List<string> lines, string token) =>
        CountTokenOccurrences(lines, 0, lines.Count - 1, token);

    private static int CountTokenOccurrences(List<string> lines, int lo, int hi, string token)
    {
        int count = 0;
        for (int k = lo; k <= hi; k++)
            count += System.Text.RegularExpressions.Regex.Matches(lines[k], $"\\b{token}\\b").Count;
        return count;
    }

    private static void PrintStatement(StringBuilder sb, HlslStatementNode stmt, int indent, PrintContext ctx)
    {
        string pad = new(' ', indent * 4);

        switch (stmt)
        {
            case HlslIfStatement iff:
            {
                // Cross-branch phi copies (IRLeaveSsa writes the same
                // post-merge name at the top level of BOTH arms) must have
                // their declaration hoisted above the if. Declared per-arm,
                // the name is scoped to that arm's braces and dies at the
                // `}` — the sibling arm's write and any post-merge read
                // would then reference an identifier never in scope.
                foreach ((string name, int comps) in CrossBranchMergeNames(iff, ctx))
                {
                    if (!ctx.Declared.Add(name))
                        continue; // already in scope — don't redeclare
                    sb.Append(pad).Append(DeclType(comps)).Append(' ').Append(name).Append(";\n");
                }

                sb.Append(pad).Append("if (").Append(RenderExpression(iff.Condition, ctx)).Append(")\n");
                sb.Append(pad).Append("{\n");
                PrintBlock(sb, iff.Then, indent + 1, ctx);
                sb.Append(pad).Append("}\n");
                if (iff.Else is not null)
                {
                    sb.Append(pad).Append("else\n").Append(pad).Append("{\n");
                    PrintBlock(sb, iff.Else, indent + 1, ctx);
                    sb.Append(pad).Append("}\n");
                }
                break;
            }

            case HlslLoopStatement loop:
            {
                // Names first written at the loop body's top level. A
                // declaration that lands inside the loop's braces is scoped
                // to the loop; a name that is also live out of the loop
                // (read or written after it) then references an identifier
                // that never comes back into scope. Hoist the declaration
                // above the loop. Hoisting loop-local names too is harmless
                // (they are always written in the body, never unused) and
                // is the only way to catch loop-carried names without a
                // full dataflow pass.
                foreach ((string name, int comps) in LoopCarriedDeclNames(loop, ctx))
                {
                    if (!ctx.Declared.Add(name))
                        continue; // already in scope — don't redeclare
                    sb.Append(pad).Append(DeclType(comps)).Append(' ').Append(name).Append(";\n");
                }

                sb.Append(pad).Append("[loop]\n").Append(pad).Append("while (true)\n").Append(pad).Append("{\n");
                PrintBlock(sb, loop.Body, indent + 1, ctx);
                sb.Append(pad).Append("}\n");
                break;
            }

            case HlslSwitchStatement sw:
                sb.Append(pad).Append("switch (").Append(RenderExpression(sw.Selector, ctx)).Append(")\n").Append(pad).Append("{\n");
                foreach (HlslSwitchCase c in sw.Cases)
                {
                    sb.Append(pad).Append(c.Value is null ? "default:\n" : $"case {RenderExpression(c.Value, ctx)}:\n");
                    PrintBlock(sb, c.Body, indent + 1, ctx);
                }
                sb.Append(pad).Append("}\n");
                break;

            case HlslBreakStatement b:
                sb.Append(pad).Append(b.Condition is null ? "break;" : $"if ({RenderExpression(b.Condition, ctx)}) break;").Append('\n');
                break;

            case HlslContinueStatement c:
                sb.Append(pad).Append(c.Condition is null ? "continue;" : $"if ({RenderExpression(c.Condition, ctx)}) continue;").Append('\n');
                break;

            case HlslReturnStatement r:
                sb.Append(pad).Append(r.Condition is null
                    ? "return o;"
                    : $"if ({RenderExpression(r.Condition, ctx)}) return o;").Append('\n');
                break;

            case HlslDiscardStatement d:
                sb.Append(pad).Append("if (").Append(RenderExpression(d.Condition, ctx)).Append(") discard;\n");
                break;

            case HlslMemoryStoreStatement ms:
                sb.Append(pad).Append(RenderRegisterRead(ms.Resource, ctx))
                  .Append('[').Append(RenderExpression(ms.Address, ctx)).Append("] = ")
                  .Append(RenderExpression(ms.Value, ctx)).Append(";\n");
                break;

            case HlslRawStatement raw:
                sb.Append(pad).Append("// TODO: unhandled IR node — ").Append(raw.Source).Append('\n');
                break;
        }
    }

    // ---------- register/identifier rendering (the actual fix) ----------
    //
    // IRRegister.ToStringAs() is documented as debug-display only — its
    // SSA suffix comma-joins per-component version numbers and keeps the
    // ".xyz" dot-swizzle, neither of which is a legal HLSL identifier
    // ("r0.xyz_1,1,1" doesn't compile). Each vector component is actually
    // an independently-versioned scalar SSA value (see IRRegister's own
    // SsaVersion doc comment), so real HLSL needs one legal identifier
    // per (register, component, version) — this section builds those
    // instead of reusing the debug string.

    private const string ComponentLetters = "xyzw";

    // Which source-register component each active "slot" reads, in
    // output order. Mirrors IRRegister's private Mask/Swizzle/Select1
    // logic (duplicated here since that logic is private to IRRegister —
    // it only needs the public Mask/Swizzle/Component/ComponentMode
    // fields, so this is a small, safe duplication, not a guess).
    private static List<int> ActiveComponents(IRRegister reg) => reg.ComponentMode switch
    {
        Operand.OperandComponentMode.Mask => MaskIndices(reg.Mask),
        Operand.OperandComponentMode.Swizzle => new List<int>
        {
            reg.Swizzle & 3, (reg.Swizzle >> 2) & 3, (reg.Swizzle >> 4) & 3, (reg.Swizzle >> 6) & 3,
        },
        Operand.OperandComponentMode.Select1 => new List<int> { reg.Component },
        _ => new List<int> { 0, 1, 2, 3 }, // no mask/swizzle info — assume all 4 live
    };

    private static List<int> MaskIndices(byte mask)
    {
        var result = new List<int>();
        if ((mask & 1) != 0) result.Add(0);
        if ((mask & 2) != 0) result.Add(1);
        if ((mask & 4) != 0) result.Add(2);
        if ((mask & 8) != 0) result.Add(3);
        return result;
    }

    private static string BaseIdentifier(IRRegister reg, PrintContext ctx)
    {
        if (reg.SymbolicName is not null)
            return reg.SymbolicName;

        return reg.RegisterType switch
        {
            RegisterType.Temp => $"r{reg.Index}",
            RegisterType.IndexableTemp => IndexedName("x", reg, ctx),
            RegisterType.Input => $"v{reg.Index}",
            RegisterType.Output => $"o{reg.Index}",
            RegisterType.Resource => $"t{reg.Index}",
            RegisterType.Sampler => $"s{reg.Index}",
            RegisterType.ConstantBuffer => CbufferElementName(reg, ctx),
            _ => $"{reg.RegisterType.ToString().ToLowerInvariant()}{reg.Index}",
        };
    }

    // RDEF-less cbuffer reads: HlslAstBuilder declares a synthesized
    // `float4 cbN_values[K]` (one element per accessed 16-byte slot), so a
    // read of register `cbN[elem]` renders as cbN_values[elem]. With RDEF,
    // BaseIdentifier returns the bound SymbolicName instead and this is
    // never reached.
    private static string CbufferElementName(IRRegister reg, PrintContext ctx)
    {
        if (reg.Indices.Count < 2)
            return IndexedName("cb", reg, ctx);

        IRExpression? relative = reg.RelativeIndices.Length > 1 ? reg.RelativeIndices[1] : null;
        string elem = relative is not null
            ? (reg.Indices[1] != 0 ? $"{RenderExpression(relative, ctx)} + {reg.Indices[1]}" : RenderExpression(relative, ctx))
            : reg.Indices[1].ToString();

        return $"cb{reg.Indices[0]}_values[{elem}]";
    }

    // The full cbuffer read, in priority order:
    //   1. RDEF/Stage-1 bound names (SymbolicName) — real identifier + swizzle;
    //   2. ShaderLab-metadata layout — cbN[slot] resolves to the variable
    //      whose byte range covers the read (unity_ObjectToWorld[0], _M_map_ST);
    //   3. synthesized cbN_values[slot] fallback array.
    private static string RenderCbufferRead(IRRegister reg, PrintContext ctx)
    {
        if (reg.SymbolicName is not null)
            return reg.SymbolicName + MaskOrSwizzleSuffix(reg);

        if (reg.Indices.Count >= 2
            && ctx.Cbuffers.TryGetValue((int)reg.Indices[0], out CbufferMetadata? cb)
            && ResolveCbufferRead(cb, reg) is { } named)
        {
            return named;
        }

        return CbufferElementName(reg, ctx) + MaskOrSwizzleSuffix(reg);
    }

    // Maps a cbN[reg] register read (plus its component swizzle) onto a
    // metadata variable by byte range, producing the HLSL identifier:
    //   - whole-variable read            -> bare name (_M_map_ST)
    //   - partial vector read            -> name + relative swizzle (_Color.xz)
    //   - matrix row read                -> name[row] (+ swizzle)
    // Array variables defer to the cbN_values fallback.
    // Returns null when no listed variable covers the read (partial layout).
    internal static string? ResolveCbufferRead(CbufferMetadata cb, IRRegister reg)
    {
        int[] comps = ReadComponentIndices(reg).ToArray();
        if (comps.Length == 0)
            return null;

        var distinct = comps.Distinct().OrderBy(c => c).ToArray();
        uint elem = reg.Indices[1];
        uint byteStart = elem * 16 + (uint)distinct[0] * 4;
        uint byteEnd = elem * 16 + (uint)distinct[^1] * 4 + 4;

        CbufferVariableMetadata? best = null;
        int bestSize = int.MaxValue;
        foreach (CbufferVariableMetadata v in cb.Variables)
        {
            if ((long)v.Offset <= byteStart && (long)v.Offset + v.SizeBytes >= byteEnd && v.SizeBytes < bestSize)
            {
                best = v;
                bestSize = v.SizeBytes;
            }
        }

        if (best is null)
            return null;

        uint rel = byteStart - (uint)best.Offset;
        string letters = string.Concat(comps.Select(c => ComponentLetters[c]));
        string swizzle = distinct.Length == 4 && distinct[0] == 0 && distinct[^1] == 3
            ? ""
            : "." + letters;

        if (best.IsMatrix || best.RowCount > 0)
        {
            if (best.ArraySize > 0)
                return null; // array-of-matrices: defer to cbN_values fallback

            uint row = rel / 16;
            return $"{best.Name}[{row}]{swizzle}";
        }

        if (best.ArraySize > 0)
            return null; // array reads: defer to cbN_values fallback

        // Read covers the whole variable — but only when the read is NOT a
        // broadcast (repeated components). A swizzle like .xxyz on a float3
        // ADDS a component and must keep its suffix; dropping it narrows the
        // expression (float3) so a later .w read on the result breaks.
        if (comps.Length == distinct.Length && bestSize == distinct.Length * 4 && rel == 0)
            return best.Name;

        int vsc = (int)(rel / 4);
        string letters2 = string.Concat(comps.Select(c => ComponentLetters[vsc + (c - distinct[0])]));
        return best.Name + "." + letters2;
    }

    // Component indices the read touches, in order (with repeats for a
    // swizzle). Mirrors MaskOrSwizzleSuffix's mode dispatch.
    private static List<int> ReadComponentIndices(IRRegister reg) => reg.ComponentMode switch
    {
        Operand.OperandComponentMode.Mask when reg.Mask != 0 => MaskIndices(reg.Mask),
        Operand.OperandComponentMode.Swizzle => ActiveComponents(reg),
        Operand.OperandComponentMode.Select1 => new List<int> { reg.Component },
        _ => new List<int> { 0 },
    };

    // cbuffer/indexable-temp registers carry TWO index slots (buffer/array
    // number, then element offset) in reg.Indices/RelativeIndices, not
    // just reg.Index — reg.Index alone would silently drop the element
    // offset (e.g. render "cb0" instead of "cb0[8]" for an unbound
    // constant-buffer read). Mirrors IRRegister.IndexToString's handling
    // of dynamic/relative indices (cb0[r2.x + 4]) via the same public
    // fields, since that logic is private to IRRegister.
    private static string IndexedName(string prefix, IRRegister reg, PrintContext ctx)
    {
        if (reg.Indices.Count == 0)
            return $"{prefix}{reg.Index}";

        string Slot(int i)
        {
            IRExpression? relative = i < reg.RelativeIndices.Length ? reg.RelativeIndices[i] : null;
            if (relative is not null)
            {
                uint constOffset = reg.Indices.Count > i ? reg.Indices[i] : 0;
                return constOffset != 0 ? $"{RenderExpression(relative, ctx)} + {constOffset}" : RenderExpression(relative, ctx);
            }
            return reg.Indices.Count > i ? reg.Indices[i].ToString() : "0";
        }

        return reg.Indices.Count >= 2
            ? $"{prefix}{Slot(0)}[{Slot(1)}]"
            : $"{prefix}{Slot(0)}";
    }

    // Scalar per-(register,component,version) identifier — always a
    // legal, unique C-style identifier. A versionless result is NOT an
    // implicit input (real function inputs are RegisterType.Input and
    // render via i.field in RenderRegisterRead, never here); for a temp it
    // means the register was never written on this reaching path — a
    // don't-care the phi-fallback guard in RenderAssignmentLines handles
    // by either dropping the copy or declaring the scalar uninitialized.
    private static string ScalarIdentifier(IRRegister reg, int component, PrintContext ctx)
    {
        string bare = BaseIdentifier(reg, ctx);
        int? version = reg.SsaVersion[component];
        return version is { } v
            ? $"{bare}_{ComponentLetters[component]}_{v}"
            : $"{bare}_{ComponentLetters[component]}";
    }

    // Reads a Temp/IndexableTemp register for use on the RHS of an
    // expression. Every active component is resolved to the identifier its
    // defining instruction actually declared (see PrintContext.DeclaredViews):
    //   - components co-written by one instruction share a vector name and
    //     read as a swizzle off it (r0.xyz -> r0_xyz_5, r0.x -> r0_xyz_5.x);
    //   - components written separately — even ones that coincidentally
    //     share a version number, since versions are per-component counters —
    //     build a constructor from their own declared names
    //     (float2(r0_xy_5.x, r0_w_2)).
    // The old heuristic (collapse whenever versions match) emitted view
    // strings like r0_x_1 that were never declared anywhere.
    private static string RenderTempRead(IRRegister reg, PrintContext ctx)
    {
        List<int> active = ActiveComponents(reg);
        if (active.Count == 0)
            return BaseIdentifier(reg, ctx);

        if (active.Count == 1)
            return ResolveComponent(reg, active[0], ctx);

        var resolved = active.Select(c =>
        {
            int? version = reg.SsaVersion[c];
            if (version is { } v
                && ctx.DeclaredViews.TryGetValue((LocationOf(reg, c), v), out (string Name, List<int> Active) entry))
                return (Comp: c, Name: entry.Name, Active: entry.Active);
            return (Comp: c, Name: ScalarIdentifier(reg, c, ctx), Active: new List<int> { c });
        }).ToList();

        string firstName = resolved[0].Name;
        List<int> declared = resolved[0].Active;
        if (resolved.All(r => r.Name == firstName))
        {
            // A scalar declared name (one active component) broadcasts one
            // value into every slot — HLSL scalars only permit .x repeats,
            // so the swizzle must be all 'x' no matter which logical
            // component (y/z/w) the scalar originally came from. Vector
            // names swizzle positionally: each read component's slot in
            // the declared vector comes from IndexOf, not its original
            // register letter (a float2 declared from components y,z reads
            // its z-slot as ".y", not ".z").
            string readLetters = declared.Count == 1
                ? new string('x', active.Count)
                : string.Concat(active.Select(c => ComponentLetters[declared.IndexOf(c)]));
            string declaredLetters = string.Concat(declared.Select(c => ComponentLetters[c]));
            return declaredLetters == readLetters
                ? firstName
                : $"{firstName}.{readLetters}";
        }

        return $"float{active.Count}({string.Join(", ", resolved.Select(r => ComponentView(r.Name, r.Active, r.Comp)))})";
    }

    // Renders one component of a declared name: a scalar declaration
    // stands alone, a vector declaration needs the component's POSITION
    // within the declared vector (IndexOf in the active-component list),
    // not the source register's original component letter — the swizzle
    // chars must index the declared variable's own slots.
    private static string ComponentView(string name, List<int> activeComponents, int component)
    {
        if (activeComponents.Count <= 1) return name;
        int pos = activeComponents.IndexOf(component);
        return $"{name}.{ComponentLetters[pos]}";
    }

    // Resolves a single-component read to the identifier its defining
    // instruction declared (swizzle off the vector if it was co-written),
    // falling back to the synthetic scalar name when nothing was recorded
    // (a versionless temp — a value never written on this reaching path).
    private static string ResolveComponent(IRRegister reg, int component, PrintContext ctx)
    {
        int? version = reg.SsaVersion[component];

        if (version is { } v
            && ctx.DeclaredViews.TryGetValue((LocationOf(reg, component), v), out (string Name, List<int> Active) entry))
            return ComponentView(entry.Name, entry.Active, component);

        return ScalarIdentifier(reg, component, ctx);
    }

    // Structural storage identity for (reg, component) — mirrors
    // IRStorageLocation.Of exactly (bank/slot from Indices, dynamic when a
    // relative index is present). This is the value-identity key for
    // DeclaredViews: it must NOT involve SymbolicName or the rendered name,
    // because synthesized registers (phi operands etc.) don't carry the
    // same names as the instruction that declared the value.
    private static IRStorageLocation LocationOf(IRRegister reg, int component)
    {
        uint bank = reg.Indices.Count > 0 ? reg.Indices[0] : reg.Index;
        uint slot = reg.Indices.Count > 1 ? reg.Indices[1] : 0;

        bool dynamic = reg.RelativeIndices[0] is not null
            || (reg.Indices.Count > 1 && reg.RelativeIndices[1] is not null);

        return new IRStorageLocation(reg.RegisterType, bank, dynamic ? 0 : slot, dynamic, ComponentLetters[component]);
    }

    private static string MaskOrSwizzleSuffix(IRRegister reg) => reg.ComponentMode switch
    {
        Operand.OperandComponentMode.Mask when reg.Mask != 0 =>
            "." + string.Concat(MaskIndices(reg.Mask).Select(c => ComponentLetters[c])),
        Operand.OperandComponentMode.Swizzle =>
            "." + string.Concat(ActiveComponents(reg).Select(c => ComponentLetters[c])),
        Operand.OperandComponentMode.Select1 => "." + ComponentLetters[reg.Component],
        _ => "",
    };

    // Central dispatch for reading ANY register on the RHS of an
    // expression — routes to struct-field access for input/output,
    // direct (already-valid) bound names for cbuffer/resource/sampler,
    // and the scalar-SSA machinery above for temps.
    private static string RenderRegisterRead(IRRegister reg, PrintContext ctx)
    {
        string rendered = reg.RegisterType switch
        {
            RegisterType.Temp or RegisterType.IndexableTemp =>
                RenderTempRead(reg, ctx),

            RegisterType.Input =>
                RenderSignatureField(reg, "i", ctx.InputElements, ctx),

            RegisterType.Output =>
                RenderSignatureField(reg, "o", ctx.OutputElements, ctx),

            RegisterType.ConstantBuffer =>
                RenderCbufferRead(reg, ctx),

            RegisterType.Resource or RegisterType.Sampler or RegisterType.Uav =>
                // Texture/sampler/UAV objects are not vector values — the
                // DXBC operand swizzle on a resource handle is meaningless
                // (and t0.xyzw.Sample would never compile).
                BaseIdentifier(reg, ctx),

            _ =>
                BaseIdentifier(reg, ctx) + MaskOrSwizzleSuffix(reg),
        };

        return ApplyRegisterModifier(reg.Modifier, rendered);
    }

    // A DXBC source modifier (negate/abs/absneg) that is dropped here would
    // silently change the shader's math — e.g. `1.0 - i.vertexColor.a`
    // decompiling as `(i.cOLOR0.w + 1)`. The modifier lives on the IR register
    // itself, so it is applied once, in this central read dispatch.
    private static string ApplyRegisterModifier(ShdrParser.OperandModifier modifier, string rendered)
    {
        return modifier switch
        {
            ShdrParser.OperandModifier.Neg => $"-{rendered}",
            ShdrParser.OperandModifier.Abs => $"abs({rendered})",
            ShdrParser.OperandModifier.AbsNeg => $"-abs({rendered})",
            _ => rendered,
        };
    }

    private static string FieldNameFor(IRRegister reg, PrintContext ctx)
    {
        string semantic = reg.SymbolicName ?? BaseIdentifier(reg, ctx);
        return HlslAstBuilder.ToFieldName(semantic);
    }

    private static string ElementFieldName(SignatureElement el)
        => HlslAstBuilder.ToFieldName($"{el.SemanticName}{el.SemanticIndex}");

    // Component letter a register position maps to WITHIN a signature
    // element: the number of element-owned register components below it.
    // A write of register position z owned by TEXCOORD1 (mask 0xC = zw) is
    // TEXCOORD1's local x, since TEXCOORD1 only occupies two lanes.
    private static char ElementLocalLetter(SignatureElement el, int registerPosition)
    {
        int below = System.Numerics.BitOperations.PopCount((uint)(el.Mask & ((1 << registerPosition) - 1)));
        return ComponentLetters[below];
    }

    private static string ElementLocalSuffix(SignatureElement el, List<int> positions)
        => "." + string.Concat(positions.Select(p => ElementLocalLetter(el, p)));

    // Renders an input/output register access as a struct-field reference
    // (i.field.swizzle / o.field.swizzle). A register PACKED across multiple
    // signature elements with disjoint masks has each component routed to
    // the element whose mask covers it, with letters remapped into that
    // element's own component space. Multi-element reads build a
    // constructor; multi-element writes are split by RenderOutputWrite.
    private static string RenderSignatureField(IRRegister reg, string prefix, Dictionary<uint, List<SignatureElement>> byRegister, PrintContext ctx)
    {
        List<int> positions = ActiveComponents(reg);
        if (byRegister.TryGetValue(reg.Index, out List<SignatureElement>? elements) && elements.Count > 1)
        {
            if (TryCoveringElement(elements, positions) is { } cover)
                return $"{prefix}.{ElementFieldName(cover)}{ElementLocalSuffix(cover, positions)}";

            // Positions span multiple elements — build a constructor whose
            // lanes are the per-position field reads, in output order.
            return $"float{positions.Count}({string.Join(", ", positions.Select(p => RoutePosition(reg, elements, p, prefix, ctx)))})";
        }

        return prefix + "." + FieldNameFor(reg, ctx) + MaskOrSwizzleSuffix(reg);
    }

    private static string RoutePosition(IRRegister reg, List<SignatureElement> elements, int position, string prefix, PrintContext ctx)
    {
        foreach (SignatureElement el in elements)
            if ((el.Mask & (1 << position)) != 0)
                return $"{prefix}.{ElementFieldName(el)}{ElementLocalSuffix(el, new List<int> { position })}";
        return $"{prefix}.{FieldNameFor(reg, ctx)}.{ComponentLetters[position]}";
    }

    private static SignatureElement? TryCoveringElement(List<SignatureElement> elements, List<int> positions)
    {
        foreach (SignatureElement el in elements)
        {
            bool all = positions.Count > 0;
            foreach (int p in positions)
                all &= (el.Mask & (1 << p)) != 0;
            if (all)
                return el;
        }
        return null;
    }

    // (element, register positions it owns) groups for an output write's
    // active positions, preserving position order.
    private static List<(SignatureElement Element, List<int> Positions)> GroupOutputPositions(List<SignatureElement> elements, List<int> active)
    {
        var groups = new List<(SignatureElement, List<int>)>();
        foreach (int p in active)
        {
            SignatureElement? el = elements.FirstOrDefault(e => (e.Mask & (1 << p)) != 0);
            if (el is null)
                continue;
            var group = groups.FirstOrDefault(g => g.Item1 == el);
            if (group.Item1 is null)
            {
                group = (el, new List<int>());
                groups.Add(group);
            }
            group.Item2.Add(p);
        }
        return groups;
    }

    // Emits an output-register write, routing each written component to the
    // struct field whose signature element owns it (packed registers split
    // into one statement per element). The RHS is the trimmed-to-width value
    // when a single element covers everything; a split takes its per-group
    // lanes straight off the full-width expression.
    private static IEnumerable<string> RenderOutputWrite(IRRegister dest, string rhs, string rawRhs, PrintContext ctx)
    {
        List<int> active = MaskIndices(dest.Mask);
        if (active.Count == 0)
            active = new List<int> { 0 };

        if (ctx.OutputElements.TryGetValue(dest.Index, out List<SignatureElement>? elements) && elements.Count > 1)
        {
            List<(SignatureElement Element, List<int> Positions)> groups = GroupOutputPositions(elements, active);
            if (groups.Count == 1 && groups[0].Positions.Count == active.Count)
            {
                var (el, pos) = groups[0];
                yield return $"o.{ElementFieldName(el)}{ElementLocalSuffix(el, pos)} = {rhs};";
            }
            else if (groups.Count > 1)
            {
                foreach ((SignatureElement el, List<int> pos) in groups)
                {
                    string slice = string.Concat(pos.Select(p => ComponentLetters[p]));
                    yield return $"o.{ElementFieldName(el)}{ElementLocalSuffix(el, pos)} = ({rawRhs}).{slice};";
                }
            }
            else
            {
                yield return $"o.{FieldNameFor(dest, ctx)}{MaskOrSwizzleSuffix(dest)} = {rhs};";
            }
            yield break;
        }

        yield return $"o.{FieldNameFor(dest, ctx)}{MaskOrSwizzleSuffix(dest)} = {rhs};";
    }

    // Emits one or more statement lines for a single destination write.
    // Multiple lines only happen when the written components have
    // diverged to different SSA versions (see below) — the common case
    // is exactly one line.
    // The single identifier an assignment to `dest` would declare (vector
    // name when components share a version, scalar name for one component),
    // or null when the write splits into per-component names. Used by the
    // phi-fallback-copy guard to check whether the destination is already
    // in scope before deciding to drop the copy.
    private static string? SingleDestName(IRRegister dest, List<int> active, PrintContext ctx)
    {
        if (dest.RegisterType == RegisterType.Output)
            return null;

        bool sameVersion = active.All(c => dest.SsaVersion[c] == dest.SsaVersion[active[0]]);
        if (active.Count > 1 && !sameVersion)
            return null;

        string letters = string.Concat(active.Select(c => ComponentLetters[c]));
        string bare = BaseIdentifier(dest, ctx);
        int? version = dest.SsaVersion[active[0]];
        return version is { } v ? $"{bare}_{letters}_{v}" : $"{bare}_{letters}";
    }

    private static IEnumerable<string> RenderAssignmentLines(IRRegister dest, IRExpression expr, PrintContext ctx)
    {
        List<int> active = MaskIndices(dest.Mask); // destinations are always write-masks, never swizzles
        if (active.Count == 0)
            active = new List<int> { 0 };

        // Phi-fallback copies (IRLeaveSsa): when the source register was
        // never written on this path, its SSA version is null. DXBC leaves
        // such values as don't-care, so emitting the read would produce
        // phantom identifiers (r8_x) that no instruction declares. If the
        // destination is already in scope (a hoisted cross-branch merge
        // name), drop the copy entirely — the variable stays
        // declared-but-uninitialized on this path, matching DXBC. Otherwise
        // declare the unversioned source scalars so the assignment still
        // compiles (it reads garbage, which is the same semantics).
        if (expr is IRExpression.RegisterExpression { Register: { } src }
            && src.RegisterType is RegisterType.Temp or RegisterType.IndexableTemp)
        {
            List<int> srcActive = ActiveComponents(src);
            if (srcActive.Count > 0 && srcActive.Any(c => src.SsaVersion[c] is null))
            {
                bool allUnversioned = srcActive.All(c => src.SsaVersion[c] is null);
                if (allUnversioned && dest.RegisterType != RegisterType.Output
                    && SingleDestName(dest, active, ctx) is { } destName
                    && ctx.Declared.Contains(destName))
                {
                    yield break;
                }
                foreach (int c in srcActive)
                {
                    if (src.SsaVersion[c] is not null)
                        continue;
                    string scalar = ScalarIdentifier(src, c, ctx);
                    if (ctx.Declared.Add(scalar))
                        yield return $"float {scalar};";
                }
            }
        }

        string rawRhs = RenderExpression(expr, ctx);

        // DXBC computes full-lane expressions (the source operand's 4-wide
        // swizzle) regardless of how many components the destination
        // write-mask actually consumes, so the rendered RHS is naturally
        // wider than the destination far more often than not. HLSL rejects
        // a wide RHS assigned into a narrow L-value, so narrow it to the
        // destination width with a trailing trim swizzle — the source
        // lane's first N components are exactly what the positional mask
        // semantics assign.
        string rhs = TrimToWidth(rawRhs, active, expr, ctx);

        if (dest.RegisterType == RegisterType.Output)
        {
            foreach (string line in RenderOutputWrite(dest, rhs, rawRhs, ctx))
                yield return line;
            yield break;
        }

        bool sameVersion = active.All(c => dest.SsaVersion[c] == dest.SsaVersion[active[0]]);

        if (active.Count == 1 || sameVersion)
        {
            string letters = string.Concat(active.Select(c => ComponentLetters[c]));
            string bare = BaseIdentifier(dest, ctx);
            int? version = dest.SsaVersion[active[0]];
            string name = version is { } v ? $"{bare}_{letters}_{v}" : $"{bare}_{letters}";

            // Register the identifier this write declares for each written
            // component so later reads reference this same name (swizzling
            // off it) instead of synthesizing a view that was never
            // declared. A single instruction co-writes these components,
            // so recording the shared vector name is sound here — the
            // version-coincidence hazard only affects the read side.
            if (version is { } vv)
                foreach (int c in active)
                    ctx.DeclaredViews[(LocationOf(dest, c), vv)] = (name, active);

            yield return ctx.Declared.Add(name)
                ? $"{DeclType(active.Count)} {name} = {rhs};"
                : $"{name} = {rhs};";
            yield break;
        }

        // Components diverged to different versions in one instruction.
        // Split each component directly off the RHS expression rather than
        // routing through a synthetic vector temp — the RHS is pure (texture
        // Samples included), so each extract re-reads the same lane the temp
        // would have held, and each scalar still records its own
        // correctly-versioned identifier so later reads resolve it.
        for (int i = 0; i < active.Count; i++)
        {
            int c = active[i];
            string scalarName = ScalarIdentifier(dest, c, ctx);
            if (dest.SsaVersion[c] is { } v)
                ctx.DeclaredViews[(LocationOf(dest, c), v)] = (scalarName, new List<int> { c });
            string line = $"{scalarName} = {ExtractComponent(expr, c, ctx)};";
            yield return ctx.Declared.Add(scalarName) ? $"float {line}" : line;
        }
    }

    // Renders a single ORIGINAL-register-position component of an
    // expression's value. Temp register reads compact sparse lanes into
    // fewer-wide constructors (float2 holding positions z,w), so swizzling
    // the rendered value by the original letter (.z) would be invalid —
    // extract through the register's own declared names instead, which
    // resolve the position regardless of the lane count. Non-temp renders
    // (fields, cbuffers, intrinsics) are always full-width, so a plain
    // letter swizzle on the rendered value is correct there.
    private static string ExtractComponent(IRExpression expr, int component, PrintContext ctx)
    {
        IRExpression inner = expr;
        int pos = component;
        while (inner is IRExpression.SwizzleExpression sw)
        {
            pos = sw.Components[pos];
            inner = sw.Value;
        }
        if (inner is IRExpression.RegisterExpression { Register: { } r }
            && r.RegisterType is RegisterType.Temp or RegisterType.IndexableTemp)
        {
            // A swizzle-mode source reads components by output position
            // (ActiveComponents[p]); a Select1 source is one fixed
            // component; a mask source is position-aligned.
            int source = r.ComponentMode switch
            {
                Operand.OperandComponentMode.Swizzle => ActiveComponents(r)[pos],
                Operand.OperandComponentMode.Select1 => r.Component,
                _ => pos,
            };
            return ResolveComponent(r, source, ctx);
        }
        return $"({RenderExpression(expr, ctx)}).{ComponentLetters[component]}";
    }

    private static string DeclType(int componentCount) => componentCount == 1 ? "float" : $"float{componentCount}";

    // HLSL (like C) won't assign a wide vector into a narrower L-value, but
    // DXBC's per-lane semantics mean the RHS expression naturally renders at
    // its full width (usually float4, via the source swizzle) even when the
    // destination write-mask only consumes two or three components. If the
    // RHS is genuinely wider than the destination, append a trailing swizzle
    // that selects the source components by DESTINATION position.
    //
    // A leading-N trim would be wrong: the destination's active components
    // are its mask positions (e.g. .zw -> [2,3]), and DXBC consumes source
    // lane values at exactly those positions, so `o.field.zw = r0.zzzw`
    // needs `r0.zzzw.zw` (z,w) — trimming to `.xy` would silently write
    // (z,z) into z,w. The `.xyz` masks everyone sees are only correct by
    // coincidence (their positions are the leading ones).
    //
    // Parenthesized so the swizzle binds at the top level regardless of the
    // expression's own structure (casts, ternaries, unary prefixes).
    private static string TrimToWidth(string rhs, List<int> active, IRExpression expr, PrintContext ctx)
    {
        int width = ExpressionWidth(expr, ctx);
        if (width <= active.Count)
            return rhs;
        return $"({rhs}).{string.Concat(active.Select(c => ComponentLetters[c]))}";
    }

    // Natural component width of a rendered expression — mirrors the width
    // each render path actually produces (register read width, constant
    // arity, the scalar-collapsing intrinsics, texture samples as float4).
    // Only used to decide whether TrimToWidth must narrow the RHS; when the
    // width is unknowable (a bare field read with no swizzle info) it
    // returns 1 so no invalid trim is ever emitted.
    private static int ExpressionWidth(IRExpression expr, PrintContext ctx) => expr switch
    {
        IRExpression.RegisterExpression r => RegisterReadWidth(r.Register, ctx),
        IRExpression.ConstantExpression c => Math.Max(1, Math.Max(c.RawValues.Length, c.DoubleValues.Length)),
        IRExpression.BinaryExpression b => Math.Max(ExpressionWidth(b.Left, ctx), ExpressionWidth(b.Right, ctx)),
        IRExpression.UnaryExpression u => ExpressionWidth(u.Operand, ctx),
        IRExpression.IntrinsicExpression i => IntrinsicWidth(i, ctx),
        IRExpression.FusedMultiplyAddExpression f => Math.Max(Math.Max(ExpressionWidth(f.A, ctx), ExpressionWidth(f.B, ctx)), ExpressionWidth(f.C, ctx)),
        IRExpression.MultiplyHighExpression => 1,
        IRExpression.Multiply64Expression => 1,
        IRExpression.BitFieldInsertExpression => 1,
        IRExpression.BitFieldExtractExpression => 1,
        IRExpression.ConditionalExpression c => Math.Max(ExpressionWidth(c.TrueExpression, ctx), ExpressionWidth(c.FalseExpression, ctx)),
        IRExpression.DotProductExpression => 1,
        IRExpression.SwizzleExpression s => Math.Max(1, s.Components.Count),
        IRExpression.MatrixVectorMultiplyExpression mv => Math.Max(1, mv.Rows.Count),
        IRExpression.TextureOperationExpression tex => TextureOpWidth(tex.Operation),
        _ => 1,
    };

    // How many components a register read renders as. Temps render via the
    // active-component machinery (swizzle/mask/select1 — exact). Inputs,
    // outputs and cbuffer reads render as `name` + a swizzle suffix, so the
    // suffix's length is the true width; a bare read (no suffix) has an
    // unknown width and is left untrimmed rather than guessed at.
    private static int RegisterReadWidth(IRRegister reg, PrintContext ctx)
    {
        if (reg.RegisterType is RegisterType.Temp or RegisterType.IndexableTemp)
        {
            List<int> active = ActiveComponents(reg);
            return active.Count == 0 ? 1 : active.Count;
        }

        string suffix = MaskOrSwizzleSuffix(reg);
        return suffix.Length > 1 ? suffix.Length - 1 : 1;
    }

    // Element-wise intrinsics keep their argument's width; a handful
    // collapse their result to a scalar; Cross produces a float3.
    private static int IntrinsicWidth(IRExpression.IntrinsicExpression expr, PrintContext ctx)
    {
        switch (expr.Intrinsic)
        {
            case IRExpression.IRIntrinsic.Dot:
            case IRExpression.IRIntrinsic.Length:
            case IRExpression.IRIntrinsic.Distance:
            case IRExpression.IRIntrinsic.Determinant:
            case IRExpression.IRIntrinsic.Any:
            case IRExpression.IRIntrinsic.All:
            case IRExpression.IRIntrinsic.CountBits:
            case IRExpression.IRIntrinsic.ReverseBits:
            case IRExpression.IRIntrinsic.FirstBitHigh:
            case IRExpression.IRIntrinsic.FirstBitLow:
            case IRExpression.IRIntrinsic.CheckAccessFullyMapped:
                return 1;
            case IRExpression.IRIntrinsic.Cross:
                return 3;
            default:
                int w = 1;
                foreach (IRExpression arg in expr.Arguments)
                    w = Math.Max(w, ExpressionWidth(arg, ctx));
                return w;
        }
    }

    // Texture samples/loads/gathers return float4 in HLSL; the info-style
    // queries return scalars.
    private static int TextureOpWidth(IRExpression.TextureOperation op) => op switch
    {
        IRExpression.TextureOperation.Sample
            or IRExpression.TextureOperation.SampleLevel
            or IRExpression.TextureOperation.SampleGrad
            or IRExpression.TextureOperation.SampleBias
            or IRExpression.TextureOperation.Load
            or IRExpression.TextureOperation.Gather => 4,
        // Comparison ops return a single scalar in HLSL (the bytecode writes
        // one lane of the dest register; any single-lane read of it is that
        // same scalar).
        IRExpression.TextureOperation.SampleCompare
            or IRExpression.TextureOperation.SampleCompareLevelZero
            or IRExpression.TextureOperation.GatherCompare => 1,
        _ => 1,
    };

    // Names written at the top level of BOTH of an if's arms — the
    // IRLeaveSsa phi copies that merge a value at this if. These are the
    // identifiers whose declarations must be hoisted above the if (see the
    // HlslIfStatement print case). Returns (rendered name, component count
    // for the declaration type), mirroring the exact naming/typing
    // RenderAssignmentLines will produce when it prints those same writes.
    private static List<(string Name, int Components)> CrossBranchMergeNames(HlslIfStatement iff, PrintContext ctx)
    {
        var result = new List<(string, int)>();
        if (iff.Else is null)
            return result;

        Dictionary<string, int> thenNames = WrittenDeclNames(iff.Then.Statements, ctx);
        Dictionary<string, int> elseNames = WrittenDeclNames(iff.Else.Statements, ctx);

        foreach ((string name, int comps) in thenNames)
            if (elseNames.TryGetValue(name, out int elseComps))
                result.Add((name, Math.Max(comps, elseComps)));

        return result;
    }

    // Names first written at the top level of a loop body that are not yet
    // in scope (see the HlslLoopStatement print case). Only names not
    // already declared are candidates — an existing declaration is already
    // visible inside the loop.
    private static Dictionary<string, int> LoopCarriedDeclNames(HlslLoopStatement loop, PrintContext ctx)
    {
        var names = new Dictionary<string, int>();
        foreach ((string name, int comps) in WrittenDeclNames(loop.Body.Statements, ctx))
        {
            if (ctx.Declared.Contains(name))
                continue;
            if (!names.TryGetValue(name, out int prev) || comps > prev)
                names[name] = comps;
        }
        return names;
    }

    // Top-level destination names a block's statements declare, mapped to
    // the component count (declaration type) of the write. Only direct
    // assignments matter — nested ifs/loops handle their own merges when
    // they get printed.
    private static Dictionary<string, int> WrittenDeclNames(List<HlslStatementNode> statements, PrintContext ctx)
    {
        var names = new Dictionary<string, int>();
        foreach (HlslStatementNode stmt in statements)
        {
            IEnumerable<IRRegister> dests = stmt switch
            {
                HlslAssignmentStatement a => new[] { a.Destination },
                HlslMultiAssignmentStatement ma => ma.Destinations.Where(d => d is not null).Cast<IRRegister>(),
                _ => Array.Empty<IRRegister>(),
            };

            foreach (IRRegister dest in dests)
                foreach ((string name, int comps) in DestinationDeclNames(dest, ctx))
                    if (!names.TryGetValue(name, out int prev) || comps > prev)
                        names[name] = comps;
        }
        return names;
    }

    // The exact identifier(s) and width RenderAssignmentLines would declare
    // for a destination — shared so the hoisting pre-pass and the emit
    // path agree on names and types.
    private static List<(string Name, int Components)> DestinationDeclNames(IRRegister dest, PrintContext ctx)
    {
        var result = new List<(string, int)>();
        if (dest.RegisterType == RegisterType.Output)
            return result; // outputs are `o.field = rhs`, never locals

        List<int> active = MaskIndices(dest.Mask);
        if (active.Count == 0)
            active = new List<int> { 0 };

        bool sameVersion = active.All(c => dest.SsaVersion[c] == dest.SsaVersion[active[0]]);

        if (active.Count == 1 || sameVersion)
        {
            string letters = string.Concat(active.Select(c => ComponentLetters[c]));
            string bare = BaseIdentifier(dest, ctx);
            int? version = dest.SsaVersion[active[0]];
            string name = version is { } v ? $"{bare}_{letters}_{v}" : $"{bare}_{letters}";
            result.Add((name, active.Count));
        }
        else
        {
            // Divergent component versions — RenderAssignmentLines splits
            // into one scalar per component, each declared individually.
            foreach (int c in active)
                result.Add((ScalarIdentifier(dest, c, ctx), 1));
        }

        return result;
    }

    // ---------- expressions ----------

    private static string RenderExpression(IRExpression expr, PrintContext ctx) => expr switch
    {
        IRExpression.IntrinsicExpression i => RenderIntrinsic(i, ctx),
        IRExpression.FusedMultiplyAddExpression f => $"mad({RenderExpression(f.A, ctx)}, {RenderExpression(f.B, ctx)}, {RenderExpression(f.C, ctx)})",
        IRExpression.MatrixVectorMultiplyExpression mv => RenderMatrixMultiply(mv, ctx),
        IRExpression.TextureOperationExpression tex => RenderTextureOp(tex, ctx),
        IRExpression.BinaryExpression b when IsBitwise(b.Operation) => RenderBitwise(b, ctx),
        IRExpression.BinaryExpression b => $"({RenderExpression(b.Left, ctx)} {BinaryOpText(b.Operation)} {RenderExpression(b.Right, ctx)})",
        IRExpression.UnaryExpression u => RenderUnary(u, ctx),
        IRExpression.ConditionalExpression c => $"({RenderExpression(c.Condition, ctx)} ? {RenderExpression(c.TrueExpression, ctx)} : {RenderExpression(c.FalseExpression, ctx)})",
        IRExpression.DotProductExpression d => $"dot({RenderExpression(d.Left, ctx)}, {RenderExpression(d.Right, ctx)})",
        IRExpression.SwizzleExpression s => RenderSwizzle(s, ctx),
        IRExpression.RegisterExpression r => RenderRegisterRead(r.Register, ctx),
        IRExpression.ConstantExpression => expr.ToString()!,
        _ => expr.ToString()!, // no dedicated renderer yet — fall back to IR debug text rather than crash
    };

    // Lane selection for an inlined single-use temp. Components are source
    // register component indices relative to the value's own lanes, so a
    // width-1 value (a scalar def) broadcasts via a scalar swizzle — HLSL
    // scalars only permit .x repeats, no matter which register lane the
    // scalar originally came from — and a wider value swizzles positionally.
    // A `.xxxx` broadcast, not a `float4(x)` constructor, so a scalar bool
    // (a comparison result) stays a bool4 and never hits the single-
    // initializer constructor that HLSL rejects.
    private static string RenderSwizzle(IRExpression.SwizzleExpression s, PrintContext ctx)
    {
        string inner = RenderExpression(s.Value, ctx);
        if (ExpressionWidth(s.Value, ctx) <= 1)
            return s.Components.Count <= 1
                ? $"({inner})"
                : $"({inner}).{new string('x', s.Components.Count)}";

        // A temp read compacts sparse lanes (float2 holding original
        // positions z,w), so the requested ORIGINAL positions must be mapped
        // into the compacted lanes (IndexOf) — swizzling the compacted value
        // by the original letters (.z) would be an invalid subscript. Only a
        // direct MASK-mode register read can compact: swizzle-mode reads
        // render the full 4-wide value (r0_w_7.xxxx), and a nested swizzle's
        // output is already leading-positioned.
        if (s.Value is IRExpression.RegisterExpression { Register: { } r }
            && r.RegisterType is RegisterType.Temp or RegisterType.IndexableTemp
            && r.ComponentMode == Operand.OperandComponentMode.Mask
            && MaskIndices(r.Mask) is { } active
            && !IsLeading(active))
        {
            string letters = string.Concat(s.Components.Select(p => ComponentLetters[active.IndexOf(p)]));
            return $"({inner}).{letters}";
        }

        return $"({inner}).{string.Concat(s.Components.Select(i => ComponentLetters[i]))}";
    }

    private static bool IsLeading(List<int> components)
    {
        for (int i = 0; i < components.Count; i++)
            if (components[i] != i)
                return false;
        return true;
    }

    private static string RenderUnary(IRExpression.UnaryExpression u, PrintContext ctx) => u.Operation switch
    {
        IRExpression.UnaryExpression.UnaryOperation.Negate => $"-{RenderExpression(u.Operand, ctx)}",
        IRExpression.UnaryExpression.UnaryOperation.LogicalNot => $"!{RenderExpression(u.Operand, ctx)}",
        IRExpression.UnaryExpression.UnaryOperation.BitwiseNot => $"~{RenderExpression(u.Operand, ctx)}",
        IRExpression.UnaryExpression.UnaryOperation.Absolute => $"abs({RenderExpression(u.Operand, ctx)})",
        _ => RenderExpression(u.Operand, ctx),
    };

    private static bool IsBitwise(IRExpression.BinaryOperation op) => op switch
    {
        IRExpression.BinaryOperation.BitwiseAnd
            or IRExpression.BinaryOperation.BitwiseOr
            or IRExpression.BinaryOperation.BitwiseXor
            or IRExpression.BinaryOperation.LeftShift
            or IRExpression.BinaryOperation.SignedRightShift
            or IRExpression.BinaryOperation.UnsignedRightShift => true,
        _ => false,
    };

    // True when the expression renders as an HLSL bool (a comparison or a
    // swizzle/negation of one). Bitwise ops in DXBC operate on raw float
    // register bits (the `and r0, r0, l(0x3f800000)` boolean-mask trick),
    // and HLSL rejects `&`/`|` on floats — so we reinterpret both sides as
    // ints, bitwise-op them, and reinterpret back. Comparisons must first
    // be cast to float (asint() does not accept bool).
    private static bool IsComparisonish(IRExpression e) => e switch
    {
        IRExpression.BinaryExpression b => b.Operation is IRExpression.BinaryOperation.Equal
            or IRExpression.BinaryOperation.NotEqual
            or IRExpression.BinaryOperation.GreaterEqual
            or IRExpression.BinaryOperation.GreaterThan
            or IRExpression.BinaryOperation.LessThan
            or IRExpression.BinaryOperation.LessEqual,
        IRExpression.UnaryExpression u => u.Operation == IRExpression.UnaryExpression.UnaryOperation.LogicalNot,
        IRExpression.SwizzleExpression s => IsComparisonish(s.Value),
        _ => false,
    };

    private static string RenderBitwise(IRExpression.BinaryExpression b, PrintContext ctx)
    {
        string Op(IRExpression side)
        {
            string s = RenderExpression(side, ctx);
            return IsComparisonish(side) ? $"(float)({s})" : s;
        }
        return $"asfloat(asint({Op(b.Left)}) {BinaryOpText(b.Operation)} asint({Op(b.Right)}))";
    }

    private static string BinaryOpText(IRExpression.BinaryOperation op) => op switch
    {
        IRExpression.BinaryOperation.Add => "+",
        IRExpression.BinaryOperation.Subtract => "-",
        IRExpression.BinaryOperation.Multiply => "*",
        IRExpression.BinaryOperation.Divide => "/",
        IRExpression.BinaryOperation.UnsignedDivide => "/",
        IRExpression.BinaryOperation.Modulo => "%",
        IRExpression.BinaryOperation.Equal => "==",
        IRExpression.BinaryOperation.NotEqual => "!=",
        IRExpression.BinaryOperation.GreaterEqual => ">=",
        IRExpression.BinaryOperation.GreaterThan => ">",
        IRExpression.BinaryOperation.LessThan => "<",
        IRExpression.BinaryOperation.LessEqual => "<=",
        IRExpression.BinaryOperation.LogicalAnd => "&&",
        IRExpression.BinaryOperation.LogicalOr => "||",
        IRExpression.BinaryOperation.BitwiseAnd => "&",
        IRExpression.BinaryOperation.BitwiseOr => "|",
        IRExpression.BinaryOperation.BitwiseXor => "^",
        IRExpression.BinaryOperation.LeftShift => "<<",
        IRExpression.BinaryOperation.SignedRightShift => ">>",
        IRExpression.BinaryOperation.UnsignedRightShift => ">>",
        _ => "?",
    };

    // DXBC/HLSL-specific spelling deliberately lives here, not in the IR
    // (see the IRIntrinsic enum's own doc comment) — this is the mapping
    // it was asking for.
    private static string RenderIntrinsic(IRExpression.IntrinsicExpression expr, PrintContext ctx)
    {
        string Arg(int n) => RenderExpression(expr.Arguments[n], ctx);
        string AllArgs() => string.Join(", ", expr.Arguments.Select(a => RenderExpression(a, ctx)));

        // Casts use C-style cast syntax, not a function call.
        switch (expr.Intrinsic)
        {
            case IRExpression.IRIntrinsic.CastFloat: return $"(float)({Arg(0)})";
            case IRExpression.IRIntrinsic.CastInt: return $"(int)({Arg(0)})";
            case IRExpression.IRIntrinsic.CastUInt: return $"(uint)({Arg(0)})";
            case IRExpression.IRIntrinsic.CastDouble: return $"(double)({Arg(0)})";
            case IRExpression.IRIntrinsic.CastBool: return $"(bool)({Arg(0)})";
        }

        string? name = expr.Intrinsic switch
        {
            IRExpression.IRIntrinsic.AsFloat => "asfloat",
            IRExpression.IRIntrinsic.AsInt => "asint",
            IRExpression.IRIntrinsic.AsUInt => "asuint",
            IRExpression.IRIntrinsic.F16ToF32 => "f16tof32",
            IRExpression.IRIntrinsic.F32ToF16 => "f32tof16",
            IRExpression.IRIntrinsic.Sqrt => "sqrt",
            IRExpression.IRIntrinsic.Rsqrt => "rsqrt",
            IRExpression.IRIntrinsic.Min => "min",
            IRExpression.IRIntrinsic.Max => "max",
            IRExpression.IRIntrinsic.Pow => "pow",
            IRExpression.IRIntrinsic.Exp2 => "exp2",
            IRExpression.IRIntrinsic.Log2 => "log2",
            IRExpression.IRIntrinsic.Reciprocal => "rcp",
            IRExpression.IRIntrinsic.Clamp01 => "saturate",
            IRExpression.IRIntrinsic.FractionalPart => "frac",
            IRExpression.IRIntrinsic.RoundNearestEven => "round",
            IRExpression.IRIntrinsic.Floor => "floor",
            IRExpression.IRIntrinsic.Ceiling => "ceil",
            IRExpression.IRIntrinsic.Truncate => "trunc",
            IRExpression.IRIntrinsic.Sin => "sin",
            IRExpression.IRIntrinsic.Cos => "cos",
            IRExpression.IRIntrinsic.Tan => "tan",
            IRExpression.IRIntrinsic.Asin => "asin",
            IRExpression.IRIntrinsic.Acos => "acos",
            IRExpression.IRIntrinsic.Atan => "atan",
            IRExpression.IRIntrinsic.Atan2 => "atan2",
            IRExpression.IRIntrinsic.Normalize => "normalize",
            IRExpression.IRIntrinsic.Length => "length",
            IRExpression.IRIntrinsic.Distance => "distance",
            IRExpression.IRIntrinsic.Reflect => "reflect",
            IRExpression.IRIntrinsic.Refract => "refract",
            IRExpression.IRIntrinsic.FaceForward => "faceforward",
            IRExpression.IRIntrinsic.Cross => "cross",
            IRExpression.IRIntrinsic.Dot => "dot",
            IRExpression.IRIntrinsic.Transpose => "transpose",
            IRExpression.IRIntrinsic.Determinant => "determinant",
            IRExpression.IRIntrinsic.Noise => "noise",
            IRExpression.IRIntrinsic.CountBits => "countbits",
            IRExpression.IRIntrinsic.ReverseBits => "reversebits",
            IRExpression.IRIntrinsic.FirstBitHigh => "firstbithigh",
            IRExpression.IRIntrinsic.FirstBitLow => "firstbitlow",
            IRExpression.IRIntrinsic.Lerp => "lerp",
            IRExpression.IRIntrinsic.Fmod => "fmod",
            IRExpression.IRIntrinsic.Modf => "modf",
            IRExpression.IRIntrinsic.Ldexp => "ldexp",
            IRExpression.IRIntrinsic.Frexp => "frexp",
            IRExpression.IRIntrinsic.DerivativeX => "ddx",
            IRExpression.IRIntrinsic.DerivativeXCoarse => "ddx_coarse",
            IRExpression.IRIntrinsic.DerivativeXFine => "ddx_fine",
            IRExpression.IRIntrinsic.DerivativeY => "ddy",
            IRExpression.IRIntrinsic.DerivativeYCoarse => "ddy_coarse",
            IRExpression.IRIntrinsic.DerivativeYFine => "ddy_fine",
            IRExpression.IRIntrinsic.Any => "any",
            IRExpression.IRIntrinsic.All => "all",
            IRExpression.IRIntrinsic.CheckAccessFullyMapped => "CheckAccessFullyMapped",
            _ => null, // DistanceVector, MaskedSumOfAbsoluteDifferences, Eval* — no confirmed HLSL builtin
        };

        return name is not null
            ? $"{name}({AllArgs()})"
            : $"/* TODO: no HLSL mapping for {expr.Intrinsic} */ {expr.Intrinsic}({AllArgs()})";
    }

    private static string RenderMatrixMultiply(IRExpression.MatrixVectorMultiplyExpression mv, PrintContext ctx)
    {
        if (mv.Rows.Count == 0)
            return $"/* TODO: empty matrix */ {RenderExpression(mv.Vector, ctx)}";

        string rows = string.Join(", ", mv.Rows.Select(r => RenderRegisterRead(r, ctx)));
        return $"mul(float{mv.Rows.Count}x4({rows}), {RenderExpression(mv.Vector, ctx)})";
    }

    // The location arity a comparison intrinsic wants for a given texture
    // type: TextureCube/3D/2D-array take float3, Texture2D takes float2.
    private static string CompareCoordinateSwizzle(string textureType) => textureType switch
    {
        "Texture1D" => ".x",
        "Texture2D" or "Texture2DMS" => ".xy",
        "TextureCubeArray" => ".xyzw",
        _ => ".xyz",
    };

    // Confirmed 1:1 against real Texture2D/TextureCube method names;
    // Load/Sample/SampleLevel/SampleBias/SampleGrad/Gather keep the same
    // name DXBC uses, only the Compare variants and argument order/style
    // needed fixing up from the debug ToString().
    private static string RenderTextureOp(IRExpression.TextureOperationExpression tex, PrintContext ctx)
    {
        string resource = RenderRegisterRead(tex.Resource, ctx);
        string? sampler = tex.Sampler is null ? null : RenderRegisterRead(tex.Sampler, ctx);
        string? coord = tex.Coordinates is null ? null : RenderExpression(tex.Coordinates, ctx);
        string? offset = tex.Offset is null ? null : RenderExpression(tex.Offset, ctx);

        // Comparison intrinsics (SampleCmp/SampleCmpLevelZero/GatherCmp)
        // resolve strictly by arity, unlike the plain Sample family which
        // implicitly truncates an over-wide location. The bytecode's
        // coordinate operand is a full 4-component register read, so trim it
        // to the component count the texture dimension demands (.xyz for a
        // cube, .xy for a 2D).
        bool isCompare = tex.Operation is IRExpression.TextureOperation.SampleCompare
            or IRExpression.TextureOperation.SampleCompareLevelZero
            or IRExpression.TextureOperation.GatherCompare;
        if (isCompare && tex.Coordinates is not null && coord is not null)
        {
            string type = tex.Resource is { } rr
                ? ctx.TextureTypeBySlot.GetValueOrDefault((int)rr.Index, "Texture2D")
                : "Texture2D";
            coord = $"({coord}){CompareCoordinateSwizzle(type)}";
        }

        string Args(params string?[] parts) => string.Join(", ", parts.Where(p => p is not null));

        return tex.Operation switch
        {
            IRExpression.TextureOperation.Sample when ctx.Stage == HlslShaderStage.Vertex =>
                // Implicit-LOD Sample does not exist in a vertex shader —
                // the bytecode's `sample` is sample_l(implicit 0), which is
                // SampleLevel(..., 0) and is valid in both vs_4_0 and vs_5_0.
                $"{resource}.SampleLevel({Args(sampler, coord, "0", offset)})",
            IRExpression.TextureOperation.Sample =>
                $"{resource}.Sample({Args(sampler, coord, offset)})",
            IRExpression.TextureOperation.SampleLevel =>
                $"{resource}.SampleLevel({Args(sampler, coord, tex.LOD is null ? null : RenderExpression(tex.LOD, ctx), offset)})",
            IRExpression.TextureOperation.SampleBias =>
                $"{resource}.SampleBias({Args(sampler, coord, tex.Bias is null ? null : RenderExpression(tex.Bias, ctx), offset)})",
            IRExpression.TextureOperation.SampleGrad =>
                $"{resource}.SampleGrad({Args(sampler, coord, tex.GradX is null ? null : RenderExpression(tex.GradX, ctx), tex.GradY is null ? null : RenderExpression(tex.GradY, ctx), offset)})",
            IRExpression.TextureOperation.SampleCompare =>
                $"{resource}.SampleCmp({Args(sampler, coord, tex.CompareValue is null ? null : RenderExpression(tex.CompareValue, ctx), offset)})",
            IRExpression.TextureOperation.SampleCompareLevelZero =>
                $"{resource}.SampleCmpLevelZero({Args(sampler, coord, tex.CompareValue is null ? null : RenderExpression(tex.CompareValue, ctx), offset)})",
            IRExpression.TextureOperation.Load =>
                $"{resource}.Load({Args(coord, offset)})", // no sampler — Load reads texels directly
            IRExpression.TextureOperation.Gather =>
                $"{resource}.Gather({Args(sampler, coord, offset)})",
            IRExpression.TextureOperation.GatherCompare =>
                $"{resource}.GatherCmp({Args(sampler, coord, tex.CompareValue is null ? null : RenderExpression(tex.CompareValue, ctx), offset)})",
            _ =>
                $"/* TODO: no confirmed HLSL mapping for {tex.Operation} */ {resource}.{tex.Operation}({Args(sampler, coord)})",
        };
    }
}
