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

    // break / breakc: Condition is null for an unconditional break
    public sealed class IRBreak : IRStatement
    {
        public IRExpression? Condition { get; init; }

        public override string ToString()
            => Condition is null ? "break" : $"breakc ({Condition})";
    }

    // continue / continuec: Condition is null for an unconditional continue
    public sealed class IRContinue : IRStatement
    {
        public IRExpression? Condition { get; init; }

        public override string ToString()
            => Condition is null ? "continue" : $"continuec ({Condition})";
    }

    // ret / retc: Condition is null for an unconditional return
    public sealed class IRReturn : IRStatement
    {
        public IRExpression? Condition { get; init; }

        public override string ToString()
            => Condition is null ? "return" : $"retc ({Condition})";
    }

    public sealed class IRSwitch : IRStatement
    {
        public IRExpression Selector { get; init; } = null!;

        public override string ToString()
            => $"switch ({Selector})";
    }

    public sealed class IRCase : IRStatement
    {
        public IRExpression Value { get; init; } = null!;

        public override string ToString()
            => $"case {Value}";
    }

    public sealed class IRDefault : IRStatement
    {
        public override string ToString() => "default";
    }

    public sealed class IREndSwitch : IRStatement
    {
        public override string ToString() => "endswitch";
    }

    public sealed class IRDiscard : IRStatement
    {
        public IRExpression Condition { get; init; } = null!;

        public override string ToString()
            => $"discard ({Condition})";
    }

    public sealed class IRLabel : IRStatement
    {
        public string Name { get; init; } = "";

        public override string ToString()
            => $"label {Name}";
    }

    // call / callc: invoke a function body declared via dcl_function_body
    public sealed class IRCall : IRStatement
    {
        public string Label { get; init; } = "";

        public IRExpression? Condition { get; init; }

        public override string ToString()
            => Condition is null ? $"call {Label}" : $"callc {Label} ({Condition})";
    }

    // Writes to a UAV / raw / structured buffer (store_raw, store_structured).
    // Unlike IRAssignment this has no register destination — the target is a
    // resource plus an address.
    public sealed class IRMemoryStore : IRStatement
    {
        public IRRegister Resource { get; init; } = null!;

        public IRExpression Address { get; init; } = null!;

        public IRExpression Value { get; init; } = null!;

        public override string ToString()
            => $"{Resource}[{Address}] = {Value}";
    }
}