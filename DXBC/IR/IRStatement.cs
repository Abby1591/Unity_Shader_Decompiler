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
    
    public sealed class IRIf : IRStatement
    {
        public IRExpression Condition { get; init; } = null!;

        public override string ToString()
            => $"if ({Condition})";
    }

    public sealed class IRElse : IRStatement
    {
        public override string ToString() => "else";
    }

    public sealed class IREndIf : IRStatement
    {
        public override string ToString() => "endif";
    }

    public sealed class IRLoop : IRStatement
    {
        public override string ToString() => "loop";
    }

    public sealed class IREndLoop : IRStatement
    {
        public override string ToString() => "endloop";
    }

    public sealed class IRBreak : IRStatement
    {
        public IRExpression Condition { get; init; } = null!;

        public override string ToString()
            => $"breakc ({Condition})";
    }

    public sealed class IRReturn : IRStatement
    {
        public override string ToString() => "return";
    }
}