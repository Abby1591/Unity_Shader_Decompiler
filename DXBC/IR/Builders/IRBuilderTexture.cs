using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildSample(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),

                Expression = new IRExpression.TextureSampleExpression
                {
                    Resource = BuildRegister(instruction.Operands[2]),
                    Sampler = BuildRegister(instruction.Operands[3]),
                    Coordinates = BuildExpression(instruction.Operands[1])
                }
            });
    }

    private void BuildSampleLevel(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),

                Expression =
                    new IRExpression.TextureSampleLevelExpression
                    {
                        Resource = BuildRegister(instruction.Operands[2]),
                        Sampler = BuildRegister(instruction.Operands[3]),
                        Coordinates = BuildExpression(instruction.Operands[1]),
                        Level = BuildExpression(instruction.Operands[4])
                    }
            });
    }
}