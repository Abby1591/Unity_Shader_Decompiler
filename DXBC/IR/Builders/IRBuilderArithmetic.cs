using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildMov(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),
                Expression = BuildExpression(instruction.Operands[1])
            });
    }

    private void BuildAdd(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),
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
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),
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
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),
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
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),
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
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),
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
        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = BuildRegister(instruction.Operands[0]),

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