using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildSample(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureSampleExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1])
            };

        destination.Type = expression.Type;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression = expression
            });
    }

    private void BuildSampleLevel(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureSampleLevelExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1]),
                Level = BuildExpression(instruction.Operands[4])
            };

        destination.Type = expression.Type;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression = expression
            });
    }
}