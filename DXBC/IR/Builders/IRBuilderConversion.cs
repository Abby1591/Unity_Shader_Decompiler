using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildFtoi(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),
                Expression = new IRExpression.IntrinsicExpression
                {
                    Name = "int",
                    Arguments =
                    {
                        BuildExpression(instruction.Operands[1])
                    }
                }
            });
    }

    private void BuildRoundNI(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),
                Expression = new IRExpression.IntrinsicExpression
                {
                    Name = "floor",
                    Arguments =
                    {
                        BuildExpression(instruction.Operands[1])
                    }
                }
            });
    }
}