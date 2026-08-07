using System.Text;
using System.Text.Json;
using Parser.DXBC.Instructions;
using Parser.DXBC.IR;

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
            PrintFunction(sb, pass.VertexFunction);
        }
        if (pass.FragmentFunction is not null)
        {
            sb.Append("            #pragma fragment frag\n");
            PrintFunction(sb, pass.FragmentFunction);
        }
        foreach (HlslFunctionNode? f in new[] { pass.GeometryFunction, pass.HullFunction, pass.DomainFunction, pass.ComputeFunction })
            if (f is not null)
                PrintFunction(sb, f);

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
        switch (res.Kind)
        {
            case HlslResourceKind.ConstantBuffer:
                sb.Append("            CBUFFER_START(").Append(res.Name).Append(")\n");
                foreach (HlslCBufferVariable v in res.Variables)
                    sb.Append("                ").Append(v.TypeName).Append(' ').Append(v.Name).Append(";\n");
                sb.Append("            CBUFFER_END\n");
                break;

            case HlslResourceKind.Texture:
                sb.Append("            ").Append(res.TypeHint ?? "Texture2D").Append(' ').Append(res.Name).Append(";\n");
                break;

            case HlslResourceKind.Sampler:
                sb.Append("            SamplerState ").Append(res.Name).Append(";\n");
                break;

            case HlslResourceKind.Uav:
                sb.Append("            ").Append(res.TypeHint ?? "RWTexture2D").Append(' ').Append(res.Name).Append(";\n");
                break;
        }
    }

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

    private static void PrintFunction(StringBuilder sb, HlslFunctionNode fn)
    {
        string outType = fn.OutputStruct?.Name ?? "void";
        string inType = fn.InputStruct?.Name ?? "";
        string inParam = fn.InputStruct is null ? "" : $"{inType} i";

        sb.Append("            ").Append(outType).Append(' ').Append(fn.Name).Append('(').Append(inParam).Append(")\n            {\n");

        var declared = new HashSet<string>();
        if (fn.OutputStruct is not null)
            sb.Append("                ").Append(outType).Append(" o = (").Append(outType).Append(")0;\n");

        PrintBlock(sb, fn.Statements, indent: 4, declared);

        sb.Append("            }\n");
    }

    private static void PrintBlock(StringBuilder sb, HlslBlockStatement block, int indent, HashSet<string> declared)
    {
        foreach (HlslStatementNode stmt in block.Statements)
            PrintStatement(sb, stmt, indent, declared);
    }

    private static void PrintStatement(StringBuilder sb, HlslStatementNode stmt, int indent, HashSet<string> declared)
    {
        string pad = new(' ', indent * 4);

        switch (stmt)
        {
            case HlslAssignmentStatement a:
                sb.Append(pad).Append(RenderAssignment(a.Destination, a.Expression, declared)).Append('\n');
                break;

            case HlslMultiAssignmentStatement ma:
                for (int i = 0; i < ma.Destinations.Count; i++)
                {
                    if (ma.Destinations[i] is not { } dest) continue;
                    sb.Append(pad).Append(RenderAssignment(dest, ma.Expressions[i], declared)).Append('\n');
                }
                break;

            case HlslIfStatement iff:
                sb.Append(pad).Append("if (").Append(RenderExpression(iff.Condition)).Append(")\n");
                sb.Append(pad).Append("{\n");
                PrintBlock(sb, iff.Then, indent + 1, declared);
                sb.Append(pad).Append("}\n");
                if (iff.Else is not null)
                {
                    sb.Append(pad).Append("else\n").Append(pad).Append("{\n");
                    PrintBlock(sb, iff.Else, indent + 1, declared);
                    sb.Append(pad).Append("}\n");
                }
                break;

            case HlslLoopStatement loop:
                sb.Append(pad).Append("[loop]\n").Append(pad).Append("while (true)\n").Append(pad).Append("{\n");
                PrintBlock(sb, loop.Body, indent + 1, declared);
                sb.Append(pad).Append("}\n");
                break;

            case HlslSwitchStatement sw:
                sb.Append(pad).Append("switch (").Append(RenderExpression(sw.Selector)).Append(")\n").Append(pad).Append("{\n");
                foreach (HlslSwitchCase c in sw.Cases)
                {
                    sb.Append(pad).Append(c.Value is null ? "default:\n" : $"case {RenderExpression(c.Value)}:\n");
                    PrintBlock(sb, c.Body, indent + 1, declared);
                }
                sb.Append(pad).Append("}\n");
                break;

            case HlslBreakStatement b:
                sb.Append(pad).Append(b.Condition is null ? "break;" : $"if ({RenderExpression(b.Condition)}) break;").Append('\n');
                break;

            case HlslContinueStatement c:
                sb.Append(pad).Append(c.Condition is null ? "continue;" : $"if ({RenderExpression(c.Condition)}) continue;").Append('\n');
                break;

            case HlslReturnStatement r:
                sb.Append(pad).Append(r.Condition is null
                    ? "return o;"
                    : $"if ({RenderExpression(r.Condition)}) return o;").Append('\n');
                break;

            case HlslDiscardStatement d:
                sb.Append(pad).Append("if (").Append(RenderExpression(d.Condition)).Append(") discard;\n");
                break;

            case HlslMemoryStoreStatement ms:
                sb.Append(pad).Append(RenderExpression(new IRExpression.RegisterExpression { Register = ms.Resource }))
                  .Append('[').Append(RenderExpression(ms.Address)).Append("] = ")
                  .Append(RenderExpression(ms.Value)).Append(";\n");
                break;

            case HlslRawStatement raw:
                sb.Append(pad).Append("// TODO: unhandled IR node — ").Append(raw.Source).Append('\n');
                break;
        }
    }

    // Declares a variable the first time its (name, type) is written,
    // just assigns on every later write to the same name — see the SSA
    // note at the top of this file for why "later write, same name" can
    // still legitimately happen (component-partial writes to the same
    // SSA generation, e.g. r0.xy then r0.zw of the same version).
    private static string RenderAssignment(IRRegister dest, IRExpression expr, HashSet<string> declared)
    {
        string name = dest.ToStringAs(isDefinition: true);
        string bareName = name.Split('.')[0]; // strip any .xyz component suffix for the declared-set key

        string rhs = RenderExpression(expr);

        if (dest.RegisterType is RegisterType.Output)
            return $"o.{FieldNameForOutput(dest)} = {rhs};";

        if (declared.Add(bareName))
            return $"{DeclType(dest)} {name} = {rhs};";

        return $"{name} = {rhs};";
    }

    private static string FieldNameForOutput(IRRegister reg)
    {
        // Output struct fields were named by HlslAstBuilder.ToFieldName
        // (lowercase-first-letter of the semantic) — mirror that here so
        // `o.xxx` actually matches a field PrintStruct emitted.
        string semantic = reg.SymbolicName ?? reg.ToString();
        return char.ToLowerInvariant(semantic[0]) + semantic[1..];
    }

    private static string DeclType(IRRegister reg)
    {
        int count = System.Numerics.BitOperations.PopCount(reg.Mask);
        if (count == 0) count = 1;
        string baseName = reg.Type switch
        {
            IRValueType.Int or IRValueType.Int2 or IRValueType.Int3 or IRValueType.Int4 => "int",
            IRValueType.UInt or IRValueType.UInt2 or IRValueType.UInt3 or IRValueType.UInt4 => "uint",
            IRValueType.Bool => "bool",
            IRValueType.Double => "double",
            _ => "float",
        };
        return count == 1 ? baseName : $"{baseName}{count}";
    }

    // ---------- expressions ----------

    private static string RenderExpression(IRExpression expr) => expr switch
    {
        IRExpression.IntrinsicExpression i => RenderIntrinsic(i),
        IRExpression.FusedMultiplyAddExpression f => $"mad({RenderExpression(f.A)}, {RenderExpression(f.B)}, {RenderExpression(f.C)})",
        IRExpression.MatrixVectorMultiplyExpression mv => RenderMatrixMultiply(mv),
        IRExpression.TextureOperationExpression tex => RenderTextureOp(tex),
        IRExpression.BinaryExpression b => $"({RenderExpression(b.Left)} {BinaryOpText(b.Operation)} {RenderExpression(b.Right)})",
        IRExpression.UnaryExpression u => RenderUnary(u),
        IRExpression.ConditionalExpression c => $"({RenderExpression(c.Condition)} ? {RenderExpression(c.TrueExpression)} : {RenderExpression(c.FalseExpression)})",
        IRExpression.DotProductExpression d => $"dot({RenderExpression(d.Left)}, {RenderExpression(d.Right)})",
        IRExpression.RegisterExpression r => r.Register.ToString(),
        IRExpression.ConstantExpression => expr.ToString()!,
        _ => expr.ToString()!, // no dedicated renderer yet — fall back to IR debug text rather than crash
    };

    private static string RenderUnary(IRExpression.UnaryExpression u) => u.Operation switch
    {
        IRExpression.UnaryExpression.UnaryOperation.Negate => $"-{RenderExpression(u.Operand)}",
        IRExpression.UnaryExpression.UnaryOperation.LogicalNot => $"!{RenderExpression(u.Operand)}",
        IRExpression.UnaryExpression.UnaryOperation.BitwiseNot => $"~{RenderExpression(u.Operand)}",
        IRExpression.UnaryExpression.UnaryOperation.Absolute => $"abs({RenderExpression(u.Operand)})",
        _ => RenderExpression(u.Operand),
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
    private static string RenderIntrinsic(IRExpression.IntrinsicExpression expr)
    {
        string Arg(int n) => RenderExpression(expr.Arguments[n]);
        string AllArgs() => string.Join(", ", expr.Arguments.Select(RenderExpression));

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

    private static string RenderMatrixMultiply(IRExpression.MatrixVectorMultiplyExpression mv)
    {
        if (mv.Rows.Count == 0)
            return $"/* TODO: empty matrix */ {RenderExpression(mv.Vector)}";

        string rows = string.Join(", ", mv.Rows.Select(r => r.ToString()));
        return $"mul(float{mv.Rows.Count}x4({rows}), {RenderExpression(mv.Vector)})";
    }

    // Confirmed 1:1 against real Texture2D/TextureCube method names;
    // Load/Sample/SampleLevel/SampleBias/SampleGrad/Gather keep the same
    // name DXBC uses, only the Compare variants and argument order/style
    // needed fixing up from the debug ToString().
    private static string RenderTextureOp(IRExpression.TextureOperationExpression tex)
    {
        string resource = tex.Resource.ToString();
        string? sampler = tex.Sampler?.ToString();
        string? coord = tex.Coordinates is null ? null : RenderExpression(tex.Coordinates);
        string? offset = tex.Offset is null ? null : RenderExpression(tex.Offset);

        string Args(params string?[] parts) => string.Join(", ", parts.Where(p => p is not null));

        return tex.Operation switch
        {
            IRExpression.TextureOperation.Sample =>
                $"{resource}.Sample({Args(sampler, coord, offset)})",
            IRExpression.TextureOperation.SampleLevel =>
                $"{resource}.SampleLevel({Args(sampler, coord, tex.LOD is null ? null : RenderExpression(tex.LOD), offset)})",
            IRExpression.TextureOperation.SampleBias =>
                $"{resource}.SampleBias({Args(sampler, coord, tex.Bias is null ? null : RenderExpression(tex.Bias), offset)})",
            IRExpression.TextureOperation.SampleGrad =>
                $"{resource}.SampleGrad({Args(sampler, coord, tex.GradX is null ? null : RenderExpression(tex.GradX), tex.GradY is null ? null : RenderExpression(tex.GradY), offset)})",
            IRExpression.TextureOperation.SampleCompare =>
                $"{resource}.SampleCmp({Args(sampler, coord, tex.CompareValue is null ? null : RenderExpression(tex.CompareValue), offset)})",
            IRExpression.TextureOperation.SampleCompareLevelZero =>
                $"{resource}.SampleCmpLevelZero({Args(sampler, coord, tex.CompareValue is null ? null : RenderExpression(tex.CompareValue), offset)})",
            IRExpression.TextureOperation.Load =>
                $"{resource}.Load({Args(coord, offset)})", // no sampler — Load reads texels directly
            IRExpression.TextureOperation.Gather =>
                $"{resource}.Gather({Args(sampler, coord, offset)})",
            IRExpression.TextureOperation.GatherCompare =>
                $"{resource}.GatherCmp({Args(sampler, coord, tex.CompareValue is null ? null : RenderExpression(tex.CompareValue), offset)})",
            _ =>
                $"/* TODO: no confirmed HLSL mapping for {tex.Operation} */ {resource}.{tex.Operation}({Args(sampler, coord)})",
        };
    }
}