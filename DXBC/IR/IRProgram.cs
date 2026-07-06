using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public sealed class IRProgram
{
    public List<IRStatement> Statements { get; } = new();
}