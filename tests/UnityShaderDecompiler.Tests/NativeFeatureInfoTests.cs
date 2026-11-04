using System;
using System.Buffers.Binary;
using Parser;
using Parser.DXBC;

namespace UnityShaderDecompiler.Tests;

public class NativeFeatureInfoTests
{
    [Fact]
    public void LegacyStatisticsFieldsRemainAvailableWithAnExplicitAvailabilityFlag()
    {
        using MemoryStream stream = new MemoryStream(BitConverter.GetBytes(1UL));
        using BinaryReader reader = new BinaryReader(stream);
        Parser.DXBC.Chunks.Sfi0Chunk chunk = new Parser.DXBC.Chunks.Sfi0Chunk();
        chunk.Read(reader);
        Assert.Equal(1UL, chunk.FeatureFlags);
        Assert.False(chunk.HasLegacyStatistics);
        string[] fields =
        {
            "InputPrimitive", "OutputPrimitive", "MaxInputSignatureRegisterCount", "MaxOutputSignatureRegisterCount",
            "MaxInputPatchConstantSignatureRegisterCount", "MaxOutputPatchCount", "PatchConstantPrimitive",
            "CTemps", "CIndexableTemp", "CGsInstanceCount", "CControlPoints", "COutputControlPoints", "CTgsm",
            "CInputGsInstanceCount", "COutputs", "CInputs", "CPatchConst", "CNumThreadsX", "CNumThreadsY", "CNumThreadsZ",
            "CGsOutputTopology", "CInputPrimitive", "CMaxOutputVertices", "COutputTopology", "CMaxTemp", "CMaxOutputPatchCount",
            "CMaxGsInstanceCount", "CMaxIndexableTemp", "CMaxInputGsInstanceCount", "CMaxOutputs", "CMaxInputs", "CMaxPatchConst",
            "CMaxNumThreadsX", "CMaxNumThreadsY", "CMaxNumThreadsZ",
        };
        foreach (string field in fields)
            Assert.Equal(typeof(uint), typeof(Parser.DXBC.Chunks.Sfi0Chunk).GetField(field)?.FieldType);
    }

    [Fact]
    [Trait("Category", "D3D")]
    public void FeatureFlagsMatchTheNativeCompilersEightBytePayload()
    {
        if (!OperatingSystem.IsWindows()) return;

        const string source = "float main(float x : TEXCOORD) : SV_Target "
            + "{ double value = (double)x; return (float)(value * value); }";
        byte[] bytes = RecompileVerify.CompileHlsl(source, "main", "ps_5_0");
        DxbcFile compiled = new();
        compiled.Load(bytes);
        DxbcChunk featureInfo = Assert.Single(compiled.Chunks, chunk => chunk.Name.ToString() == "SFI0");
        Assert.Equal(8, featureInfo.Data.Length);
        Assert.Equal(1UL, BinaryPrimitives.ReadUInt64LittleEndian(featureInfo.Data));
        Assert.NotNull(compiled.ShaderInfo);
        Assert.Equal(1UL, compiled.ShaderInfo.FeatureFlags);
    }
}
