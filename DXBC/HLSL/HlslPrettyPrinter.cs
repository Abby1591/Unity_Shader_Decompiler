using System.Text;
using System.Text.Json;
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
    public static string Print(HlslShaderNode shader)
    {
        var sb = new StringBuilder();
        sb.Append("Shader \"").Append(shader.Name).Append("\"\n{\n");

        PrintProperties(sb, shader.Properties);

        foreach (HlslSubShaderNode ss in shader.SubShaders)
            PrintSubShader(sb, ss);

        if (!string.IsNullOrEmpty(shader.Fallback))
            sb.Append("    Fallback \"").Append(shader.Fallback).Append("\"\n");

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

    private static void PrintSubShader(StringBuilder sb, HlslSubShaderNode ss)
    {
        sb.Append("    SubShader\n    {\n");
        PrintTags(sb, ss.Tags, indent: "        ");
        if (ss.Lod is { } lod)
            sb.Append("        LOD ").Append(lod).Append('\n');

        foreach (HlslPassNode pass in ss.Passes)
            PrintPass(sb, pass);

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

    private static void PrintPass(StringBuilder sb, HlslPassNode pass)
    {
        sb.Append("        Pass\n        {\n");
        if (!string.IsNullOrEmpty(pass.Name))
            sb.Append("            Name \"").Append(pass.Name).Append("\"\n");

        PrintTags(sb, pass.Tags, indent: "            ");
        PrintRenderState(sb, pass.State);

        sb.Append("            HLSLPROGRAM\n");

        foreach (HlslResourceNode res in pass.Resources)
            PrintResource(sb, res);

        foreach (HlslStructNode s in pass.Structs)
            PrintStruct(sb, s);

        if (pass.VertexFunction is not null)
        {
            sb.Append("            #pragma vertex vert\n");
            PrintFunction(sb, pass.VertexFunction, pass.Cbuffers);
        }
        if (pass.FragmentFunction is not null)
        {
            sb.Append("            #pragma fragment frag\n");
            PrintFunction(sb, pass.FragmentFunction, pass.Cbuffers);
        }
        foreach (HlslFunctionNode? f in new[] { pass.GeometryFunction, pass.HullFunction, pass.DomainFunction, pass.ComputeFunction })
            if (f is not null)
                PrintFunction(sb, f, pass.Cbuffers);

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
    // to the same SSA generation don't re-declare), and a counter for
    // synthetic temps used to split a single multi-component RHS across
    // components whose destination versions have diverged (see
    // RenderMultiVersionAssignment below).
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

        public int TempCounter;
    }

    private static void PrintFunction(StringBuilder sb, HlslFunctionNode fn, Dictionary<(int Slot, string Stage), CbufferMetadata> allCbuffers)
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

        var ctx = new PrintContext { Cbuffers = cbuffers };
        if (fn.OutputStruct is not null)
            sb.Append("                ").Append(outType).Append(" o = (").Append(outType).Append(")0;\n");

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

            case HlslLoopStatement loop:
                sb.Append(pad).Append("[loop]\n").Append(pad).Append("while (true)\n").Append(pad).Append("{\n");
                PrintBlock(sb, loop.Body, indent + 1, ctx);
                sb.Append(pad).Append("}\n");
                break;

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
    private static string? ResolveCbufferRead(CbufferMetadata cb, IRRegister reg)
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

        if (bestSize == distinct.Length * 4 && rel == 0)
            return best.Name; // read covers the whole variable

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
    // legal, unique C-style identifier.
    private static string ScalarIdentifier(IRRegister reg, int component, PrintContext ctx)
    {
        string bare = BaseIdentifier(reg, ctx);
        int? version = reg.SsaVersion[component];
        return version is { } v
            ? $"{bare}_{ComponentLetters[component]}_{v}"
            : $"{bare}_{ComponentLetters[component]}"; // no SSA version yet (implicit input to this function)
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
    // (an unrenamed implicit function input).
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
        switch (reg.RegisterType)
        {
            case RegisterType.Temp:
            case RegisterType.IndexableTemp:
                return RenderTempRead(reg, ctx);

            case RegisterType.Input:
                return "i." + FieldNameFor(reg, ctx) + MaskOrSwizzleSuffix(reg);

            case RegisterType.Output:
                return "o." + FieldNameFor(reg, ctx) + MaskOrSwizzleSuffix(reg);

            case RegisterType.ConstantBuffer:
                return RenderCbufferRead(reg, ctx);

            case RegisterType.Resource:
            case RegisterType.Sampler:
            case RegisterType.Uav:
                // Texture/sampler/UAV objects are not vector values — the
                // DXBC operand swizzle on a resource handle is meaningless
                // (and t0.xyzw.Sample would never compile).
                return BaseIdentifier(reg, ctx);

            default:
                return BaseIdentifier(reg, ctx) + MaskOrSwizzleSuffix(reg);
        }
    }

    private static string FieldNameFor(IRRegister reg, PrintContext ctx)
    {
        string semantic = reg.SymbolicName ?? BaseIdentifier(reg, ctx);
        return char.ToLowerInvariant(semantic[0]) + semantic[1..];
    }

    // Emits one or more statement lines for a single destination write.
    // Multiple lines only happen when the written components have
    // diverged to different SSA versions (see below) — the common case
    // is exactly one line.
    private static IEnumerable<string> RenderAssignmentLines(IRRegister dest, IRExpression expr, PrintContext ctx)
    {
        string rhs = RenderExpression(expr, ctx);

        if (dest.RegisterType == RegisterType.Output)
        {
            yield return $"o.{FieldNameFor(dest, ctx)}{MaskOrSwizzleSuffix(dest)} = {rhs};";
            yield break;
        }

        List<int> active = MaskIndices(dest.Mask); // destinations are always write-masks, never swizzles
        if (active.Count == 0)
            active = new List<int> { 0 };

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

        // Components diverged to different versions in one instruction —
        // evaluate the RHS once into a synthetic vector temp, then split
        // each component off into its own correctly-versioned scalar so
        // nothing gets recomputed (matters for texture Sample calls) and
        // every later read still finds the right identifier.
        string tempName = $"__t{ctx.TempCounter++}";
        yield return $"{DeclType(active.Count)} {tempName} = {rhs};";

        for (int i = 0; i < active.Count; i++)
        {
            int c = active[i];
            string scalarName = ScalarIdentifier(dest, c, ctx);
            if (dest.SsaVersion[c] is { } v)
                ctx.DeclaredViews[(LocationOf(dest, c), v)] = (scalarName, new List<int> { c });
            string line = $"{scalarName} = {tempName}.{ComponentLetters[i]};";
            yield return ctx.Declared.Add(scalarName) ? $"float {line}" : line;
        }
    }

    private static string DeclType(int componentCount) => componentCount == 1 ? "float" : $"float{componentCount}";

    // ---------- expressions ----------

    private static string RenderExpression(IRExpression expr, PrintContext ctx) => expr switch
    {
        IRExpression.IntrinsicExpression i => RenderIntrinsic(i, ctx),
        IRExpression.FusedMultiplyAddExpression f => $"mad({RenderExpression(f.A, ctx)}, {RenderExpression(f.B, ctx)}, {RenderExpression(f.C, ctx)})",
        IRExpression.MatrixVectorMultiplyExpression mv => RenderMatrixMultiply(mv, ctx),
        IRExpression.TextureOperationExpression tex => RenderTextureOp(tex, ctx),
        IRExpression.BinaryExpression b => $"({RenderExpression(b.Left, ctx)} {BinaryOpText(b.Operation)} {RenderExpression(b.Right, ctx)})",
        IRExpression.UnaryExpression u => RenderUnary(u, ctx),
        IRExpression.ConditionalExpression c => $"({RenderExpression(c.Condition, ctx)} ? {RenderExpression(c.TrueExpression, ctx)} : {RenderExpression(c.FalseExpression, ctx)})",
        IRExpression.DotProductExpression d => $"dot({RenderExpression(d.Left, ctx)}, {RenderExpression(d.Right, ctx)})",
        IRExpression.RegisterExpression r => RenderRegisterRead(r.Register, ctx),
        IRExpression.ConstantExpression => expr.ToString()!,
        _ => expr.ToString()!, // no dedicated renderer yet — fall back to IR debug text rather than crash
    };

    private static string RenderUnary(IRExpression.UnaryExpression u, PrintContext ctx) => u.Operation switch
    {
        IRExpression.UnaryExpression.UnaryOperation.Negate => $"-{RenderExpression(u.Operand, ctx)}",
        IRExpression.UnaryExpression.UnaryOperation.LogicalNot => $"!{RenderExpression(u.Operand, ctx)}",
        IRExpression.UnaryExpression.UnaryOperation.BitwiseNot => $"~{RenderExpression(u.Operand, ctx)}",
        IRExpression.UnaryExpression.UnaryOperation.Absolute => $"abs({RenderExpression(u.Operand, ctx)})",
        _ => RenderExpression(u.Operand, ctx),
    };

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