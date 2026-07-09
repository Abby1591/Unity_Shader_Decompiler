using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ===================== sincos =====================

    private void BuildSincos(IRProgram program, Instruction instruction)
    {
        // Destination 0 = sine
        if (instruction.Operands[0].RegisterType != RegisterType.Null)
        {
            var destination = BuildRegister(instruction.Operands[0]);

            IRExpression expression =
                new IRExpression.IntrinsicExpression
                {
                    Name = "sin",
                    Arguments = { BuildExpression(instruction.Operands[2]) }
                };

            AddAssignment(program, destination, expression);
        }

        // Destination 1 = cosine
        if (instruction.Operands[1].RegisterType != RegisterType.Null)
        {
            var destination = BuildRegister(instruction.Operands[1]);

            IRExpression expression =
                new IRExpression.IntrinsicExpression
                {
                    Name = "cos",
                    Arguments = { BuildExpression(instruction.Operands[2]) }
                };

            AddAssignment(program, destination, expression);
        }
    }
}