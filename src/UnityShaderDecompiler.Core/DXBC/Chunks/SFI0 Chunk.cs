namespace Parser.DXBC.Chunks;

// D3D11 "SFI0" ShaderInfo0 chunk. Layout matches the well-known
// reverse-engineered d3dcompiler format (SharpDX / Wine / meson sfi0). It
// carries the thread-group sizes (cNumThreads) that the STAT chunk alone
// cannot, and the temp register count cTemps. Shader parser spec §8 lists
// cTemps/cNumThreads as the survive-able shader-info fields.
public class Sfi0Chunk
{
    public uint InputPrimitive;
    public uint OutputPrimitive;
    public uint MaxInputSignatureRegisterCount;
    public uint MaxOutputSignatureRegisterCount;
    public uint MaxInputPatchConstantSignatureRegisterCount;
    public uint MaxOutputPatchCount;
    public uint PatchConstantPrimitive;
    public uint CTemps;                  // temp register count (see spec §8 table)
    public uint CIndexableTemp;
    public uint CGsInstanceCount;
    public uint CControlPoints;
    public uint COutputControlPoints;
    public uint CTgsm;
    public uint CInputGsInstanceCount;
    public uint COutputs;
    public uint CInputs;
    public uint CPatchConst;
    public uint CNumThreadsX;            // thread-group size X
    public uint CNumThreadsY;            // thread-group size Y
    public uint CNumThreadsZ;            // thread-group size Z
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
        InputPrimitive = reader.ReadUInt32();
        OutputPrimitive = reader.ReadUInt32();
        MaxInputSignatureRegisterCount = reader.ReadUInt32();
        MaxOutputSignatureRegisterCount = reader.ReadUInt32();
        MaxInputPatchConstantSignatureRegisterCount = reader.ReadUInt32();
        MaxOutputPatchCount = reader.ReadUInt32();
        PatchConstantPrimitive = reader.ReadUInt32();
        CTemps = reader.ReadUInt32();
        CIndexableTemp = reader.ReadUInt32();
        CGsInstanceCount = reader.ReadUInt32();
        CControlPoints = reader.ReadUInt32();
        COutputControlPoints = reader.ReadUInt32();
        CTgsm = reader.ReadUInt32();
        CInputGsInstanceCount = reader.ReadUInt32();
        COutputs = reader.ReadUInt32();
        CInputs = reader.ReadUInt32();
        CPatchConst = reader.ReadUInt32();
        CNumThreadsX = reader.ReadUInt32();
        CNumThreadsY = reader.ReadUInt32();
        CNumThreadsZ = reader.ReadUInt32();
        CGsOutputTopology = reader.ReadUInt32();
        CInputPrimitive = reader.ReadUInt32();
        CMaxOutputVertices = reader.ReadUInt32();
        COutputTopology = reader.ReadUInt32();
        CMaxTemp = reader.ReadUInt32();
        CMaxOutputPatchCount = reader.ReadUInt32();
        CMaxGsInstanceCount = reader.ReadUInt32();
        CMaxIndexableTemp = reader.ReadUInt32();
        CMaxInputGsInstanceCount = reader.ReadUInt32();
        CMaxOutputs = reader.ReadUInt32();
        CMaxInputs = reader.ReadUInt32();
        CMaxPatchConst = reader.ReadUInt32();
        CMaxNumThreadsX = reader.ReadUInt32();
        CMaxNumThreadsY = reader.ReadUInt32();
        CMaxNumThreadsZ = reader.ReadUInt32();
    }
}