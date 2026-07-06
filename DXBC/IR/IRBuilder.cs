using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public class IRBuilder
{
    public IRProgram Build(ShdrParser parser)
    {
        IRProgram program = new();

        foreach (Parser.DXBC.Instructions.Instruction instruction in parser.Instructions)
        {
            ConvertInstruction(program, instruction);
        }

        return program;
    }
    
    private void ConvertInstruction(IRProgram program, Instruction instruction)
    {
        switch (instruction.Opcode)
        {
            case Opcode.Mov:

                program.Statements.Add(
                    new IRStatement.IRAssignment
                    {
                        Destination = instruction.Operands[0],
                        Expression = ConvertOperand(instruction.Operands[1])
                    });

                break;
            
            case Opcode.Add:

                program.Statements.Add(
                    new IRStatement.IRAssignment
                    {
                        Destination = instruction.Operands[0],

                        Expression =
                            new IRExpression.BinaryExpression
                            {
                                Operation = IRExpression.BinaryOperation.Add,
                                Left = ConvertOperand(instruction.Operands[1]),
                                Right = ConvertOperand(instruction.Operands[2])
                            }
                    });

                break;
            
            case Opcode.Mul:

                program.Statements.Add(
                    new IRStatement.IRAssignment
                    {
                        Destination = instruction.Operands[0],

                        Expression =
                            new IRExpression.BinaryExpression
                            {
                                Operation = IRExpression.BinaryOperation.Multiply,
                                Left = ConvertOperand(instruction.Operands[1]),
                                Right = ConvertOperand(instruction.Operands[2])
                            }
                    });

                break;
        }
    }
    
    private IRExpression ConvertOperand(Operand operand)
    {
        if (operand.RegisterType == RegisterType.Immediate32)
        {
            return new IRExpression.ConstantExpression
            {
                Values = operand.Immediate32Values
            };
        }

        return new IRExpression.RegisterExpression
        {
            Operand = operand
        };
    }
}