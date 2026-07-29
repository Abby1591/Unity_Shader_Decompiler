namespace Parser.DXBC.Chunks;

// D3D11_SHADER_STATS-style layout (SM4/SM5). Field order matches the well-known
// reverse-engineered layout used by SharpDX / SlimDX / Wine's d3dcompiler_43/47.
public class StatChunk
{
    public uint InstructionCount;
    public uint TempRegisterCount;
    public uint DefCount;
    public uint DclCount;
    public uint TextureNormalInstructions;
    public uint TextureLoadInstructions;
    public uint TextureCompInstructions;
    public uint TextureBiasInstructions;
    public uint TextureGradientInstructions;
    public uint FloatInstructionCount;
    public uint IntInstructionCount;
    public uint UintInstructionCount;
    public uint StaticFlowControlCount;
    public uint DynamicFlowControlCount;
    public uint MacroInstructionCount;
    public uint TempArrayCount;
    public uint ArrayInstructionCount;
    public uint CutInstructionCount;
    public uint EmitInstructionCount;
    public uint TextureBiasInstructions2; // reserved / padding depending on version
    public uint MovInstructionCount;
    public uint MovcInstructionCount;
    public uint ConversionInstructionCount;
    public uint BitwiseInstructionCount;
    public uint ResourceDim;
    public uint SampleCount;
    public uint SamplerFeedbackInstructionCount;

    // Raw fallback: every uint present in the chunk, in order, for fields the
    // named layout above doesn't (yet) account for across SM versions.
    public List<uint> RawFields { get; } = new();

    public void Read(BinaryReader reader)
    {
        long len = reader.BaseStream.Length;
        while (reader.BaseStream.Position + 4 <= len)
            RawFields.Add(reader.ReadUInt32());

        int i = 0;
        uint Next() => i < RawFields.Count ? RawFields[i++] : 0;

        InstructionCount = Next();
        TempRegisterCount = Next();
        DefCount = Next();
        DclCount = Next();
        TextureNormalInstructions = Next();
        TextureLoadInstructions = Next();
        TextureCompInstructions = Next();
        TextureBiasInstructions = Next();
        TextureGradientInstructions = Next();
        FloatInstructionCount = Next();
        IntInstructionCount = Next();
        UintInstructionCount = Next();
        StaticFlowControlCount = Next();
        DynamicFlowControlCount = Next();
        MacroInstructionCount = Next();
        TempArrayCount = Next();
        ArrayInstructionCount = Next();
        CutInstructionCount = Next();
        EmitInstructionCount = Next();
        TextureBiasInstructions2 = Next();
        MovInstructionCount = Next();
        MovcInstructionCount = Next();
        ConversionInstructionCount = Next();
        BitwiseInstructionCount = Next();
        ResourceDim = Next();
        SampleCount = Next();
        SamplerFeedbackInstructionCount = Next();
    }
}