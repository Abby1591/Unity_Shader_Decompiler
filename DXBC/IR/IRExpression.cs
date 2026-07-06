namespace Parser.DXBC.IR;

public abstract class IRExpression
{
    public sealed class RegisterExpression : IRExpression
    {
        public IRRegister Register { get; init; } = null!;

        public override string ToString()
        {
            return Register.ToString();
        }
    }

    public sealed class ConstantExpression : IRExpression
    {
        public float[] Values { get; init; } = Array.Empty<float>();

        public override string ToString()
        {
            if (Values.Length == 1)
                return Values[0].ToString();

            return $"float{Values.Length}({string.Join(", ", Values)})";
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
    
    public sealed class IntrinsicExpression : IRExpression
    {
        public string Name { get; init; } = "";

        public List<IRExpression> Arguments { get; } = new();

        public override string ToString()
        {
            return $"{Name}({string.Join(", ", Arguments)})";
        }
    }
}