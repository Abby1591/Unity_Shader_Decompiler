using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

// NOTE: Texture-related IRExpression types (TextureLoadExpression,
// TextureGatherExpression, TextureLodExpression, ResourceInfoExpression, etc.)
// are assumed to mirror the existing TextureSampleExpression /
// TextureSampleLevelExpression naming convention. Adjust field/type names
// here if the actual IR model differs.
public partial class IRBuilder
{
    // ===================== load =====================

    private void BuildLd(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureLoadExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Coordinates = BuildExpression(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildLdMS(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureLoadExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Coordinates = BuildExpression(instruction.Operands[1]),
                SampleIndex = BuildExpression(instruction.Operands[3])
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== sample =====================

    private void BuildSample(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureSampleExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildSampleLevel(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureSampleLevelExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1]),
                Level = BuildExpression(instruction.Operands[4])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildSampleD(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureSampleGradExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1]),
                DDX = BuildExpression(instruction.Operands[4]),
                DDY = BuildExpression(instruction.Operands[5])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildSampleB(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureSampleBiasExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1]),
                Bias = BuildExpression(instruction.Operands[4])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildSampleC(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureSampleCompareExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1]),
                CompareValue = BuildExpression(instruction.Operands[4])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildSampleCLz(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureSampleCompareLevelZeroExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1]),
                CompareValue = BuildExpression(instruction.Operands[4])
            };

        AddAssignment(program, destination, expression);
    }

    // sample_info: returns number of samples in the resource
    private void BuildSampleInfo(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.SampleInfoExpression
            {
                Resource = BuildRegister(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== gather =====================

    private void BuildGather4(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureGatherExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildGather4C(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureGatherCompareExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1]),
                CompareValue = BuildExpression(instruction.Operands[4])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildGather4Po(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureGatherOffsetExpression
            {
                Resource = BuildRegister(instruction.Operands[3]),
                Sampler = BuildRegister(instruction.Operands[4]),
                Coordinates = BuildExpression(instruction.Operands[1]),
                Offset = BuildExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildGather4PoC(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureGatherOffsetCompareExpression
            {
                Resource = BuildRegister(instruction.Operands[3]),
                Sampler = BuildRegister(instruction.Operands[4]),
                Coordinates = BuildExpression(instruction.Operands[1]),
                Offset = BuildExpression(instruction.Operands[2]),
                CompareValue = BuildExpression(instruction.Operands[5])
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== misc queries =====================

    private void BuildLod(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.TextureLodExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                Sampler = BuildRegister(instruction.Operands[3]),
                Coordinates = BuildExpression(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildResInfo(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.ResourceInfoExpression
            {
                Resource = BuildRegister(instruction.Operands[2]),
                MipLevel = BuildExpression(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }
}