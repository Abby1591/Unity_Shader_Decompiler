using System.Text.Json;
using AssetStudio;
using UnityShaderDecompiler.Core;
using UnityShaderDecompiler.Core.DXBC;
using UnityShaderDecompiler.Core.DXBC.Compilation;

namespace UnityShaderDecompiler.Tests;

// Checks real resource reflection after recompiling each restored keyword state.
public sealed class RuntimeVariantBindingTests
{
    // Preserves per-variant resource names despite an unrelated texture property.
    [Fact]
    [Trait("Category", "D3D")]
    public void KeywordVariantsRetainTheirOwnResourceBindings()
    {
        if (!OperatingSystem.IsWindows())
        {
            return;
        }
        using TempDirectory folder = new TempDirectory();
        File.WriteAllBytes(Path.Combine(folder.Path, "blob.bin"), RuntimeVariantEmissionTests.BuildBlob(Programs()));
        File.WriteAllText(Path.Combine(folder.Path, "metadata.json"), Metadata());
        DecompilationResult result = Decompiler.DecompileFolder(folder.Path, new DecompileOptions
        {
            RestoreKeywordVariants = true, ReconstructSurfaceShaders = false,
            FuseTemps = false, Verbose = false, OutRoot = folder.Path, KeepRegisterBindings = true,
        });
        Assert.Single(result.Passes);
        Assert.Equal(2, result.Passes[0].VariantPrograms.Count);
        string path = Path.Combine(folder.Path, "Test_Bindings.shader");
        Dictionary<int, string> expectedTextures = new Dictionary<int, string> { [1] = "_TextureA", [2] = "_TextureB" };
        List<RuntimeCompilationCase> cases = RuntimeVariantManifest.Read(path);
        Assert.Equal(2, cases.Count);
        foreach (RuntimeCompilationCase variant in cases)
        {
            VerifyReflection(variant.Hlsl, expectedTextures[variant.Fragment]);
        }
    }

    // Requires the recompiled code to expose the original texture and constant.
    private static void VerifyReflection(string hlsl, string expectedTexture)
    {
        DxbcFile compiled = new DxbcFile();
        compiled.Load(DxbcCompiler.Compile(hlsl, "frag", "ps_4_0"));
        Assert.NotNull(compiled.ResourceDefinition);
        Assert.Contains(compiled.ResourceDefinition.ResourceBindings, binding => binding.Name == expectedTexture && binding.BindPoint == 0);
        Assert.Contains(compiled.ResourceDefinition.ResourceBindings, binding => binding.Name == "sourceSampler" && binding.BindPoint == 0);
        Assert.DoesNotContain(compiled.ResourceDefinition.ResourceBindings, binding => binding.Name == "_UnrelatedProperty");
        Assert.Contains(compiled.ResourceDefinition.ConstantBuffers.SelectMany(buffer => buffer.Variables),
            variable => variable.Name == "_Tint" && variable.Offset == 0 && variable.Size == 16);
    }

    // Builds independently reflected programs with different names on texture slot zero.
    private static List<(ShaderGpuProgramType Stage, byte[] Code)> Programs()
    {
        List<(ShaderGpuProgramType Stage, byte[] Code)> programs = new List<(ShaderGpuProgramType, byte[])>
        {
            (ShaderGpuProgramType.DX11VertexSM40, DxbcCompiler.Compile("float4 main(float4 p:POSITION):SV_POSITION{return p;}", "main", "vs_4_0")),
        };
        foreach (string name in new[] { "_TextureA", "_TextureB" })
        {
            string source = $"Texture2D {name}:register(t0); SamplerState sourceSampler:register(s0); "
                + "cbuffer Parameters:register(b0){float4 _Tint;} "
                + $"float4 main():SV_Target{{return {name}.SampleLevel(sourceSampler,float2(0.5,0.5),0)*_Tint;}}";
            programs.Add((ShaderGpuProgramType.DX11PixelSM40, DxbcCompiler.Compile(source, "main", "ps_4_0")));
        }
        return programs;
    }

    // Describes a shared vertex and two fragment keyword states in one pass.
    private static string Metadata()
    {
        return JsonSerializer.Serialize(new
        {
            name = "Test/Bindings",
            properties = new[] { new { name = "_UnrelatedProperty", type = 4 } },
            keywordFlags = new { MODE = 0 },
            subShaders = new[] { new { passes = new[] { new
            {
                directXPrograms = new[]
                {
                    new { blobIndex = 0, stage = "Vertex", keywords = Array.Empty<string>(), keywordMask = Array.Empty<string>() },
                    new { blobIndex = 1, stage = "Fragment", keywords = Array.Empty<string>(), keywordMask = new[] { "MODE" } },
                    new { blobIndex = 2, stage = "Fragment", keywords = new[] { "MODE" }, keywordMask = new[] { "MODE" } },
                },
            } } } },
        });
    }
}
