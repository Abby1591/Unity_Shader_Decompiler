using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public abstract class IRExpression
{
    public sealed class RegisterExpression : IRExpression
    {
        public Operand Operand { get; init; } = null!;
    }
    
    public sealed class ConstantExpression : IRExpression
    {
        public float[] Values { get; init; } = Array.Empty<float>();
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
    }
    
    public sealed class IntrinsicExpression : IRExpression
    {
        public string Name { get; init; } = "";

        public List<IRExpression> Arguments { get; } = new();
    }
}