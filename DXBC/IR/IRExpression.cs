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
        DirectionVector,
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

        public override IRValueType Type => A.Type == B.Type && B.Type == C.Type ? A.Type : A.Type;

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