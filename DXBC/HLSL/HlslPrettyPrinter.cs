using System.Text;
using System.Text.Json;
using Parser.DXBC.Chunks;
using Parser.DXBC.Instructions;
using Parser.DXBC.IR;
using Parser.DXBC.IR.Analysis;
using Parser.DXBC.Metadata;

namespace Parser.DXBC.Hlsl.Ast;

// Stage 13 (statement/expression -> text formatting) + Stage 14 (ShaderLab
// wrapper) together — splitting them into separate files would mean
// threading a StringBuilder/indent state back and forth between two
// classes for no real benefit, since "print the pass" and "wrap the pass
// in Pass{HLSLPROGRAM...ENDHLSL}" are the same recursive walk.
//
// IMPORTANT — things this printer does NOT invent, and instead flags
// with a `/* TODO ... */` comment in the emitted text so it's visible
// in the output, not just buried in source comments:
//   - Range property bounds (HlslPropertyNode.Range is null — see Stage 4
//     notes; no confirmed field path for min/max yet)
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
        // No confirmed source for Range bounds yet (see Stage 4) — emit
        // as Float rather than fabricate a (0,1) that might be wrong.
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
            PrintFunction(sb, pass.VertexFunction, pass.Cbuffers, fuseTemps, stageOutputs: stageInterpolators);
        }
        if (pass.FragmentFunction is not null)
        {
            sb.Append("            #pragma fragment frag\n");
            PrintFunction(sb, pass.FragmentFunction, pass.Cbuffers, fuseTemps, stageInputs: stageInterpolators);
        }
        foreach (HlslFunctionNode? f in new[] { pass.GeometryFunction, pass.HullFunction, pass.DomainFunction, pass.ComputeFunction })
            if (f is not null)
                PrintFunction(sb, f, pass.Cbuffers, fuseTemps);

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
                sb.Append("            SamplerState ").Append(res.Name).Append(" : ").Append(reg).Append(";\n");
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
    }

    private static void PrintFunction(
        StringBuilder sb,
        HlslFunctionNode fn,
        Dictionary<(int Slot, string Stage), CbufferMetadata> allCbuffers,
        bool fuseTemps,
        Dictionary<string, string>? stageInputs = null,
        Dictionary<string, string>? stageOutputs = null)
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
        if (fn.OutputStruct is not null)
            sb.Append("                ").Append(outType).Append(" o = (").Append(outType).Append(")0;\n");

        HlslSemanticNaming.Apply(fn.Statements, cbuffers, stageInputs, stageOutputs);

        if (fuseTemps)
            HlslFuseTemps.Apply(fn.Statements, MaxFuseNodes);

        PrintBlock(sb, fn.Statements, indent: 4, ctx);

        sb.Append("            }\n");
    }

    private static void PrintBlock(StringBuilder sb, HlslBlockStatement block, int indent, PrintContext ctx)
    {
        foreach (HlslStatementNode stmt in block.Statements)
            PrintStatement(sb, stmt, indent, ctx);
    }

    private static void PrintStatement(StringBuilder sb, HlslStatementNode stmt, int indent, PrintContext ctx)
    {
        string pad = new(' ', indent * 4);

        switch (stmt)
        {
            case HlslAssignmentStatement a:
                foreach (string line in RenderAssignmentLines(a.Destination, a.Expression, ctx))
                    sb.Append(pad).Append(line).Append('\n');
                break;

            case HlslMultiAssignmentStatement ma:
                for (int i = 0; i < ma.Destinations.Count; i++)
                {
                    if (ma.Destinations[i] is not { } dest) continue;
                    foreach (string line in RenderAssignmentLines(dest, ma.Expressions[i], ctx))
                        sb.Append(pad).Append(line).Append('\n');
                }
                break;

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
            or IRExpression.TextureOperation.SampleCompare
            or IRExpression.TextureOperation.SampleCompareLevelZero
            or IRExpression.TextureOperation.Load
            or IRExpression.TextureOperation.Gather
            or IRExpression.TextureOperation.GatherCompare => 4,
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