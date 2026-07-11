using System;
using System.Collections.Generic;

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

    // ===================== multi-output instructions =====================

    // Instructions with more than one destination register (imul dest_hi,
    // dest_lo, src0, src1 / udiv quotient, remainder, src0, src1). A plain
    // IRAssignment can only carry one destination, so those builders were
    // previously discarding all but the first — this is the correct shape.
    public sealed class IRMultiAssignment : IRStatement
    {
        // Parallel to Destinations — Destinations[i] receives Expressions[i].
        // A null register at index i (DXBC allows writing "null" to discard
        // an output, e.g. imul with only the low part wanted) means that
        // output is unused and should be dropped by any consumer.
        public List<IRRegister?> Destinations { get; } = new();

        public List<IRExpression> Expressions { get; } = new();

        public override string ToString()
        {
            var parts = new string[Destinations.Count];

            for (int i = 0; i < Destinations.Count; i++)
                parts[i] = $"{(Destinations[i]?.ToString() ?? "null")} = {Expressions[i]}";

            return string.Join(", ", parts);
        }
    }

    // ===================== UAV atomics =====================

    public enum AtomicOperation
    {
        IAdd,
        And,
        Or,
        Xor,
        IMin,
        IMax,
        UMin,
        UMax,
        Exchange,
        CompareStore,
        CompareExchange,
    }

    // atomic_* / imm_atomic_* / Interlocked* — read-modify-write on a UAV or
    // thread-group-shared-memory location. ResultDestination is set only for
    // the "imm_atomic_*" / InterlockedXxx-with-original-value forms; the
    // plain atomic_* forms don't return a value.
    public sealed class IRAtomicOp : IRStatement
    {
        public AtomicOperation Operation { get; init; }

        public IRRegister Resource { get; init; } = null!;

        public IRExpression Address { get; init; } = null!;

        public IRExpression Value { get; init; } = null!;

        // Only used by CompareExchange/CompareStore
        public IRExpression? CompareValue { get; init; }

        public IRRegister? ResultDestination { get; init; }

        public override string ToString()
        {
            string call = Operation switch
            {
                AtomicOperation.CompareExchange or AtomicOperation.CompareStore
                    => $"{Operation}({Resource}[{Address}], {CompareValue}, {Value})",
                _ => $"{Operation}({Resource}[{Address}], {Value})"
            };

            return ResultDestination is null ? call : $"{ResultDestination} = {call}";
        }
    }

    // ===================== synchronization / barriers =====================

    [Flags]
    public enum BarrierFlags
    {
        None = 0,
        GroupShared = 1 << 0,
        DeviceMemory = 1 << 1,
        GroupSync = 1 << 2,
    }

    // sync / groupmemorybarrier(withgroupsync) / devicememorybarrier(withgroupsync)
    // / allmemorybarrier(withgroupsync)
    public sealed class IRBarrier : IRStatement
    {
        public BarrierFlags Flags { get; init; }

        public override string ToString() => $"barrier({Flags})";
    }

    // ===================== geometry shader =====================

    // emit / emitStream — appends the current vertex to an output stream
    public sealed class IREmitVertex : IRStatement
    {
        // null for the default (single-stream) emit; set for emitStream/dcl_stream targeting
        public uint? Stream { get; init; }

        public override string ToString()
            => Stream is null ? "emit" : $"emitStream({Stream})";
    }

    // cut / cutStream / emitThenCut / emitThenCutStream — ends the current
    // primitive strip. EmitBeforeCut distinguishes emitThenCut from a plain cut.
    public sealed class IRCutStream : IRStatement
    {
        public uint? Stream { get; init; }

        public bool EmitBeforeCut { get; init; }

        public override string ToString()
        {
            string name = EmitBeforeCut ? "emitThenCut" : "cut";
            return Stream is null ? name : $"{name}Stream({Stream})";
        }
    }

    // ===================== hull shader phases =====================

    public enum HullShaderPhaseKind
    {
        ControlPoint,
        Fork,
        Join,
    }

    // hs_control_point_phase / hs_fork_phase / hs_join_phase — these mark a
    // boundary between hull-shader sub-programs rather than doing any work
    // themselves, similar in spirit to IRLabel.
    public sealed class IRPhase : IRStatement
    {
        public HullShaderPhaseKind Kind { get; init; }

        public override string ToString() => Kind switch
        {
            HullShaderPhaseKind.ControlPoint => "hs_control_point_phase",
            HullShaderPhaseKind.Fork => "hs_fork_phase",
            HullShaderPhaseKind.Join => "hs_join_phase",
            _ => "phase"
        };
    }

    // ===================== dynamic linkage =====================

    // interface_call / interface_callc — invokes a method through a
    // dcl_interface slot table rather than a fixed dcl_function_body label.
    public sealed class IRInterfaceCall : IRStatement
    {
        public uint InterfaceIndex { get; init; }

        public uint FunctionIndex { get; init; }

        public IRExpression? Condition { get; init; }

        public override string ToString()
        {
            string call = $"interface_call({InterfaceIndex}, {FunctionIndex})";
            return Condition is null ? call : $"{call} if ({Condition})";
        }
    }
}