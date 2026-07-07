using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildSincos(IRProgram program, Instruction instruction)
    {
        // dstSin
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),
                Expression = new IRExpression.IntrinsicExpression
                {
                    Name = "sin",
                    Arguments =
                    {
                        BuildExpression(instruction.Operands[2])
                    }
                }
            });

        // dstCos
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[1]),
                Expression = new IRExpression.IntrinsicExpression
                {
                    Name = "cos",
                    Arguments =
                    {
                        BuildExpression(instruction.Operands[2])
                    }
                }
            });
    }
}