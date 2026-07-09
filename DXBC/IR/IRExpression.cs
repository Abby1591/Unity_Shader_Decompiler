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
            UInt
        }

        public ConstantKind Kind { get; init; } = ConstantKind.Float;

        public uint[] RawValues { get; init; } = Array.Empty<uint>();

        public override IRValueType Type =>
            Kind switch
            {
                ConstantKind.Float => IRValueType.Float,
                ConstantKind.Int => IRValueType.Int,
                ConstantKind.UInt => IRValueType.UInt,
                _ => IRValueType.Unknown
            };

        public override string ToString()
        {
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
        LessThan
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
            BitwiseNot
        }

        public UnaryOperation Operation { get; init; }

        public IRExpression Operand { get; init; } = null!;

        public override IRValueType Type =>
            Operation switch
            {
                UnaryOperation.LogicalNot => IRValueType.Bool,
                _ => Operand.Type
            };

        public override string ToString()
        {
            return Operation switch
            {
                UnaryOperation.Negate    => $"-{Operand}",
                UnaryOperation.LogicalNot => $"!{Operand}",
                UnaryOperation.BitwiseNot => $"~{Operand}",
                _ => Operand?.ToString() ?? "<?>"
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
}