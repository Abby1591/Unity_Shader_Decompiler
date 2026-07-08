using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildSincos(IRProgram program, Instruction instruction)
    {
        // Destination 0 = sine
        if (instruction.Operands[0].RegisterType != RegisterType.Null)
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
                        Name = "sin",
                        Arguments =
                        {
                            BuildExpression(instruction.Operands[2])
                        }
                    }
                });
        }

        // Destination 1 = cosine
        if (instruction.Operands[1].RegisterType != RegisterType.Null)
        {
            var destination = BuildRegister(instruction.Operands[1]);
            destination.Type = IRValueType.Float;
            SetRegisterType(destination);
            
            program.Statements.Add(
                new IRStatement.IRAssignment
                {
                    Destination = destination,
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
}