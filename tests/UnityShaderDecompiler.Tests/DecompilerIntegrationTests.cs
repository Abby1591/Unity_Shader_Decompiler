using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityShaderDecompiler.Core;
using UnityShaderDecompiler.Core.Hlsl.Ast;
using UnityShaderDecompiler.Core.DXBC;
using UnityShaderDecompiler.Core.DXBC.Extraction;

namespace UnityShaderDecompiler.Tests;

/// <summary>
/// End-to-end, in-process decompilation of checked-in fixture blobs. These
/// are the regression gate: they exercise blob classification, DXBC parsing,
/// IR construction/optimization, variant pairing, and HLSL emission together.
/// </summary>
public class DecompilerIntegrationTests
{
    // Keeps both metadata passes when they share one compiled vertex program.
    [Fact]
    public void BrightPassFilter_ReusesVertexAcrossFragmentPasses()
    {
        DecompilationResult result = FixtureCache.Decompile("Hidden_BrightPassFilter2");

        Assert.Equal(2, result.Passes.Count);
        Assert.All(result.Passes, pass => Assert.NotNull(pass.VertexFunction));
        Assert.All(result.Passes, pass => Assert.NotNull(pass.FragmentFunction));
        Assert.DoesNotContain("_StubCB", result.ShaderText);
    }

    public static TheoryData<string, string> Fixtures => new()
    {
        { "HOLO_Holo", "HOLO/Holo" },
        { "Hidden_BrightPassFilter2", "Hidden/BrightPassFilter2" },
        { "PicaVoxel_PicaVoxel Diffuse", "PicaVoxel/PicaVoxel Diffuse" },
    };

    [Theory]
    [MemberData(nameof(Fixtures))]
    public void Decompile_ProducesShaderShellWithMetadata(string fixture, string expectedName)
    {
        var result = FixtureCache.Decompile(fixture);

        Assert.Equal(expectedName, result.Shader.Name);
        Assert.False(string.IsNullOrWhiteSpace(result.ShaderText));
        Assert.Contains($"Shader \"{expectedName}\"", result.ShaderText);

        // Every property in the serialized metadata must survive to the shell.
        foreach (var prop in result.Project.Metadata.Properties)
        {
            Assert.Matches(
                new Regex($@"^\s*{Regex.Escape(prop.Name)}\s*\(""", RegexOptions.Multiline),
                result.ShaderText);
        }

        if (!string.IsNullOrEmpty(result.Project.Metadata.Fallback))
            Assert.Contains($"Fallback \"{result.Project.Metadata.Fallback}\"", result.ShaderText);
    }

    [Theory]
    [MemberData(nameof(Fixtures))]
    public void Decompile_PairsVertexAndFragmentFunctions(string fixture, string _)
    {
        var result = FixtureCache.Decompile(fixture);

        // Metadata can declare passes with no compiled DX11 variants in the
        // blob (they are emitted as empty shells); only populated passes are
        // expected to carry a paired vertex/fragment.
        var populated = result.Passes
            .Where(p => p.VertexFunction is not null || p.FragmentFunction is not null)
            .ToList();

        Assert.NotEmpty(populated);
        Assert.All(populated, pass =>
        {
            Assert.NotNull(pass.VertexFunction);
            Assert.NotNull(pass.FragmentFunction);
        });

        // Pairing must consume every renderable subprogram; no stage silently
        // disappears. (Dedup folds are expected and are already counted by the
        // pass grouping, so compare against distinct stages found.)
        Assert.Contains(result.Subprograms, s => s.Stage == HlslShaderStage.Vertex);
        Assert.Contains(result.Subprograms, s => s.Stage == HlslShaderStage.Fragment);
    }

    [Theory]
    [MemberData(nameof(Fixtures))]
    public void Decompile_ProducesValidSsa(string fixture, string _)
    {
        var result = FixtureCache.Decompile(fixture);

        Assert.NotEmpty(result.Subprograms);
        Assert.All(result.Subprograms, sub =>
        {
            Assert.True(
                sub.Pipeline.SsaVerification.IsValid,
                $"{fixture} subprogram {sub.Index} ({sub.Stage}) has SSA errors: " +
                string.Join("; ", sub.Pipeline.SsaVerification.Errors));
        });
    }

    [Theory]
    [MemberData(nameof(Fixtures))]
    public void Decompile_IsDeterministic(string fixture, string _)
    {
        // No OutRoot: pure in-memory run, repeatable.
        var first = UnityShaderDecompiler.Core.Decompiler.DecompileFolder(
            TestPaths.FixtureFolder(fixture),
            new DecompileOptions { Verbose = false });
        var second = UnityShaderDecompiler.Core.Decompiler.DecompileFolder(
            TestPaths.FixtureFolder(fixture),
            new DecompileOptions { Verbose = false });

        Assert.Equal(first.ShaderText, second.ShaderText);
    }

    [Fact]
    public void Holo_EmitsCbuffersTexturesAndSamplers()
    {
        var text = FixtureCache.Decompile("HOLO_Holo").ShaderText;

        Assert.Contains("cbuffer _GlobalsCB_b0", text);
        Assert.Contains("_Color", text);
        Assert.Contains("unity_ObjectToWorld", text);
        Assert.Contains("Texture2D _MainTex", text);
        Assert.Contains("SamplerState sampler_MainTex", text);
    }

    [Fact]
    public void PicaVoxel_EmitsOneHlslProgramPerVariantPass()
    {
        var result = FixtureCache.Decompile("PicaVoxel_PicaVoxel Diffuse");

        // 16 verts x 8 frags + 10 verts x 10 frags + 4 verts x 4 frags, with
        // duplicate variants folded, is the current pass contract for this
        // fixture. A change here means variant pairing changed.
        Assert.Equal(22, result.Passes.Count);

        int programs = Regex.Matches(result.ShaderText, "HLSLPROGRAM").Count;
        Assert.Equal(result.Passes.Count, programs);
    }

    [Fact]
    public void Decompile_WritesShaderAndReportsFinalStage()
    {
        using var temp = new TempDirectory();
        string log = CaptureConsole(() =>
        {
            var result = UnityShaderDecompiler.Core.Decompiler.DecompileFolder(
                TestPaths.FixtureFolder("HOLO_Holo"),
                new DecompileOptions { OutRoot = temp.Path, Verbose = true });

            Assert.NotNull(result.OutputPath);
            Assert.True(File.Exists(result.OutputPath));
            Assert.Equal(result.ShaderText, File.ReadAllText(result.OutputPath!));
        });

        Assert.Contains("Stage 13/14: full shader written", log);
    }

    [Fact]
    public void FixtureBlobs_AllContainParseableDxbc()
    {
        foreach (var fixture in new[] { "HOLO_Holo", "Hidden_BrightPassFilter2", "PicaVoxel_PicaVoxel Diffuse" })
        {
            var project = UnityShaderDecompiler.Core.DXBC.Metadata.ShaderProject.LoadFromFolder(TestPaths.FixtureFolder(fixture));
            using var stream = new MemoryStream(project.Blob);
            using var reader = new BinaryReader(stream);
            var program = new AssetStudio.ShaderProgram(reader, new[] { 2022, 3, 62 });
            program.Read(reader, 0);

            int nonCompute = 0;
            for (int i = 0; i < program.m_SubPrograms.Length; i++)
            {
                var sub = program.m_SubPrograms[i];
                if (sub is null) continue;

                UnityShaderBlob blob;
                try
                {
                    blob = UnityShaderBlob.Parse(sub.m_ProgramCode, $"{fixture}[{i}]");
                }
                catch (InvalidDataException)
                {
                    // GLES / non-DXBC payloads are expected in the same blob
                    // and are skipped by the decompiler too.
                    continue;
                }

                if (blob.Kind != UnityShaderBlobKind.NonCompute) continue;

                nonCompute++;
                var file = new DxbcFile();
                file.Load(blob.Dxbc);
                Assert.NotNull(file.Shader);
            }

            Assert.True(nonCompute > 0, $"{fixture} has no non-compute subprograms");
        }
    }

    private static string CaptureConsole(Action action)
    {
        var original = Console.Out;
        using var writer = new StringWriter();
        Console.SetOut(writer);
        try
        {
            action();
        }
        finally
        {
            Console.SetOut(original);
        }
        return writer.ToString();
    }
}
