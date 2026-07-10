using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ===================== float comparisons =====================

    private void BuildEq(IRProgram program, Instruction instruction)
    {
        BuildComparison(program, instruction, IRExpression.BinaryOperation.Equal);
    }

    private void BuildNe(IRProgram program, Instruction instruction)
    {
        BuildComparison(program, instruction, IRExpression.BinaryOperation.NotEqual);
    }

    private void BuildGE(IRProgram program, Instruction instruction)
    {
        BuildComparison(program, instruction, IRExpression.BinaryOperation.GreaterEqual);
    }

    private void BuildLt(IRProgram program, Instruction instruction)
    {
        BuildComparison(program, instruction, IRExpression.BinaryOperation.LessThan);
    }

    // ===================== signed integer comparisons =====================

    private void BuildIeq(IRProgram program, Instruction instruction)
    {
        BuildIntComparison(program, instruction, IRExpression.BinaryOperation.Equal);
    }

    private void BuildIne(IRProgram program, Instruction instruction)
    {
        BuildIntComparison(program, instruction, IRExpression.BinaryOperation.NotEqual);
    }

    private void BuildIge(IRProgram program, Instruction instruction)
    {
        BuildIntComparison(program, instruction, IRExpression.BinaryOperation.GreaterEqual);
    }

    private void BuildIlt(IRProgram program, Instruction instruction)
    {
        BuildIntComparison(program, instruction, IRExpression.BinaryOperation.LessThan);
    }

    // ===================== unsigned integer comparisons =====================

    private void BuildUge(IRProgram program, Instruction instruction)
    {
        BuildUIntComparison(program, instruction, IRExpression.BinaryOperation.GreaterEqual);
    }

    private void BuildUlt(IRProgram program, Instruction instruction)
    {
        BuildUIntComparison(program, instruction, IRExpression.BinaryOperation.LessThan);
    }

    // ===================== helpers =====================

    private void BuildComparison(
        IRProgram program,
        Instruction instruction,
        IRExpression.BinaryOperation operation)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = operation,
                Left = BuildExpression(instruction.Operands[1]),
                Right = BuildExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildIntComparison(
        IRProgram program,
        Instruction instruction,
        IRExpression.BinaryOperation operation)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = operation,
                Left = BuildIntExpression(instruction.Operands[1]),
                Right = BuildIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildUIntComparison(
        IRProgram program,
        Instruction instruction,
        IRExpression.BinaryOperation operation)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = operation,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== le / gt (float) =====================
    // Not real SM4 opcodes — SM4 only has ge/lt; le/gt are synthesized by
    // swapping the operand order around ge/lt: a<=b == b>=a, a>b == b<a.

    private void BuildLe(IRProgram program, Instruction instruction)
        => BuildComparisonSwapped(program, instruction, IRExpression.BinaryOperation.GreaterEqual);

    private void BuildGt(IRProgram program, Instruction instruction)
        => BuildComparisonSwapped(program, instruction, IRExpression.BinaryOperation.LessThan);

    // ===================== ugt / ule (unsigned) =====================

    private void BuildUgt(IRProgram program, Instruction instruction)
        => BuildUIntComparisonSwapped(program, instruction, IRExpression.BinaryOperation.LessThan);

    private void BuildUle(IRProgram program, Instruction instruction)
        => BuildUIntComparisonSwapped(program, instruction, IRExpression.BinaryOperation.GreaterEqual);

    private void BuildComparisonSwapped(
        IRProgram program,
        Instruction instruction,
        IRExpression.BinaryOperation operation)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = operation,
                Left = BuildExpression(instruction.Operands[2]),
                Right = BuildExpression(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildUIntComparisonSwapped(
        IRProgram program,
        Instruction instruction,
        IRExpression.BinaryOperation operation)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = operation,
                Left = BuildUIntExpression(instruction.Operands[2]),
                Right = BuildUIntExpression(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== derivatives =====================

    private void BuildDerivRtx(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "ddx");
    private void BuildDerivRty(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "ddy");
    private void BuildDerivRtxCoarse(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "ddx_coarse");
    private void BuildDerivRtxFine(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "ddx_fine");
    private void BuildDerivRtyCoarse(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "ddy_coarse");
    private void BuildDerivRtyFine(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "ddy_fine");

    // ===================== boolean reductions =====================

    private void BuildAny(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "any");
    private void BuildAll(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "all");
}