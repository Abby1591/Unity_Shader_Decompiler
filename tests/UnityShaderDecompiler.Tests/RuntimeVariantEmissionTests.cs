using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using AssetStudio;
using UnityShaderDecompiler.Core;

namespace UnityShaderDecompiler.Tests;

// Covers runtime variant emission tests.
public sealed class RuntimeVariantEmissionTests
{
    // Verifies that default mode keeps log and continue for a failed serialized program.
    [Fact]
    [Trait("Category", "D3D")]
    public void DefaultModeKeepsLogAndContinueForAFailedSerializedProgram()
    {
        if (!OperatingSystem.IsWindows())
        {
            return;
        }
        using TempDirectory folder = new TempDirectory();
        List<(ShaderGpuProgramType Stage, byte[] Code)> programs = CompilePartialPrograms();
        File.WriteAllBytes(Path.Combine(folder.Path, "blob.bin"), BuildBlob(programs));
        File.WriteAllText(Path.Combine(folder.Path, "metadata.json"), JsonSerializer.Serialize(new
        {
            name = "Test/PartialInput",
            subShaders = new[] { new { passes = new[] { new
            {
                directXPrograms = new[]
                {
                    new { blobIndex = 0, stage = "Vertex", keywords = Array.Empty<string>(), keywordMask = Array.Empty<string>() },
                    new { blobIndex = 1, stage = "Fragment", keywords = Array.Empty<string>(), keywordMask = Array.Empty<string>() },
                },
            } } } },
        }));
        DecompilationResult result = Decompiler.DecompileFolder(folder.Path, new DecompileOptions { Verbose = false });
        Assert.Equal(1, Assert.Single(result.Subprograms).Index);
        Assert.Throws<InvalidDataException>(() => Decompiler.DecompileFolder(folder.Path,
            new DecompileOptions { RestoreKeywordVariants = true, Verbose = false }));
    }

    // Verifies that default mode retains geometry programs with serialized references.
    [Fact]
    [Trait("Category", "D3D")]
    public void DefaultModeRetainsGeometryProgramsWithSerializedReferences()
    {
        if (!OperatingSystem.IsWindows())
        {
            return;
        }
        using TempDirectory folder = new TempDirectory();
        const string varying = "struct V { float4 position:SV_POSITION; float marker:TEXCOORD0; }; ";
        List<(ShaderGpuProgramType Stage, byte[] Code)> programs = new List<(ShaderGpuProgramType, byte[])>
        {
            (ShaderGpuProgramType.DX11VertexSM40, UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile(varying
                + "V main(float4 p:POSITION) { V o; o.position=p; o.marker=p.x; return o; }", "main", "vs_4_0")),
            (ShaderGpuProgramType.DX11GeometrySM40, UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile(varying
                + "[maxvertexcount(1)] void main(point V input[1], inout PointStream<V> output) { output.Append(input[0]); }", "main", "gs_4_0")),
            (ShaderGpuProgramType.DX11PixelSM40, UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile(varying
                + "float4 main(V i):SV_Target { return i.marker; }", "main", "ps_4_0")),
        };
        File.WriteAllBytes(Path.Combine(folder.Path, "blob.bin"), BuildBlob(programs));
        File.WriteAllText(Path.Combine(folder.Path, "metadata.json"), JsonSerializer.Serialize(new
        {
            name = "Test/GeometryVariants",
            subShaders = new[] { new { passes = new[] { new
            {
                name = "Geometry", directXPrograms = new[]
                {
                    new { blobIndex = 0, stage = "Vertex", keywords = Array.Empty<string>(), keywordMask = Array.Empty<string>() },
                    new { blobIndex = 1, stage = "Geometry", keywords = Array.Empty<string>(), keywordMask = Array.Empty<string>() },
                    new { blobIndex = 2, stage = "Fragment", keywords = Array.Empty<string>(), keywordMask = Array.Empty<string>() },
                },
            } } } },
        }));
        DecompilationResult result = Decompiler.DecompileFolder(folder.Path,
            new DecompileOptions { Verbose = false, ReconstructSurfaceShaders = false });
        Assert.Equal(3, result.Subprograms.Count);
        Assert.NotNull(Assert.Single(result.Passes).GeometryFunction);
        Assert.NotNull(result.Passes[0].VertexFunction);
        Assert.NotNull(result.Passes[0].FragmentFunction);
    }

    // Verifies that native programs keep their passes and select by keywords.
    [Fact]
    [Trait("Category", "D3D")]
    public void NativeProgramsKeepTheirPassesAndSelectByKeywords()
    {
        if (!OperatingSystem.IsWindows())
        {
            return;
        }
        using TempDirectory folder = new TempDirectory();
        List<(ShaderGpuProgramType Stage, byte[] Code)> programs = CompileKeywordPrograms();
        File.WriteAllBytes(Path.Combine(folder.Path, "blob.bin"), BuildBlob(programs));
        string metadata = BuildKeywordMetadata();
        File.WriteAllText(Path.Combine(folder.Path, "metadata.json"), metadata);
        DecompilationResult result = Decompiler.DecompileFolder(folder.Path, new DecompileOptions
        {
            RestoreKeywordVariants = true,
            ReconstructSurfaceShaders = false,
            FuseTemps = false,
            Verbose = false,
            OutRoot = Path.Combine(folder.Path, "generated"),
        });
        Assert.Equal(2, result.Passes.Count);
        Assert.Equal(2, Regex.Matches(result.ShaderText, @"\bHLSLPROGRAM\b").Count);
        Assert.All(result.Passes, pass => Assert.Equal(4, pass.VariantPrograms.Count));
        Assert.Contains("#pragma multi_compile_local __ DETAIL", result.ShaderText);
        Assert.Contains("#pragma multi_compile __ MODE", result.ShaderText);
        Assert.Contains("#error No serialized program matches", result.ShaderText);
        string shaderPath = Path.Combine(folder.Path, "generated", "Test_RuntimeKeywords.shader");
        VerifyManifest(shaderPath);
        VerifyAllKeywordCompilations(result.ShaderText);
        // Optional artifact export lets the Unity GPU test consume this exact generated shader.
        string? output = Environment.GetEnvironmentVariable("SHADER_RUNTIME_TEST_OUTPUT");
        if (!string.IsNullOrEmpty(output))
        {
            Directory.CreateDirectory(output);
            File.WriteAllText(Path.Combine(output, "RuntimeKeywords.shader"), result.ShaderText);
        }
    }

    // Serializes compiled fixture programs into a Unity shader blob.
    internal static byte[] BuildBlob(List<(ShaderGpuProgramType Stage, byte[] Code)> programs)
    {
        List<byte[]> payloads = new List<byte[]>();
        foreach ((ShaderGpuProgramType stage, byte[] code) in programs)
        {
            using MemoryStream payload = new MemoryStream();
            using BinaryWriter writer = new BinaryWriter(payload, Encoding.UTF8, true);
            writer.Write(202012090);
            writer.Write((int)stage);
            writer.Write(new byte[16]);
            writer.Write(0);
            writer.Write(code.Length + 1);
            writer.Write((byte)0); // Raw Unity variant wrapper.
            writer.Write(code);
            while (payload.Length % 4 != 0)
            {
                writer.Write((byte)0);
            }
            payloads.Add(payload.ToArray());
        }
        using MemoryStream blob = new MemoryStream();
        using BinaryWriter table = new BinaryWriter(blob, Encoding.UTF8, true);
        table.Write(payloads.Count);
        int offset = 4 + 12 * payloads.Count;
        foreach (byte[] payload in payloads)
        {
            table.Write(offset);
            table.Write(payload.Length);
            table.Write(0);
            offset += payload.Length;
        }
        foreach (byte[] payload in payloads)
        {
            table.Write(payload);
        }
        return blob.ToArray();
    }

    // Builds one malformed vertex program and one valid fragment program.
    private static List<(ShaderGpuProgramType Stage, byte[] Code)> CompilePartialPrograms()
    {
        List<(ShaderGpuProgramType Stage, byte[] Code)> programs = new List<(ShaderGpuProgramType, byte[])>
        {
            (ShaderGpuProgramType.DX11VertexSM40, "DXBC"u8.ToArray()),
            (ShaderGpuProgramType.DX11PixelSM40, UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile("float4 main():SV_Target { return 1; }", "main", "ps_4_0")),
        };
        return programs;
    }

    // Serializes two passes with independent local and global keyword masks.
    private static string BuildKeywordMetadata()
    {
        List<object> passes = new List<object>();
        for (int pass = 0; pass < 2; pass++)
        {
            passes.Add(new
            {
                name = "Pass" + pass,
                renderState = new { cull = 0, zTest = 8, zWrite = false },
                directXPrograms = new object[]
                {
                    new { blobIndex = 0, stage = "Vertex", keywords = Array.Empty<string>(), keywordMask = new[] { "MODE" } },
                    new { blobIndex = 1, stage = "Vertex", keywords = new[] { "MODE" }, keywordMask = new[] { "MODE" } },
                    new { blobIndex = 2 + 2 * pass, stage = "Fragment", keywords = Array.Empty<string>(), keywordMask = new[] { "DETAIL" } },
                    new { blobIndex = 3 + 2 * pass, stage = "Fragment", keywords = new[] { "DETAIL" }, keywordMask = new[] { "DETAIL" } },
                },
            });
        }
        string metadata = JsonSerializer.Serialize(new
        {
            name = "Test/RuntimeKeywords",
            keywordFlags = new { MODE = 0, DETAIL = 1 },
            subShaders = new[] { new { passes } },
        });
        return metadata;
    }

    // Compiles independent vertex and fragment keyword states for the native fixture.
    private static List<(ShaderGpuProgramType Stage, byte[] Code)> CompileKeywordPrograms()
    {
        List<(ShaderGpuProgramType Stage, byte[] Code)> programs = new List<(ShaderGpuProgramType, byte[])>();
        const string varying = "struct Varyings { float4 position:SV_POSITION; float4 marker:TEXCOORD0; }; ";
        foreach (string value in new[] { "0.25", "0.75" })
        {
            programs.Add((ShaderGpuProgramType.DX11VertexSM40, UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile(
                varying + $"Varyings main(float4 p:POSITION) {{ Varyings o; o.marker=float4({value},0,0,1); o.position=p; return o; }}", "main", "vs_4_0")));
        }
        foreach (string blue in new[] { "0.5", "1.0" })
        {
            foreach (string green in new[] { "0.25", "0.75" })
            {
                programs.Add((ShaderGpuProgramType.DX11PixelSM40, UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile(
                    varying + $"float4 main(Varyings i):SV_Target {{ return float4(i.marker.x,{green},{blue},1); }}", "main", "ps_4_0")));
            }
        }
        return programs;
    }

    // Checks both stages under each local/global keyword combination.
    private static void VerifyAllKeywordCompilations(string shaderText)
    {
        foreach (Match match in Regex.Matches(shaderText, @"HLSLPROGRAM(.*?)ENDHLSL", RegexOptions.Singleline))
        {
            for (int state = 0; state < 4; state++)
            {
                string definitions = ((state & 1) != 0 ? "#define MODE 1\n" : "")
                    + ((state & 2) != 0 ? "#define DETAIL 1\n" : "");
                Assert.NotEmpty(UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile(definitions + match.Groups[1].Value, "vert", "vs_4_0"));
                Assert.NotEmpty(UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile(definitions + match.Groups[1].Value, "frag", "ps_4_0"));
            }
        }
    }

    // Checks exhaustive compilation cases and rejects a changed shader hash.
    private static void VerifyManifest(string shaderPath)
    {
        List<RuntimeCompilationCase> cases = RuntimeVariantManifest.Read(shaderPath);
        Assert.Equal(8, cases.Count);
        Assert.All(cases, item => Assert.Equal("vs_4_0", item.VertexProfile));
        RuntimeVariantManifest.VerifyCompilation(shaderPath);
        File.AppendAllText(shaderPath, "\n// Changed shader\n");
        Assert.Throws<InvalidDataException>(() => RuntimeVariantManifest.Read(shaderPath));
    }
}
