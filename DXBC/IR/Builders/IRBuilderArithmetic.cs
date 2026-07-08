using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildMov(IRProgram program, Instruction instruction)
    {
        IRRegister destination = BuildRegister(instruction.Operands[0]);

        destination.Type = instruction.Operands[1].RegisterType == RegisterType.Immediate32
            ? IRValueType.Float
            : BuildRegister(instruction.Operands[1]).Type;
        
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression = BuildExpression(instruction.Operands[1])
            });
    }

    private void BuildAdd(IRProgram program, Instruction instruction)
    {
        IRRegister destination = BuildRegister(instruction.Operands[0]);
        destination.Type = IRValueType.Float;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression =
                    new IRExpression.BinaryExpression
                    {
                        Operation = IRExpression.BinaryOperation.Add,
                        Left = BuildExpression(instruction.Operands[1]),
                        Right = BuildExpression(instruction.Operands[2])
                    }
            });
    }

    private void BuildIAdd(IRProgram program, Instruction instruction)
    {
        IRRegister destination = BuildRegister(instruction.Operands[0]);
        destination.Type = IRValueType.Int;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression =
                    new IRExpression.BinaryExpression
                    {
                        Operation = IRExpression.BinaryOperation.Add,
                        Left = BuildIntExpression(instruction.Operands[1]),
                        Right = BuildIntExpression(instruction.Operands[2])
                    }
            });
    }

    private void BuildMul(IRProgram program, Instruction instruction)
    {
        IRRegister destination = BuildRegister(instruction.Operands[0]);
        destination.Type = IRValueType.Float;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression =
                    new IRExpression.BinaryExpression
                    {
                        Operation = IRExpression.BinaryOperation.Multiply,
                        Left = BuildExpression(instruction.Operands[1]),
                        Right = BuildExpression(instruction.Operands[2])
                    }
            });
    }

    private void BuildDiv(IRProgram program, Instruction instruction)
    {
        IRRegister destination = BuildRegister(instruction.Operands[0]);
        destination.Type = IRValueType.Float;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression =
                    new IRExpression.BinaryExpression
                    {
                        Operation = IRExpression.BinaryOperation.Divide,
                        Left = BuildExpression(instruction.Operands[1]),
                        Right = BuildExpression(instruction.Operands[2])
                    }
            });
    }

    private void BuildMad(IRProgram program, Instruction instruction)
    {
        IRRegister destination = BuildRegister(instruction.Operands[0]);
        destination.Type = IRValueType.Float;SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,

                Expression =
                    new IRExpression.BinaryExpression
                    {
                        Operation = IRExpression.BinaryOperation.Add,

                        Left =
                            new IRExpression.BinaryExpression
                            {
                                Operation = IRExpression.BinaryOperation.Multiply,
                                Left = BuildExpression(instruction.Operands[1]),
                                Right = BuildExpression(instruction.Operands[2])
                            },

                        Right = BuildExpression(instruction.Operands[3])
                    }
            });
    }

    private void BuildMovC(IRProgram program, Instruction instruction)
    {
        IRRegister destination = BuildRegister(instruction.Operands[0]);

        // movc keeps the type of the values being selected
        destination.Type = BuildRegister(instruction.Operands[2]).Type;
        SetRegisterType(destination);

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,

                Expression =
                    new IRExpression.ConditionalExpression
                    {
                        Condition = BuildExpression(instruction.Operands[1]),
                        TrueExpression = BuildExpression(instruction.Operands[2]),
                        FalseExpression = BuildExpression(instruction.Operands[3])
                    }
            });
    }
}