using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ============================================================
    // Conversions
    // ============================================================

    private void BuildFtoi(IRProgram program, Instruction instruction) => BuildCast(program, instruction, IRExpression.IRIntrinsic.CastInt, BuildExpression);
    private void BuildFtou(IRProgram program, Instruction instruction) => BuildCast(program, instruction, IRExpression.IRIntrinsic.CastUInt, BuildExpression);
    private void BuildItof(IRProgram program, Instruction instruction) => BuildCast(program, instruction, IRExpression.IRIntrinsic.CastFloat, BuildIntExpression);
    private void BuildUtof(IRProgram program, Instruction instruction) => BuildCast(program, instruction, IRExpression.IRIntrinsic.CastFloat, BuildUIntExpression);

    // ============================================================
    // Half-precision packing
    // ============================================================

    private void BuildF16ToF32(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.F16ToF32);
    private void BuildF32ToF16(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.F32ToF16);

    // ============================================================
    // Bitcasts
    // ============================================================
    // Reinterpret the bit pattern without converting the value (HLSL asfloat/asint/asuint)

    private void BuildBitcastFloat(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.AsFloat);
    private void BuildBitcastInt(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.AsInt);
    private void BuildBitcastUInt(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.AsUInt);

    // ============================================================
    // Bool conversions
    // ============================================================

    private void BuildItoBool(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.CastBool);
    private void BuildBoolToInt(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.CastInt);
}