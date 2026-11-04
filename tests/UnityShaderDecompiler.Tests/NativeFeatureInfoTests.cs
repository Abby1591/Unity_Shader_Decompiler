using System;
using System.Buffers.Binary;
using Parser;
using Parser.DXBC;

namespace UnityShaderDecompiler.Tests;

public class NativeFeatureInfoTests
{
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
