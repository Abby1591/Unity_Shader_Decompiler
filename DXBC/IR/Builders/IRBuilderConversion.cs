using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildFtoi(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);
        destination.Type = IRValueType.Int;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
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

    private void BuildFtou(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);
        destination.Type = IRValueType.UInt;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression = new IRExpression.IntrinsicExpression
                {
                    Name = "uint",
                    Arguments =
                    {
                        BuildExpression(instruction.Operands[1])
                    }
                }
            });
    }

    private void BuildItof(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);
        destination.Type = IRValueType.Float;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression = new IRExpression.IntrinsicExpression
                {
                    Name = "float",
                    Arguments =
                    {
                        BuildIntExpression(instruction.Operands[1])
                    }
                }
            });
    }

    private void BuildUtof(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);
        destination.Type = IRValueType.Float;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression = new IRExpression.IntrinsicExpression
                {
                    Name = "float",
                    Arguments =
                    {
                        BuildUIntExpression(instruction.Operands[1])
                    }
                }
            });
    }

    private void BuildRoundNI(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);
        destination.Type = IRValueType.Float;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
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