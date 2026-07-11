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
        Equal,
        NotEqual,
        GreaterEqual,
        LessThan,
        BitwiseAnd,
        BitwiseOr,
        BitwiseXor,
        LeftShift,
        RightShift,
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
                BinaryOperation.LessThan => IRValueType.Bool,
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
                BinaryOperation.Equal => "==",
                BinaryOperation.NotEqual => "!=",
                BinaryOperation.GreaterEqual => ">=",
                BinaryOperation.LessThan => "<",
                BinaryOperation.BitwiseAnd => "&",
                BinaryOperation.BitwiseOr  => "|",
                BinaryOperation.BitwiseXor => "^",
                BinaryOperation.LeftShift  => "<<",
                BinaryOperation.RightShift => ">>",
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

    public sealed class IntrinsicExpression : IRExpression
    {
        public string Name { get; init; } = "";

        public List<IRExpression> Arguments { get; } = new();

        private IRValueType GetFirstArgumentType()
        {
            return Arguments.Count > 0
                ? Arguments[0].Type
                : IRValueType.Unknown;
        }

        public override IRValueType Type =>
            Name switch
            {
                "float" => IRValueType.Float,
                "int"   => IRValueType.Int,
                "uint"  => IRValueType.UInt,

                "any"   => IRValueType.Bool,
                "all"   => IRValueType.Bool,

                _ => GetFirstArgumentType()
            };

        public override string ToString()
        {
            return $"{Name}({string.Join(", ", Arguments)})";
        }
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
    // to a given Operation are populated; unused fields stay null. This is
    // the type IRBuilderTexture.cs now emits — the individual
    // TextureSampleExpression / TextureLoadExpression / TextureGatherExpression
    // / etc. classes below are kept only so nothing else referencing them
    // breaks, but are no longer produced by the builder.
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

    // ===================== texture sampling (superseded by TextureOperationExpression) =====================

    public sealed class TextureSampleExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public IRExpression? Offset { get; init; }

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.Sample({Sampler}, {Coordinates})";
        }
    }

    public sealed class TextureSampleLevelExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public IRExpression Level { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.SampleLevel({Sampler}, {Coordinates}, {Level})";
        }
    }

    // sample_d: sample with explicit gradients
    public sealed class TextureSampleGradExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public IRExpression DDX { get; init; } = null!;

        public IRExpression DDY { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.SampleGrad({Sampler}, {Coordinates}, {DDX}, {DDY})";
        }
    }

    // sample_b: sample with mip-level bias
    public sealed class TextureSampleBiasExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public IRExpression Bias { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.SampleBias({Sampler}, {Coordinates}, {Bias})";
        }
    }

    // sample_c: comparison sample (shadow maps)
    public sealed class TextureSampleCompareExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public IRExpression CompareValue { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.SampleCmp({Sampler}, {Coordinates}, {CompareValue})";
        }
    }

    // sample_c_lz: comparison sample, forced to mip level 0
    public sealed class TextureSampleCompareLevelZeroExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public IRExpression CompareValue { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.SampleCmpLevelZero({Sampler}, {Coordinates}, {CompareValue})";
        }
    }

    // sample_info: number of samples in a resource
    public sealed class SampleInfoExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public override IRValueType Type => IRValueType.UInt;

        public override string ToString()
        {
            return $"{Resource}.GetSampleInfo()";
        }
    }

    // ===================== texture load =====================

    public sealed class TextureLoadExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public IRExpression? SampleIndex { get; init; }

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return SampleIndex is null
                ? $"{Resource}.Load({Coordinates})"
                : $"{Resource}.Load({Coordinates}, {SampleIndex})";
        }
    }

    // ===================== texture gather =====================

    public sealed class TextureGatherExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.Gather({Sampler}, {Coordinates})";
        }
    }

    public sealed class TextureGatherCompareExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public IRExpression CompareValue { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.GatherCmp({Sampler}, {Coordinates}, {CompareValue})";
        }
    }

    public sealed class TextureGatherOffsetExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public IRExpression Offset { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.Gather({Sampler}, {Coordinates}, {Offset})";
        }
    }

    public sealed class TextureGatherOffsetCompareExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public IRExpression Offset { get; init; } = null!;

        public IRExpression CompareValue { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.GatherCmp({Sampler}, {Coordinates}, {Offset}, {CompareValue})";
        }
    }

    // ===================== misc texture queries =====================

    // lod: computes the mip level that would be used by a sample operation
    public sealed class TextureLodExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRRegister Sampler { get; init; } = null!;

        public IRExpression Coordinates { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.CalculateLevelOfDetail({Sampler}, {Coordinates})";
        }
    }

    // resinfo: dimensions of a resource at a given mip level
    public sealed class ResourceInfoExpression : IRExpression
    {
        public IRRegister Resource { get; init; } = null!;

        public IRExpression MipLevel { get; init; } = null!;

        public override IRValueType Type => IRValueType.Float;

        public override string ToString()
        {
            return $"{Resource}.GetDimensions({MipLevel})";
        }
    }
}