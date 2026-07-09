using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildEq(IRProgram program, Instruction instruction)
    {
        BuildComparison(
            program,
            instruction,
            IRExpression.BinaryOperation.Equal);
    }

    private void BuildNe(IRProgram program, Instruction instruction)
    {
        BuildComparison(
            program,
            instruction,
            IRExpression.BinaryOperation.NotEqual);
    }

    private void BuildGE(IRProgram program, Instruction instruction)
    {
        BuildComparison(
            program,
            instruction,
            IRExpression.BinaryOperation.GreaterEqual);
    }

    private void BuildLt(IRProgram program, Instruction instruction)
    {
        BuildComparison(
            program,
            instruction,
            IRExpression.BinaryOperation.LessThan);
    }

    private void BuildIlt(IRProgram program, Instruction instruction)
    {
        BuildIntComparison(
            program,
            instruction,
            IRExpression.BinaryOperation.LessThan);
    }

    private void BuildIge(IRProgram program, Instruction instruction)
    {
        BuildIntComparison(
            program,
            instruction,
            IRExpression.BinaryOperation.GreaterEqual);
    }

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
}