using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildFtoi(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "int",
                Arguments =
                {
                    BuildExpression(instruction.Operands[1])
                }
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

    private void BuildFtou(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "uint",
                Arguments =
                {
                    BuildExpression(instruction.Operands[1])
                }
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

    private void BuildItof(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "float",
                Arguments =
                {
                    BuildIntExpression(instruction.Operands[1])
                }
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

    private void BuildUtof(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "float",
                Arguments =
                {
                    BuildUIntExpression(instruction.Operands[1])
                }
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

    private void BuildRoundNI(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "floor",
                Arguments =
                {
                    BuildExpression(instruction.Operands[1])
                }
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