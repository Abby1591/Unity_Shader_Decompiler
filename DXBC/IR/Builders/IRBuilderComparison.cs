using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ============================================================
    // Float comparisons
    // ============================================================

    private void BuildEq(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.Equal, BuildExpression);

    private void BuildNe(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.NotEqual, BuildExpression);

    private void BuildGE(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.GreaterEqual, BuildExpression);

    private void BuildLt(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.LessThan, BuildExpression);

    // ============================================================
    // Signed integer comparisons
    // ============================================================

    private void BuildIeq(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.Equal, BuildIntExpression);

    private void BuildIne(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.NotEqual, BuildIntExpression);

    private void BuildIge(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.GreaterEqual, BuildIntExpression);

    private void BuildIlt(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.LessThan, BuildIntExpression);

    // ============================================================
    // Unsigned integer comparisons
    // ============================================================

    private void BuildUge(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.GreaterEqual, BuildUIntExpression);

    private void BuildUlt(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.LessThan, BuildUIntExpression);

    // ============================================================
    // Le / gt (float)
    // ============================================================
    // Not real SM4 opcodes — SM4 only has ge/lt; le/gt are synthesized by
    // swapping the operand order around ge/lt: a<=b == b>=a, a>b == b<a.

    private void BuildLe(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.GreaterEqual, BuildExpression, swap: true);

    private void BuildGt(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.LessThan, BuildExpression, swap: true);

    // ============================================================
    // Ugt / ule (unsigned)
    // ============================================================

    private void BuildUgt(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.LessThan, BuildUIntExpression, swap: true);

    private void BuildUle(IRProgram program, Instruction instruction) =>
        BuildComparison(program, instruction, IRExpression.BinaryOperation.GreaterEqual, BuildUIntExpression, swap: true);

    // ============================================================
    // Derivatives
    // ============================================================

    private void BuildDerivRtx(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.DerivativeX);
    private void BuildDerivRty(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.DerivativeY);
    private void BuildDerivRtxCoarse(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.DerivativeXCoarse);
    private void BuildDerivRtxFine(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.DerivativeXFine);
    private void BuildDerivRtyCoarse(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.DerivativeYCoarse);
    private void BuildDerivRtyFine(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.DerivativeYFine);

    // ============================================================
    // Boolean reductions
    // ============================================================

    private void BuildAny(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Any);
    private void BuildAll(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.All);
}