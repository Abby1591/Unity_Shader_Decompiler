namespace Parser.DXBC.IR;

public abstract class IRStatement
{
    public sealed class IRAssignment : IRStatement
    {
        public IRRegister Destination { get; init; } = null!;
        public IRExpression Expression { get; init; } = null!;

        public override string ToString()
        {
            return $"{Destination} = {Expression}";
        }
    }
}