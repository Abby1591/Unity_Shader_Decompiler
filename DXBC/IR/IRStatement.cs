using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public abstract class IRStatement
{
    public sealed class IRAssignment : IRStatement
    {
        public Operand Destination { get; init; } = null!;
        public IRExpression Expression { get; init; } = null!;
    }
}