using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ============================================================
    // Sincos
    // ============================================================

    private void BuildSincos(IRProgram program, Instruction instruction)
    {
        EmitIfNotNull(program, instruction.Operands[0], new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.Sin,
            Arguments = { BuildExpression(instruction.Operands[2]) }
        });

        EmitIfNotNull(program, instruction.Operands[1], new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.Cos,
            Arguments = { BuildExpression(instruction.Operands[2]) }
        });
    }
}