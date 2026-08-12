using System;
using System.Linq;
using System.Collections.Generic;

namespace Parser.DXBC.IR;

public abstract class IRExpression
{
    public abstract IRValueType Type { get; }

    public sealed class RegisterExpression : IRExpression
    {
        public IRRegister Register { get; init; } = null!;

        public override IRValueType Type => Register.Type;

        public override string ToString()
        {
            return Register.ToString();
        }
    }

    public sealed class ConstantExpression : IRExpression
    {
        public enum ConstantKind
        {
            Float,
            Int,
            UInt,
            Double
        }

        public ConstantKind Kind { get; init; } = ConstantKind.Float;

        public uint[] RawValues { get; init; } = Array.Empty<uint>();

        // Only populated for Kind == Double. Unlike Float/Int/UInt immediates
        // (which DXBC stores as raw 32-bit patterns in RawValues), 64-bit
        // double immediates come through Operand.Immediate64Values as actual
        // double values already, so there's no bit-reinterpretation to do.
        public double[] DoubleValues { get; init; } = Array.Empty<double>();

        public override IRValueType Type =>
            Kind switch
            {
                ConstantKind.Float => IRValueType.Float,
                ConstantKind.Int => IRValueType.Int,
                ConstantKind.UInt => IRValueType.UInt,
                ConstantKind.Double => IRValueType.Double,
                _ => IRValueType.Unknown
            };

        public override string ToString()
        {
            if (Kind == ConstantKind.Double)
            {
                return DoubleValues.Length == 1
                    ? DoubleValues[0].ToString()
                    : $"double{DoubleValues.Length}({string.Join(", ", DoubleValues)})";
            }

            string Format(uint value)
            {
                return Kind switch
                {
                    ConstantKind.Float =>
                        BitConverter.Int32BitsToSingle((int)value).ToString(),

                    ConstantKind.Int =>
                        unchecked((int)value).ToString(),

                    ConstantKind.UInt =>
                        value.ToString(),

                    _ => "?"
                };
            }

            if (RawValues.Length == 1)
                return Format(RawValues[0]);

            string prefix = Kind switch
            {
                ConstantKind.Float => "float",
                ConstantKind.Int => "int",
                ConstantKind.UInt => "uint",
                _ => "?"
            };

            return $"{prefix}{RawValues.Length}({string.Join(", ", RawValues.Select(Format))})";
        }
    }

    public enum BinaryOperation
    {
        Add,
        Subtract,
        Multiply,
        Divide,
        UnsignedDivide,
        Modulo,
        Equal,
        NotEqual,
        GreaterEqual,
        GreaterThan,
        LessThan,
        LessEqual,
        LogicalAnd,
        LogicalOr,
        BitwiseAnd,
        BitwiseOr,
        BitwiseXor,
        LeftShift,

        // ishr and ushr are not equivalent (sign-extending vs zero-filling),
        // so unlike DXBC's single "right shift" idea, the IR keeps them
        // distinct rather than folding both onto one RightShift operation.
        SignedRightShift,
        UnsignedRightShift,
    }

    public sealed class BinaryExpression : IRExpression
    {
        public BinaryOperation Operation { get; init; }

        public IRExpression Left { get; init; } = null!;

        public IRExpression Right { get; init; } = null!;

        public override IRValueType Type =>
            Operation switch
            {
                BinaryOperation.Equal => IRValueType.Bool,
                BinaryOperation.NotEqual => IRValueType.Bool,
                BinaryOperation.GreaterEqual => IRValueType.Bool,
                BinaryOperation.GreaterThan => IRValueType.Bool,
                BinaryOperation.LessThan => IRValueType.Bool,
                BinaryOperation.LessEqual => IRValueType.Bool,
                BinaryOperation.LogicalAnd => IRValueType.Bool,
                BinaryOperation.LogicalOr => IRValueType.Bool,
                _ => Left.Type == Right.Type ? Left.Type : IRValueType.Unknown,
            };

        public override string ToString()
        {
            string op = Operation switch
            {
                BinaryOperation.Add => "+",
                BinaryOperation.Subtract => "-",
                BinaryOperation.Multiply => "*",
                BinaryOperation.Divide => "/",
                BinaryOperation.UnsignedDivide => "/",
                BinaryOperation.Modulo => "%",
                BinaryOperation.Equal => "==",
                BinaryOperation.NotEqual => "!=",
                BinaryOperation.GreaterEqual => ">=",
                BinaryOperation.GreaterThan => ">",
                BinaryOperation.LessThan => "<",
                BinaryOperation.LessEqual => "<=",
                BinaryOperation.LogicalAnd => "&&",
                BinaryOperation.LogicalOr  => "||",
                BinaryOperation.BitwiseAnd => "&",
                BinaryOperation.BitwiseOr  => "|",
                BinaryOperation.BitwiseXor => "^",
                BinaryOperation.LeftShift  => "<<",
                BinaryOperation.SignedRightShift   => ">>",
                BinaryOperation.UnsignedRightShift => ">>>",
                _ => "?"
            };

            return $"({Left} {op} {Right})";
        }
    }
    
    public sealed class UnaryExpression : IRExpression
    {
        public enum UnaryOperation
        {
            Negate,
            LogicalNot,
            BitwiseNot,
            Absolute
        }

        public UnaryOperation Operation { get; init; }

        public IRExpression Operand { get; init; } = null!;

        public override IRValueType Type =>
            Operation == UnaryOperation.LogicalNot
                ? IRValueType.Bool
                : Operand.Type;

        public override string ToString()
        {
            return Operation switch
            {
                UnaryOperation.Negate     => $"-{Operand}",
                UnaryOperation.LogicalNot => $"!{Operand}",
                UnaryOperation.BitwiseNot => $"~{Operand}",
                UnaryOperation.Absolute   => $"abs({Operand})",
                _ => Operand.ToString()!
            };
        }
    }

    // Language-independent intrinsic identifiers. DXBC/HLSL-specific spelling
    // (e.g. "saturate", "frac", "rcp") stays out of the IR — the backend
    // decides how to render each of these for its target language.
    public enum IRIntrinsic
    {
        // casts / reinterpretation
        CastFloat,
        CastInt,
        CastUInt,
        CastDouble,
        CastBool,
        AsFloat,
        AsInt,
        AsUInt,
        F16ToF32,
        F32ToF16,

        // roots / powers / logs
        Sqrt,
        Rsqrt,
        Min,
        Max,
        Pow,
        Exp2,
        Log2,
        Reciprocal,

        // rounding / fractional
        Clamp01,
        FractionalPart,
        RoundNearestEven,
        Floor,
        Ceiling,
        Truncate,

        // trig (synthesized, not raw DXBC opcodes)
        Sin,
        Cos,
        Tan,
        Asin,
        Acos,
        Atan,
        Atan2,

        // geometry
        Normalize,
        Length,
        Distance,
        Reflect,
        Refract,
        FaceForward,
        Cross,
        Dot,
        Transpose,
        Determinant,
        Noise,

        // bit manipulation (kept here for opcodes without a dedicated node)
        CountBits,
        ReverseBits,
        FirstBitHigh,
        FirstBitLow,

        // misc arithmetic
        Lerp,
        Fmod,
        Modf,
        Ldexp,
        Frexp,
        DistanceVector,
        MaskedSumOfAbsoluteDifferences,

        // derivatives / boolean reduction
        DerivativeX,
        DerivativeXCoarse,
        DerivativeXFine,
        DerivativeY,
        DerivativeYCoarse,
        DerivativeYFine,
        Any,
        All,

        // resource queries
        CheckAccessFullyMapped,

        // pixel-shader input interpolation (evaluate an input at a
        // non-default location instead of the pixel center)
        EvalCentroid,
        EvalSampleIndex,
        EvalSnapped,
    }

    public sealed class IntrinsicExpression : IRExpression
    {
        public IRIntrinsic Intrinsic { get; init; }

        public List<IRExpression> Arguments { get; } = new();

        private IRValueType GetFirstArgumentType()
        {
            return Arguments.Count > 0
                ? Arguments[0].Type
                : IRValueType.Unknown;
        }

        public override IRValueType Type =>
            Intrinsic switch
            {
                IRIntrinsic.CastFloat => IRValueType.Float,
                IRIntrinsic.CastInt   => IRValueType.Int,
                IRIntrinsic.CastUInt  => IRValueType.UInt,
                IRIntrinsic.CastDouble => IRValueType.Double,
                IRIntrinsic.CastBool  => IRValueType.Bool,

                IRIntrinsic.Any => IRValueType.Bool,
                IRIntrinsic.All => IRValueType.Bool,

                // These always collapse a vector (or otherwise differently
                // typed) argument down to a single scalar — falling back to
                // GetFirstArgumentType() for these would wrongly propagate
                // e.g. a float4 argument's type onto a dot product's result.
                IRIntrinsic.Length => IRValueType.Float,
                IRIntrinsic.Distance => IRValueType.Float,
                IRIntrinsic.Determinant => IRValueType.Float,
                IRIntrinsic.CountBits => IRValueType.UInt,
                IRIntrinsic.ReverseBits => IRValueType.UInt,
                IRIntrinsic.FirstBitHigh => IRValueType.Int,
                IRIntrinsic.FirstBitLow => IRValueType.Int,
                IRIntrinsic.CheckAccessFullyMapped => IRValueType.Bool,

                _ => GetFirstArgumentType()
            };

        public override string ToString()
        {
            return $"{Intrinsic}({string.Join(", ", Arguments)})";
        }
    }

    // Fuses (a * b) + c into a single node instead of duplicating the
    // multiply-add tree across mad/imad/fma/dfma builders. The backend
    // decides whether to emit a real fma() call or expand it back out.
    public sealed class FusedMultiplyAddExpression : IRExpression
    {
        public IRExpression A { get; init; } = null!;
        public IRExpression B { get; init; } = null!;
        public IRExpression C { get; init; } = null!;

        public override IRValueType Type => A.Type == B.Type && B.Type == C.Type ? A.Type : IRValueType.Unknown;

        public override string ToString() => $"fma({A}, {B}, {C})";
    }

    // High half of a 32x32 -> 64 widening multiply (imul_hi / umul_hi).
    public sealed class MultiplyHighExpression : IRExpression
    {
        public IRExpression Left { get; init; } = null!;
        public IRExpression Right { get; init; } = null!;
        public bool Signed { get; init; }

        public override IRValueType Type => Signed ? IRValueType.Int : IRValueType.UInt;

        public override string ToString() => $"{(Signed ? "imul_hi" : "umul_hi")}({Left}, {Right})";
    }

    // mul64/umul64 are a distinct DXBC opcode pair from imul/umul — a real
    // 64-bit product, not the high 32 bits of a widening 32x32 multiply.
    // Folding this onto MultiplyHighExpression would silently lose that
    // distinction, so it gets its own node even though the shape is
    // superficially identical.
    //
    // Neither opcode has an OperandCount entry in ShdrParser's opcode table
    // yet, so it's unconfirmed whether DXBC exposes the result as a single
    // 64-bit-typed destination or splits it across a register pair the way
    // imul/udiv do. This models the single-destination case; if it turns
    // out to be a dual-output instruction, switch BuildMul64/BuildUMul64
    // to EmitMulti the same way BuildIMul does.
    public sealed class Multiply64Expression : IRExpression
    {
        public IRExpression Left { get; init; } = null!;
        public IRExpression Right { get; init; } = null!;
        public bool Signed { get; init; }

        public override IRValueType Type => Signed ? IRValueType.Int : IRValueType.UInt;

        public override string ToString() => $"{(Signed ? "mul64" : "umul64")}({Left}, {Right})";
    }

    public sealed class BitFieldInsertExpression : IRExpression
    {
        public IRExpression Width { get; init; } = null!;
        public IRExpression Offset { get; init; } = null!;
        public IRExpression Insert { get; init; } = null!;
        public IRExpression Base { get; init; } = null!;

        public override IRValueType Type => IRValueType.UInt;

        public override string ToString() => $"bitfieldinsert({Width}, {Offset}, {Insert}, {Base})";
    }

    public sealed class BitFieldExtractExpression : IRExpression
    {
        public IRExpression Width { get; init; } = null!;
        public IRExpression Offset { get; init; } = null!;
        public IRExpression Value { get; init; } = null!;
        public bool Signed { get; init; }

        public override IRValueType Type => Signed ? IRValueType.Int : IRValueType.UInt;

        public override string ToString() => $"bitfieldextract({Width}, {Offset}, {Value})";
    }

    public sealed class ConditionalExpression : IRExpression
    {
        public IRExpression Condition { get; init; } = null!;

        public IRExpression TrueExpression { get; init; } = null!;

        public IRExpression FalseExpression { get; init; } = null!;

        public override IRValueType Type =>
            TrueExpression.Type == FalseExpression.Type
                ? TrueExpression.Type
                : IRValueType.Unknown;

        public override string ToString()
        {
            return $"({Condition} ? {TrueExpression} : {FalseExpression})";
        }
    }

    public sealed class DotProductExpression : IRExpression
    {
        public IRExpression Left { get; init; } = null!;
        public IRExpression Right { get; init; } = null!;
        public int Components { get; init; }

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"dot({Left}, {Right})";
        }
    }

    // Created by Stage 13.5 temp fusion (HlslFuseTemps): when a single-use
    // assignment is inlined into its one consumer, the consumer's read of
    // the def may select, repeat, or reorder the def's lanes (a scalar def
    // broadcast into several lanes, a 3-lane def read as ".xyzx", ...).
    // Components are the SOURCE register component indices the read
    // selected (same indices a read swizzle would carry), in output order,
    // repeated as needed. They are relative to the *value expression's*
    // own lanes: a contiguous write mask trims the raw expression to those
    // exact lanes (destActive is restricted to contiguous masks), so source
    // component c is always the value's lane c. The backend broadcasts when
    // the value is width 1 and swizzles otherwise.
    public sealed class SwizzleExpression : IRExpression
    {
        public IRExpression Value { get; init; } = null!;

        public List<int> Components { get; init; } = new();

        public override IRValueType Type => Value.Type;

        public override string ToString()
        {
            const string letters = "xyzw";
            return $"({Value}).{string.Concat(Components.Select(i => letters[i]))}";
        }
    }
    
    // Reconstructed by Matrix Pattern Recognition (post-SSA, pre-HLSL-gen)
    // from a run of N "row dot vector" statements — e.g. the classic
    // mul/fma/fma/fma sequence per output component — that all read the
    // same vector and consecutive rows of the same constant-buffer-backed
    // register. Rows is ordered row0..rowN-1; Vector is shared by every
    // row. The backend renders this as mul(matrix, vector) (or expands it
    // back to per-row dot products if it would rather not assume a real
    // matrix type is available).
    public sealed class MatrixVectorMultiplyExpression : IRExpression
    {
        public List<IRRegister> Rows { get; init; } = new();

        public IRExpression Vector { get; init; } = null!;

        public override IRValueType Type => Vector.Type;

        public override string ToString()
        {
            string matrix = Rows.Count > 0
                ? $"{Rows[0]}..{Rows[^1]}"
                : "matrix";

            return $"mul({matrix}, {Vector})";
        }
    }
    
    // ===================== texture operations (consolidated) =====================
    // Single expression type covering every texture/buffer read instruction,
    // instead of one sealed class per DXBC opcode. Only the fields relevant
    // to a given Operation are populated; unused fields stay null. The old
    // per-opcode classes (TextureSampleExpression, TextureLoadExpression,
    // TextureGatherExpression, etc.) have been removed now that nothing
    // produces or consumes them anymore.
    public enum TextureOperation
    {
        Sample,
        SampleLevel,
        SampleGrad,
        SampleBias,
        SampleCompare,
        SampleCompareLevelZero,
        Load,
        Gather,
        GatherCompare,
        Lod,
        ResInfo,
        SampleInfo,
        SamplePos,
        BufInfo,
        CheckAccessFullyMapped,
    }

    public sealed class TextureOperationExpression : IRExpression
    {
        public TextureOperation Operation { get; init; }

        public IRRegister Resource { get; init; } = null!;

        public IRRegister? Sampler { get; init; }

        public IRExpression? Coordinates { get; init; }

        public IRExpression? Offset { get; init; }

        public IRExpression? LOD { get; init; }

        public IRExpression? Bias { get; init; }

        public IRExpression? CompareValue { get; init; }

        public IRExpression? GradX { get; init; }

        public IRExpression? GradY { get; init; }

        public IRExpression? SampleIndex { get; init; }

        public override IRValueType Type =>
            Operation switch
            {
                TextureOperation.SampleInfo => IRValueType.UInt,
                TextureOperation.CheckAccessFullyMapped => IRValueType.Bool,
                _ => IRValueType.Float
            };

        public override string ToString()
        {
            string args = string.Join(", ", new[]
            {
                Sampler?.ToString(),
                Coordinates?.ToString(),
                Offset is null ? null : $"offset={Offset}",
                LOD is null ? null : $"lod={LOD}",
                Bias is null ? null : $"bias={Bias}",
                CompareValue is null ? null : $"cmp={CompareValue}",
                GradX is null ? null : $"ddx={GradX}",
                GradY is null ? null : $"ddy={GradY}",
                SampleIndex is null ? null : $"sample={SampleIndex}",
            }.Where(s => s is not null));

            return $"{Resource}.{Operation}({args})";
        }
    }

}

// Phase 0: walks an expression tree collecting every IRRegister that is
// read by it — including registers used only for dynamic/relative
// indexing on another register (e.g. the r2 in cb0[r2.x]). This is the
// single source of truth IRStatement.Uses builds on, so every new
// IRExpression subclass needs a case added here or its operands will
// silently vanish from def/use analysis.
public static class IRExpressionExtensions
{
    public static IEnumerable<IRRegister> CollectRegisterUses(this IRExpression? expr)
    {
        switch (expr)
        {
            case null:
            case IRExpression.ConstantExpression:
                yield break;

            case IRExpression.RegisterExpression re:
                foreach (IRRegister r in re.Register.IndexRegisterUses())
                    yield return r;
                yield return re.Register;
                break;

            case IRExpression.BinaryExpression be:
                foreach (IRRegister r in be.Left.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in be.Right.CollectRegisterUses()) yield return r;
                break;

            case IRExpression.UnaryExpression ue:
                foreach (IRRegister r in ue.Operand.CollectRegisterUses()) yield return r;
                break;

            case IRExpression.IntrinsicExpression ie:
                foreach (IRExpression arg in ie.Arguments)
                    foreach (IRRegister r in arg.CollectRegisterUses())
                        yield return r;
                break;

            case IRExpression.FusedMultiplyAddExpression fma:
                foreach (IRRegister r in fma.A.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in fma.B.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in fma.C.CollectRegisterUses()) yield return r;
                break;

            case IRExpression.MultiplyHighExpression mh:
                foreach (IRRegister r in mh.Left.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in mh.Right.CollectRegisterUses()) yield return r;
                break;

            case IRExpression.Multiply64Expression m64:
                foreach (IRRegister r in m64.Left.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in m64.Right.CollectRegisterUses()) yield return r;
                break;

            case IRExpression.BitFieldInsertExpression bfi:
                foreach (IRRegister r in bfi.Width.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in bfi.Offset.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in bfi.Insert.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in bfi.Base.CollectRegisterUses()) yield return r;
                break;

            case IRExpression.BitFieldExtractExpression bfe:
                foreach (IRRegister r in bfe.Width.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in bfe.Offset.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in bfe.Value.CollectRegisterUses()) yield return r;
                break;

            case IRExpression.ConditionalExpression ce:
                foreach (IRRegister r in ce.Condition.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in ce.TrueExpression.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in ce.FalseExpression.CollectRegisterUses()) yield return r;
                break;

            case IRExpression.DotProductExpression dp:
                foreach (IRRegister r in dp.Left.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in dp.Right.CollectRegisterUses()) yield return r;
                break;

            case IRExpression.SwizzleExpression sw:
                foreach (IRRegister r in sw.Value.CollectRegisterUses()) yield return r;
                break;
            
            case IRExpression.MatrixVectorMultiplyExpression mv:
                foreach (IRRegister row in mv.Rows)
                {
                    foreach (IRRegister r in row.IndexRegisterUses()) yield return r;
                    yield return row;
                }
                foreach (IRRegister r in mv.Vector.CollectRegisterUses()) yield return r;
                break;

            case IRExpression.TextureOperationExpression tex:
                foreach (IRRegister r in tex.Resource.IndexRegisterUses()) yield return r;
                yield return tex.Resource;
                if (tex.Sampler is not null)
                {
                    foreach (IRRegister r in tex.Sampler.IndexRegisterUses()) yield return r;
                    yield return tex.Sampler;
                }
                foreach (IRRegister r in tex.Coordinates.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in tex.Offset.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in tex.LOD.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in tex.Bias.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in tex.CompareValue.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in tex.GradX.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in tex.GradY.CollectRegisterUses()) yield return r;
                foreach (IRRegister r in tex.SampleIndex.CollectRegisterUses()) yield return r;
                break;
        }
    }
}