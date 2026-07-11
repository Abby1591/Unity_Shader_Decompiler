using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

// DXBC has two forms of every atomic op:
//   atomic_iadd uav0, address, value          — fire-and-forget, no result
//   imm_atomic_iadd dest, uav0, address, value — returns the pre-op value
// HLSL's InterlockedAdd(...) without an out-param compiles to the former;
// InterlockedAdd(..., out original) compiles to the latter. Both shapes are
// covered by the single BuildAtomic/BuildImmAtomic helpers below rather than
// one method per opcode.
public partial class IRBuilder
{
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

    // ===================== fire-and-forget (atomic_*) =====================

    private void BuildAtomicIAdd(IRProgram program, Instruction instruction) => BuildAtomic(program, instruction, IRStatement.AtomicOperation.IAdd);
    private void BuildAtomicAnd(IRProgram program, Instruction instruction) => BuildAtomic(program, instruction, IRStatement.AtomicOperation.And);
    private void BuildAtomicOr(IRProgram program, Instruction instruction) => BuildAtomic(program, instruction, IRStatement.AtomicOperation.Or);
    private void BuildAtomicXor(IRProgram program, Instruction instruction) => BuildAtomic(program, instruction, IRStatement.AtomicOperation.Xor);
    private void BuildAtomicIMin(IRProgram program, Instruction instruction) => BuildAtomic(program, instruction, IRStatement.AtomicOperation.IMin);
    private void BuildAtomicIMax(IRProgram program, Instruction instruction) => BuildAtomic(program, instruction, IRStatement.AtomicOperation.IMax);
    private void BuildAtomicUMin(IRProgram program, Instruction instruction) => BuildAtomic(program, instruction, IRStatement.AtomicOperation.UMin);
    private void BuildAtomicUMax(IRProgram program, Instruction instruction) => BuildAtomic(program, instruction, IRStatement.AtomicOperation.UMax);

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

    // ===================== result-returning (imm_atomic_* / InterlockedXxx(..., out original)) =====================

    private void BuildImmAtomicIAdd(IRProgram program, Instruction instruction) => BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.IAdd);
    private void BuildImmAtomicAnd(IRProgram program, Instruction instruction) => BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.And);
    private void BuildImmAtomicOr(IRProgram program, Instruction instruction) => BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.Or);
    private void BuildImmAtomicXor(IRProgram program, Instruction instruction) => BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.Xor);
    private void BuildImmAtomicIMin(IRProgram program, Instruction instruction) => BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.IMin);
    private void BuildImmAtomicIMax(IRProgram program, Instruction instruction) => BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.IMax);
    private void BuildImmAtomicUMin(IRProgram program, Instruction instruction) => BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.UMin);
    private void BuildImmAtomicUMax(IRProgram program, Instruction instruction) => BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.UMax);
    private void BuildImmAtomicExch(IRProgram program, Instruction instruction) => BuildImmAtomic(program, instruction, IRStatement.AtomicOperation.Exchange);

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