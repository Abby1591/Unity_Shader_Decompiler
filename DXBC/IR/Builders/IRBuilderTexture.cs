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

    // ===================== raw / structured / UAV loads =====================
    // Atomic ops (atomic_iadd, atomic_and, ..., uav_atomic*) are intentionally
    // not included — large, mostly-compute-shader-only category.

    private void BuildLdUAV(IRProgram program, Instruction instruction)
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

    private void BuildLdRaw(IRProgram program, Instruction instruction)
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

    private void BuildLdStructured(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        // operand 1 = element index, operand 2 = byte offset within element
        IRExpression address =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        IRExpression expression =
            new IRExpression.TextureLoadExpression
            {
                Resource = BuildRegister(instruction.Operands[3]),
                Coordinates = address
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== raw / structured stores =====================

    // store_raw dest[address] = value
    private void BuildStoreRaw(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRMemoryStore
            {
                Resource = BuildRegister(instruction.Operands[0]),
                Address = BuildUIntExpression(instruction.Operands[1]),
                Value = BuildExpression(instruction.Operands[2])
            });
    }

    // store_structured dest[element, offset] = value
    private void BuildStoreStructured(IRProgram program, Instruction instruction)
    {
        IRExpression address =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        program.Statements.Add(
            new IRStatement.IRMemoryStore
            {
                Resource = BuildRegister(instruction.Operands[0]),
                Address = address,
                Value = BuildExpression(instruction.Operands[3])
            });
    }

    // ===================== misc queries =====================

    private void BuildSamplePos(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "GetSamplePosition",
                Arguments =
                {
                    BuildExpression(instruction.Operands[1]),
                    BuildUIntExpression(instruction.Operands[2])
                }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildSampleIndex(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "sampleindex",
                Arguments = { }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildCheckAccessFullyMapped(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "CheckAccessFullyMapped",
                Arguments = { BuildUIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // bufinfo: element count / stride of a raw or structured buffer
    private void BuildBufInfo(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.ResourceInfoExpression
            {
                Resource = BuildRegister(instruction.Operands[1]),
                MipLevel = new IRExpression.ConstantExpression
                {
                    Kind = IRExpression.ConstantExpression.ConstantKind.UInt,
                    RawValues = new uint[] { 0 }
                }
            };

        AddAssignment(program, destination, expression);
    }
}