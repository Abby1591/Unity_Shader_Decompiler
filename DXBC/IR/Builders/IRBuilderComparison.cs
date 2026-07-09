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
}