using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ===================== conversions =====================

    private void BuildFtoi(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "int",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildFtou(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "uint",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildItof(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "float",
                Arguments = { BuildIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildUtof(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "float",
                Arguments = { BuildUIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== half-precision packing =====================

    private void BuildF16ToF32(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "f16tof32");
    private void BuildF32ToF16(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "f32tof16");

    // ===================== bitcasts =====================
    // Reinterpret the bit pattern without converting the value (HLSL asfloat/asint/asuint)

    private void BuildBitcastFloat(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "asfloat");
    private void BuildBitcastInt(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "asint");
    private void BuildBitcastUInt(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "asuint");

    // ===================== bool conversions =====================

    private void BuildItoBool(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "bool");
    private void BuildBoolToInt(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "int");
}