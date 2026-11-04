using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // All resource-read instructions (sample*, ld*, gather4*, lod, resinfo,
    // bufinfo, sample_info, sample_pos, check_access_fully_mapped) go through
    // BuildTextureOp so there's exactly one place that builds a
    // TextureOperationExpression. Writes (store_raw/store_structured/UAV
    // writes) are statements, not expressions — see BuildStoreRaw/BuildStoreStructured.
//
    // Static-offset variants (sample_po/sample_po_c and friends) reuse the same
    // builders as their non-offset counterparts — offset is just another operand.
    // Resource-array addressing (Texture2DArray, TextureCubeArray, etc.) is
    // handled by ResourceDimension on the declaration, not by the read
    // instruction itself — an array index is simply an extra component of
    // Coordinates, same as any other DXBC texture coordinate.
    private void BuildTextureOp(
        IRProgram program,
        Instruction instruction,
        IRExpression.TextureOperation operation,
        IRRegister destination,
        IRRegister resource,
        IRRegister? sampler = null,
        IRExpression? coordinates = null,
        IRExpression? offset = null,
        IRExpression? lod = null,
        IRExpression? bias = null,
        IRExpression? compareValue = null,
        IRExpression? gradX = null,
        IRExpression? gradY = null,
        IRExpression? sampleIndex = null)
    {
        IRExpression expression =
            new IRExpression.TextureOperationExpression
            {
                Operation = operation,
                Resource = resource,
                Sampler = sampler,
                Coordinates = coordinates,
                Offset = offset,
                LOD = lod,
                Bias = bias,
                CompareValue = compareValue,
                GradX = gradX,
                GradY = gradY,
                SampleIndex = sampleIndex
            };

        AddAssignment(program, destination, expression);
    }

    // ============================================================
    // Load
    // ============================================================

    private void BuildLd(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.Load,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            coordinates: BuildExpression(instruction.Operands[1]));
    }

    private void BuildLdMS(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.Load,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            coordinates: BuildExpression(instruction.Operands[1]),
            sampleIndex: BuildExpression(instruction.Operands[3]));
    }

    // ld_uav / ld_raw: resolve to the same shape as a plain Load
    private void BuildLdUAV(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.Load,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            coordinates: BuildExpression(instruction.Operands[1]));
    }

    private void BuildLdRaw(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.Load,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            coordinates: BuildUIntExpression(instruction.Operands[1]));
    }

    // ld_structured: operand 1 = element index, operand 2 = byte offset within element
    private void BuildLdStructured(IRProgram program, Instruction instruction)
    {
        IRExpression address =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.Load,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[3]),
            coordinates: address);
    }

    // ============================================================
    // Stores (raw / structured / UAV)
    // ============================================================

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

    // store_uav (RWTexture/RWBuffer write) — same shape, coordinates instead of a raw byte address
    private void BuildStoreUAV(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRMemoryStore
            {
                Resource = BuildRegister(instruction.Operands[0]),
                Address = BuildExpression(instruction.Operands[1]),
                Value = BuildExpression(instruction.Operands[2])
            });
    }

    // ============================================================
    // Sample
    // ============================================================

    private void BuildSample(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.Sample,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            sampler: BuildRegister(instruction.Operands[3]),
            coordinates: BuildExpression(instruction.Operands[1]));
    }

    // sample_po: sample with a static (immediate) texel offset baked into the instruction
    private void BuildSamplePo(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.Sample,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[3]),
            sampler: BuildRegister(instruction.Operands[4]),
            coordinates: BuildExpression(instruction.Operands[1]),
            offset: BuildIntExpression(instruction.Operands[2]));
    }

    private void BuildSampleLevel(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.SampleLevel,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            sampler: BuildRegister(instruction.Operands[3]),
            coordinates: BuildExpression(instruction.Operands[1]),
            lod: BuildExpression(instruction.Operands[4]));
    }

    private void BuildSampleD(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.SampleGrad,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            sampler: BuildRegister(instruction.Operands[3]),
            coordinates: BuildExpression(instruction.Operands[1]),
            gradX: BuildExpression(instruction.Operands[4]),
            gradY: BuildExpression(instruction.Operands[5]));
    }

    private void BuildSampleB(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.SampleBias,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            sampler: BuildRegister(instruction.Operands[3]),
            coordinates: BuildExpression(instruction.Operands[1]),
            bias: BuildExpression(instruction.Operands[4]));
    }

    private void BuildSampleC(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.SampleCompare,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            sampler: BuildRegister(instruction.Operands[3]),
            coordinates: BuildExpression(instruction.Operands[1]),
            compareValue: BuildExpression(instruction.Operands[4]));
    }

    // sample_po_c: comparison sample with a static texel offset
    private void BuildSamplePoC(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.SampleCompare,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[3]),
            sampler: BuildRegister(instruction.Operands[4]),
            coordinates: BuildExpression(instruction.Operands[1]),
            offset: BuildIntExpression(instruction.Operands[2]),
            compareValue: BuildExpression(instruction.Operands[5]));
    }

    private void BuildSampleCLz(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.SampleCompareLevelZero,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            sampler: BuildRegister(instruction.Operands[3]),
            coordinates: BuildExpression(instruction.Operands[1]),
            compareValue: BuildExpression(instruction.Operands[4]));
    }

    // sample_info: returns number of samples in the resource
    private void BuildSampleInfo(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.SampleInfo,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[1]));
    }

    private void BuildSamplePos(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.SamplePos,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[1]),
            sampleIndex: BuildUIntExpression(instruction.Operands[2]));
    }

    private void BuildCheckAccessFullyMapped(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Intrinsic = IRExpression.IRIntrinsic.CheckAccessFullyMapped,
                Arguments = { BuildUIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // ============================================================
    // Gather
    // ============================================================

    private void BuildGather4(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.Gather,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            sampler: BuildRegister(instruction.Operands[3]),
            coordinates: BuildExpression(instruction.Operands[1]));
    }

    private void BuildGather4C(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.GatherCompare,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            sampler: BuildRegister(instruction.Operands[3]),
            coordinates: BuildExpression(instruction.Operands[1]),
            compareValue: BuildExpression(instruction.Operands[4]));
    }

    // gather4_po: gather with a dynamic (per-invocation, non-immediate) texel offset
    private void BuildGather4Po(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.Gather,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[3]),
            sampler: BuildRegister(instruction.Operands[4]),
            coordinates: BuildExpression(instruction.Operands[1]),
            offset: BuildExpression(instruction.Operands[2]));
    }

    private void BuildGather4PoC(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.GatherCompare,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[3]),
            sampler: BuildRegister(instruction.Operands[4]),
            coordinates: BuildExpression(instruction.Operands[1]),
            offset: BuildExpression(instruction.Operands[2]),
            compareValue: BuildExpression(instruction.Operands[5]));
    }

    // ============================================================
    // Misc queries
    // ============================================================

    private void BuildLod(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.Lod,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            sampler: BuildRegister(instruction.Operands[3]),
            coordinates: BuildExpression(instruction.Operands[1]));
    }

    private void BuildResInfo(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.ResInfo,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[2]),
            lod: BuildExpression(instruction.Operands[1]));
    }

    // bufinfo: element count / stride of a raw or structured buffer
    private void BuildBufInfo(IRProgram program, Instruction instruction)
    {
        BuildTextureOp(
            program, instruction, IRExpression.TextureOperation.BufInfo,
            destination: BuildRegister(instruction.Operands[0]),
            resource: BuildRegister(instruction.Operands[1]));
    }
}