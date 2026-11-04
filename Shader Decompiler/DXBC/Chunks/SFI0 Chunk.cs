namespace Parser.DXBC.Chunks;

// SFI0 stores the shader's required feature flags as one 64-bit bitmask.
public class Sfi0Chunk
{
    public ulong FeatureFlags { get; private set; }

    /// <summary>False: SFI0 has feature flags, not shader statistics.</summary>
    public bool HasLegacyStatistics => false;

    // Retained for source/binary compatibility. These fields are never populated
    // by SFI0; check HasLegacyStatistics before using them as statistics.
    public uint InputPrimitive;
    public uint OutputPrimitive;
    public uint MaxInputSignatureRegisterCount;
    public uint MaxOutputSignatureRegisterCount;
    public uint MaxInputPatchConstantSignatureRegisterCount;
    public uint MaxOutputPatchCount;
    public uint PatchConstantPrimitive;
    public uint CTemps;
    public uint CIndexableTemp;
    public uint CGsInstanceCount;
    public uint CControlPoints;
    public uint COutputControlPoints;
    public uint CTgsm;
    public uint CInputGsInstanceCount;
    public uint COutputs;
    public uint CInputs;
    public uint CPatchConst;
    public uint CNumThreadsX;
    public uint CNumThreadsY;
    public uint CNumThreadsZ;
    public uint CGsOutputTopology;
    public uint CInputPrimitive;
    public uint CMaxOutputVertices;
    public uint COutputTopology;
    public uint CMaxTemp;
    public uint CMaxOutputPatchCount;
    public uint CMaxGsInstanceCount;
    public uint CMaxIndexableTemp;
    public uint CMaxInputGsInstanceCount;
    public uint CMaxOutputs;
    public uint CMaxInputs;
    public uint CMaxPatchConst;
    public uint CMaxNumThreadsX;
    public uint CMaxNumThreadsY;
    public uint CMaxNumThreadsZ;

    public void Read(BinaryReader reader)
    {
        if (reader.BaseStream.Length - reader.BaseStream.Position != sizeof(ulong))
            throw new InvalidDataException("SFI0 chunk must contain exactly 8 bytes of feature flags.");

        FeatureFlags = reader.ReadUInt64();
    }
}