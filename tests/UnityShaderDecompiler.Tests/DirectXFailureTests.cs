using System.IO;
using AssetStudio;
using Parser;

namespace UnityShaderDecompiler.Tests;

public class DirectXFailureTests
{
    [Theory]
    [InlineData(ShaderGpuProgramType.DX11VertexSM40, true)]
    [InlineData(ShaderGpuProgramType.DX11PixelSM50, true)]
    [InlineData(ShaderGpuProgramType.DX11VertexSM40, false)]
    [InlineData(ShaderGpuProgramType.DX11PixelSM50, false)]
    public void MalformedDirectXProgramHonorsExplicitFailurePolicy(ShaderGpuProgramType stage, bool failOnError)
    {
        using TempDirectory folder = new();
        using MemoryStream payload = new();
        using (BinaryWriter writer = new(payload, System.Text.Encoding.UTF8, leaveOpen: true))
        {
            writer.Write(202012090);
            writer.Write((int)stage);
            writer.Write(new byte[16]);
            writer.Write(0); // keyword count
            writer.Write(4); // deliberately incomplete shader code
            writer.Write("DXBC"u8);
        }
        using MemoryStream blob = new();
        using (BinaryWriter writer = new(blob, System.Text.Encoding.UTF8, leaveOpen: true))
        {
            writer.Write(1); // one subprogram, starting after the entry table
            writer.Write(16);
            writer.Write((int)payload.Length);
            writer.Write(0);
            writer.Write(payload.ToArray());
        }
        File.WriteAllBytes(Path.Combine(folder.Path, "blob.bin"), blob.ToArray());
        File.WriteAllText(Path.Combine(folder.Path, "metadata.json"),
            "{\"name\":\"Test/InvalidDxbc\",\"subShaders\":[]}");
        string output = Path.Combine(folder.Path, "generated");

        if (!failOnError)
        {
            Assert.False(new DecompileOptions().FailOnError);
            Decompiler.DecompileFolder(folder.Path, new DecompileOptions { Verbose = false, OutRoot = output });
            Assert.Single(Directory.GetFiles(output, "*.shader"));
            return;
        }

        InvalidDataException error = Assert.Throws<InvalidDataException>(() =>
            Decompiler.DecompileFolder(folder.Path, new DecompileOptions { FailOnError = true, Verbose = false, OutRoot = output }));

        Assert.Contains("DirectX subprogram 0", error.Message);
        Assert.Contains(stage.ToString(), error.Message);
        Assert.NotNull(error.InnerException);
        Assert.Empty(Directory.GetFiles(output, "*.shader"));
    }
}
