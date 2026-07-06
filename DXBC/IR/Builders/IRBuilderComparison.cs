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

    private void BuildComparison(
        IRProgram program,
        Instruction instruction,
        IRExpression.BinaryOperation operation)
    {
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),
                Expression =
                    new IRExpression.BinaryExpression
                    {
                        Operation = operation,
                        Left = BuildExpression(instruction.Operands[1]),
                        Right = BuildExpression(instruction.Operands[2])
                    }
            });
    }
}