namespace Parser.DXBC.IR;

public sealed class IRProgram
{
    public List<IRDeclaration> Declarations { get; } = new();

    public List<IRStatement> Statements { get; } = new();
}