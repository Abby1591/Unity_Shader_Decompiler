using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityShaderDecompiler.Core;
using UnityShaderDecompiler.Core.Hlsl.Ast;
using UnityShaderDecompiler.Core.DXBC;
using UnityShaderDecompiler.Core.DXBC.Extraction;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Tests;

/// <summary>
/// End-to-end, in-process decompilation of checked-in fixture blobs. These
/// are the regression gate: they exercise blob classification, DXBC parsing,
/// IR construction/optimization, variant pairing, and HLSL emission together.
/// </summary>
public class DecompilerIntegrationTests
{
    public static TheoryData<string, string> Fixtures => new()
    {
        { "Corpus_01 Properties", "Corpus/01 Properties" },
        { "Corpus_04 Vertex Fragment", "Corpus/04 Vertex Fragment" },
        { "Corpus_05 Surface Standard", "Corpus/05 Surface Standard" },
        { "Corpus_14 Shadow Depth Meta Motion", "Corpus/14 Shadow Depth Meta Motion" },
        { "Corpus_19 Hull Domain", "Corpus/19 Hull Domain" },
        { "Corpus_20 Instancing", "Corpus/20 Instancing" },
        { "Corpus_26 Multiple Render Targets", "Corpus/26 Multiple Render Targets" },
    };

    // The tessellation fixture contains only hull/domain programs in its
    // blob, so it is covered by HullDomain_EmitsHullAndDomainEntryPoints
    // instead of the vertex/fragment pairing contract.
    public static TheoryData<string, string> VertexFragmentFixtures => new()
    {
        { "Corpus_01 Properties", "Corpus/01 Properties" },
        { "Corpus_04 Vertex Fragment", "Corpus/04 Vertex Fragment" },
        { "Corpus_05 Surface Standard", "Corpus/05 Surface Standard" },
        { "Corpus_14 Shadow Depth Meta Motion", "Corpus/14 Shadow Depth Meta Motion" },
        { "Corpus_20 Instancing", "Corpus/20 Instancing" },
        { "Corpus_26 Multiple Render Targets", "Corpus/26 Multiple Render Targets" },
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
    [MemberData(nameof(VertexFragmentFixtures))]
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

    [Theory]
    [MemberData(nameof(Fixtures))]
    public void EveryPass_EmitsOneHlslProgram(string fixture, string _)
    {
        var result = FixtureCache.Decompile(fixture);

        // A pass whose program is not in the blob (e.g. a GrabPass or a pass
        // built only for another graphics API) keeps its render state but
        // emits no HLSL block: fabricating one would not be the shader.
        int programs = Regex.Matches(result.ShaderText, "HLSLPROGRAM").Count;
        int passesWithProgram = result.Passes.Count(p =>
            p.VertexFunction is not null || p.FragmentFunction is not null
            || p.GeometryFunction is not null || p.HullFunction is not null
            || p.DomainFunction is not null || p.ComputeFunction is not null);
        Assert.Equal(passesWithProgram, programs);
        Assert.DoesNotContain("_StubCB", result.ShaderText);
    }

    [Theory]
    [MemberData(nameof(Fixtures))]
    public void EveryMetadataPass_KeepsItsPassBlock(string fixture, string _)
    {
        // Pass indices are how real code addresses passes (SetPass,
        // Graphics.Blit(material, passIndex)). Keyword variants of one pass
        // must fold into it rather than becoming extra passes, so the emitted
        // pass count and order match the serialized shader.
        var result = FixtureCache.Decompile(fixture);
        string meta = File.ReadAllText(Path.Combine(TestPaths.FixtureFolder(fixture), "metadata.json"));
        using var doc = System.Text.Json.JsonDocument.Parse(meta);
        int expected = doc.RootElement.GetProperty("subShaders").EnumerateArray()
            .Sum(ss => ss.GetProperty("passes").GetArrayLength());

        int passes = Regex.Matches(result.ShaderText, @"(?m)^        Pass$").Count;
        Assert.Equal(expected, passes);
    }

    [Fact]
    public void KeywordVariants_AreDocumentedInThePass()
    {
        // One ShaderLab pass with a base body; the keyword permutations that
        // were compiled into separate subprograms are named, not silently
        // dropped, so the missing states are visible in the source.
        var text = FixtureCache.Decompile("Corpus_04 Vertex Fragment").ShaderText;

        Assert.Contains("Folded keyword variants (base state emitted)", text);
        Assert.Contains("LIGHTPROBE_SH", text);
        Assert.Single(Regex.Matches(text, @"(?m)^        Pass$"));
    }

    [Fact]
    public void Properties_EmitsCbuffersTexturesAndSamplers()
    {
        var text = FixtureCache.Decompile("Corpus_01 Properties").ShaderText;

        Assert.Contains("cbuffer _GlobalsCB_b0", text);
        Assert.Contains("_Color", text);
        Assert.Contains("unity_ObjectToWorld", text);
        Assert.Contains("Texture2D _BaseMap", text);
        Assert.Contains("SamplerState sampler_BaseMap", text);
    }

    [Fact]
    public void SurfaceStandard_EmitsLightingMembersUsedByBytecode()
    {
        // Metadata lists _LightColor0/_WorldSpaceLightPos0 for the lighting
        // variant; the bytecode reads both and they must survive.
        var text = FixtureCache.Decompile("Corpus_05 Surface Standard").ShaderText;

        Assert.Contains("_WorldSpaceLightPos0", text);
        Assert.Contains("_LightColor0", text);
    }

    [Fact]
    public void HullDomain_EmitsHullAndDomainEntryPoints()
    {
        var text = FixtureCache.Decompile("Corpus_19 Hull Domain").ShaderText;

        Assert.Contains(" hull(", text);
        Assert.Contains(" domain(", text);
    }

    [Fact]
    public void MultipleRenderTargets_EmitsEveryTarget()
    {
        var text = FixtureCache.Decompile("Corpus_26 Multiple Render Targets").ShaderText;

        for (int target = 0; target <= 7; target++)
            Assert.Contains($"sv_Target{target}", text);
    }

    [Fact]
    public void MultiPassFixture_EmitsEachLightMode()
    {
        var text = FixtureCache.Decompile("Corpus_14 Shadow Depth Meta Motion").ShaderText;

        Assert.Contains("\"SHADOWCASTER\"", text);
        Assert.Contains("\"DepthOnly\"", text);
        Assert.Contains("\"DepthNormals\"", text);
        Assert.Contains("\"MOTIONVECTORS\"", text);
    }

    [Fact]
    public void Decompile_WritesShaderAndReportsFinalStage()
    {
        using var temp = new TempDirectory();
        string log = CaptureConsole(() =>
        {
            var result = UnityShaderDecompiler.Core.Decompiler.DecompileFolder(
                TestPaths.FixtureFolder("Corpus_01 Properties"),
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
        foreach (object[] row in Fixtures)
        {
            string fixture = (string)row[0];
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

    [Fact]
    public void Decompile_InvalidChunkOffset_WithFailOnError_ThrowsWithoutWritingShader()
    {
        ShaderProject project = ShaderProject.LoadFromFolder(TestPaths.FixtureFolder("Corpus_01 Properties"));
        // This fixture's vertex subprogram is DX11VertexSM50 (index 1).
        DecompiledSubprogram subprogram = FixtureCache.Decompile("Corpus_01 Properties").Subprograms
            .Single(sub => sub.Stage == HlslShaderStage.Vertex);
        int dxbcOffset = project.Blob.AsSpan().IndexOf(subprogram.DxbcBytes);
        Assert.True(dxbcOffset >= 0);
        Assert.Equal(-1, project.Blob.AsSpan(dxbcOffset + 1).IndexOf(subprogram.DxbcBytes));
        Assert.NotEmpty(subprogram.Dxbc.Chunks);

        // Corrupt only the in-memory copy: the first chunk offset (at byte 32) is outside the container.
        BitConverter.GetBytes(subprogram.Dxbc.TotalLength).CopyTo(project.Blob, dxbcOffset + 32);
        using TempDirectory temp = new();

        InvalidDataException exception = Assert.Throws<InvalidDataException>(() =>
            Decompiler.Decompile(project, new DecompileOptions
            {
                FailOnError = true, OutRoot = temp.Path, Verbose = false
            }));

        Assert.Contains("is outside the DXBC container", exception.Message);
        Assert.Empty(Directory.GetFiles(temp.Path, "*.shader"));
    }

    [Fact]
    public void Decompile_InvalidChunkOffset_WithoutFailOnError_KeepsOnlyPixelSubprogram()
    {
        ShaderProject project = ShaderProject.LoadFromFolder(TestPaths.FixtureFolder("Corpus_01 Properties"));
        DecompilationResult original = FixtureCache.Decompile("Corpus_01 Properties");
        Assert.Equal(2, original.Subprograms.Count);
        DecompiledSubprogram vertex = original.Subprograms.Single(sub => sub.Stage == HlslShaderStage.Vertex);
        int dxbcOffset = project.Blob.AsSpan().IndexOf(vertex.DxbcBytes);
        Assert.True(dxbcOffset >= 0);
        Assert.Equal(-1, project.Blob.AsSpan(dxbcOffset + 1).IndexOf(vertex.DxbcBytes));
        Assert.NotEmpty(vertex.Dxbc.Chunks);

        // Corrupt the vertex's first chunk offset; leave the pixel subprogram intact.
        BitConverter.GetBytes(vertex.Dxbc.TotalLength).CopyTo(project.Blob, dxbcOffset + 32);
        using TempDirectory temp = new();

        DecompilationResult result = Decompiler.Decompile(project, new DecompileOptions
        {
            FailOnError = false, OutRoot = temp.Path, Verbose = false
        });

        DecompiledSubprogram remaining = Assert.Single(result.Subprograms);
        Assert.Equal(3, remaining.Index);
        Assert.Equal(HlslShaderStage.Fragment, remaining.Stage);
        Assert.NotNull(result.OutputPath);
        Assert.Equal(result.ShaderText, File.ReadAllText(result.OutputPath));
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
