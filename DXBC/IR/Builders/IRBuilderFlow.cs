using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // Control-flow opcodes emit IRStatement nodes directly onto the program
    // rather than producing/assigning an IRExpression.
    // ============================================================
    // If / else / endif
    // ============================================================

    private void BuildIf(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRIf
            {
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    private void BuildElse(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRElse());
    }

    private void BuildEndIf(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IREndIf());
    }

    // ============================================================
    // Loop / endloop
    // ============================================================

    private void BuildLoop(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRLoop());
    }

    private void BuildEndLoop(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IREndLoop());
    }

    // ============================================================
    // Switch / case / default / endswitch
    // ============================================================

    private void BuildSwitch(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRSwitch
            {
                Selector = BuildIntExpression(instruction.Operands[0])
            });
    }

    private void BuildCase(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRCase
            {
                Value = BuildIntExpression(instruction.Operands[0])
            });
    }

    private void BuildDefault(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRDefault());
    }

    private void BuildEndSwitch(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IREndSwitch());
    }

    // ============================================================
    // Break / continue
    // ============================================================

    private void BuildBreak(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRBreak());
    }

    private void BuildBreakC(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRBreak
            {
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    private void BuildContinue(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRContinue());
    }

    private void BuildContinueC(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRContinue
            {
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    // ============================================================
    // Return
    // ============================================================

    private void BuildRet(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRReturn());
    }

    private void BuildRetC(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRReturn
            {
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    // ============================================================
    // Discard
    // ============================================================

    private void BuildDiscard(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRDiscard
            {
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    // ============================================================
    // Label
    // ============================================================

    private void BuildLabel(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRLabel
            {
                Name = instruction.Operands[0].RegisterIndex.ToString()
            });
    }

    // ============================================================
    // Call / callc
    // ============================================================

    private void BuildCall(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRCall
            {
                Label = instruction.Operands[0].RegisterIndex.ToString()
            });
    }

    private void BuildCallC(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRCall
            {
                Label = instruction.Operands[1].RegisterIndex.ToString(),
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    // ============================================================
    // Dynamic linkage
    // ============================================================

    // interface_call fnIndex, interfaceIndex — operand layout is a guess
    // (dcl_interface's slot table isn't opcode-numbered yet either); revisit
    // once both are confirmed.
    private void BuildInterfaceCall(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRInterfaceCall
            {
                InterfaceIndex = instruction.Operands[0].RegisterIndex,
                FunctionIndex = instruction.Operands[1].RegisterIndex
            });
    }

    private void BuildInterfaceCallC(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRInterfaceCall
            {
                InterfaceIndex = instruction.Operands[1].RegisterIndex,
                FunctionIndex = instruction.Operands[2].RegisterIndex,
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    private void BuildEmit(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IREmitVertex());
    }

    private void BuildEmitStream(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IREmitVertex { Stream = instruction.Operands[0].RegisterIndex });
    }

    // cut / RestartStrip are the same operation (RestartStrip is just the
    // HLSL-facing name for the SM4 "cut" opcode)
    private void BuildCut(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRCutStream());
    }

    private void BuildCutStream(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRCutStream { Stream = instruction.Operands[0].RegisterIndex });
    }

    private void BuildEmitThenCut(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRCutStream { EmitBeforeCut = true });
    }

    private void BuildEmitThenCutStream(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRCutStream
        {
            Stream = instruction.Operands[0].RegisterIndex,
            EmitBeforeCut = true
        });
    }

    // sync's operand-less token itself carries which barrier flags are active
    // (group-shared / device-memory / group-sync) as bits in the opcode token,
    // not as separate instructions — DXBC has one "sync" opcode, and HLSL's
    // distinct GroupMemoryBarrier/DeviceMemoryBarrier/AllMemoryBarrier (with or
    // without ...WithGroupSync) all compile down to it with different flag bits
    // set. ShdrParser doesn't decode those flag bits yet (no opcode-table entry
    // for sync at all), so the six BuildXxxBarrier methods below assume the
    // eventual sync instruction handling passes the decoded flags through
    // instruction.ExtraData[0] as a BarrierFlags-shaped uint — adjust once the
    // opcode number and flag-bit layout are confirmed against shader_sm4.c.
    private void BuildSync(IRProgram program, Instruction instruction)
    {
        var flags = instruction.ExtraData.Count > 0
            ? (IRStatement.BarrierFlags)instruction.ExtraData[0]
            : IRStatement.BarrierFlags.None;

        program.Statements.Add(new IRStatement.IRBarrier { Flags = flags });
    }

    private void BuildGroupMemoryBarrier(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRBarrier { Flags = IRStatement.BarrierFlags.GroupShared });
    }

    private void BuildGroupMemoryBarrierWithGroupSync(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRBarrier
        {
            Flags = IRStatement.BarrierFlags.GroupShared | IRStatement.BarrierFlags.GroupSync
        });
    }

    private void BuildDeviceMemoryBarrier(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRBarrier { Flags = IRStatement.BarrierFlags.DeviceMemory });
    }

    private void BuildDeviceMemoryBarrierWithGroupSync(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRBarrier
        {
            Flags = IRStatement.BarrierFlags.DeviceMemory | IRStatement.BarrierFlags.GroupSync
        });
    }

    private void BuildAllMemoryBarrier(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRBarrier
        {
            Flags = IRStatement.BarrierFlags.GroupShared | IRStatement.BarrierFlags.DeviceMemory
        });
    }

    private void BuildAllMemoryBarrierWithGroupSync(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRBarrier
        {
            Flags = IRStatement.BarrierFlags.GroupShared
                  | IRStatement.BarrierFlags.DeviceMemory
                  | IRStatement.BarrierFlags.GroupSync
        });
    }

    // DXBC has two forms of every atomic op:
    //   atomic_iadd uav0, address, value          — fire-and-forget, no result
    //   imm_atomic_iadd dest, uav0, address, value — returns the pre-op value
    // HLSL's InterlockedAdd(...) without an out-param compiles to the former;
    // InterlockedAdd(..., out original) compiles to the latter. Both shapes are
    // covered by the single BuildAtomic/BuildImmAtomic helpers below rather than
    // one method per opcode.
    private void BuildAtomic(IRProgram program, Instruction instruction, IRStatement.AtomicOperation operation)
    {
        program.Statements.Add(
            new IRStatement.IRAtomicOp
            {
                Operation = operation,
                Resource = BuildRegister(instruction.Operands[0]),
                Address = BuildExpression(instruction.Operands[1]),
                Value = BuildExpression(instruction.Operands[2])
            });
    }

    private void BuildImmAtomic(IRProgram program, Instruction instruction, IRStatement.AtomicOperation operation)
    {
        program.Statements.Add(
            new IRStatement.IRAtomicOp
            {
                Operation = operation,
                ResultDestination = BuildRegister(instruction.Operands[0]),
                Resource = BuildRegister(instruction.Operands[1]),
                Address = BuildExpression(instruction.Operands[2]),
                Value = BuildExpression(instruction.Operands[3])
            });
    }

    // ============================================================
    // Fire-and-forget (atomic_*)
    // ============================================================

    private void BuildAtomicIAdd(IRProgram program, Instruction instruction)
    {
        BuildAtomic(program, instruction, IRStatement.AtomicOperation.IAdd);
    }

    private void BuildAtomicAnd(IRProgram program, Instruction instruction)
    {
        BuildAtomic(program, instruction, IRStatement.AtomicOperation.And);
    }

    private void BuildAtomicOr(IRProgram program, Instruction instruction)
    {
        BuildAtomic(program, instruction, IRStatement.AtomicOperation.Or);
    }

    private void BuildAtomicXor(IRProgram program, Instruction instruction)
    {
        BuildAtomic(program, instruction, IRStatement.AtomicOperation.Xor);
    }

    private void BuildAtomicIMin(IRProgram program, Instruction instruction)
    {
        BuildAtomic(program, instruction, IRStatement.AtomicOperation.IMin);
    }

    private void BuildAtomicIMax(IRProgram program, Instruction instruction)
    {
        BuildAtomic(program, instruction, IRStatement.AtomicOperation.IMax);
    }

    private void BuildAtomicUMin(IRProgram program, Instruction instruction)
    {
        BuildAtomic(program, instruction, IRStatement.AtomicOperation.UMin);
    }

    private void BuildAtomicUMax(IRProgram program, Instruction instruction)
    {
        BuildAtomic(program, instruction, IRStatement.AtomicOperation.UMax);
    }

    // atomic_cmp_store dest[address] = (dest[address] == compare) ? value : dest[address]
    private void BuildAtomicCmpStore(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRAtomicOp
            {
                Operation = IRStatement.AtomicOperation.CompareStore,
                Resource = BuildRegister(instruction.Operands[0]),
                Address = BuildExpression(instruction.Operands[1]),
                CompareValue = BuildExpression(instruction.Operands[2]),
                Value = BuildExpression(instruction.Operands[3])
            });
    }

    // ============================================================
    // Result-returning (imm_atomic_* / InterlockedXxx(..., out original))
    // ============================================================

    private void BuildImmAtomicIAdd(IRProgram program, Instruction instruction)
    {
        BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.IAdd);
    }

    private void BuildImmAtomicAnd(IRProgram program, Instruction instruction)
    {
        BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.And);
    }

    private void BuildImmAtomicOr(IRProgram program, Instruction instruction)
    {
        BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.Or);
    }

    private void BuildImmAtomicXor(IRProgram program, Instruction instruction)
    {
        BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.Xor);
    }

    private void BuildImmAtomicIMin(IRProgram program, Instruction instruction)
    {
        BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.IMin);
    }

    private void BuildImmAtomicIMax(IRProgram program, Instruction instruction)
    {
        BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.IMax);
    }

    private void BuildImmAtomicUMin(IRProgram program, Instruction instruction)
    {
        BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.UMin);
    }

    private void BuildImmAtomicUMax(IRProgram program, Instruction instruction)
    {
        BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.UMax);
    }

    private void BuildImmAtomicExch(IRProgram program, Instruction instruction)
    {
        BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.Exchange);
    }

    // imm_atomic_cmp_exch dest = old value at address; address <- (old == compare) ? value : old
    private void BuildImmAtomicCmpExch(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRAtomicOp
            {
                Operation = IRStatement.AtomicOperation.CompareExchange,
                ResultDestination = BuildRegister(instruction.Operands[0]),
                Resource = BuildRegister(instruction.Operands[1]),
                Address = BuildExpression(instruction.Operands[2]),
                CompareValue = BuildExpression(instruction.Operands[3]),
                Value = BuildExpression(instruction.Operands[4])
            });
    }
}