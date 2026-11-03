using System;
using System.Linq;
using System.Text.RegularExpressions;
using Parser;
using Parser.DXBC.Metadata;

namespace UnityShaderDecompiler.Tests;

/// <summary>
/// Metadata-fidelity checks derived from the input <c>metadata.json</c> rather
/// than hard-coded shader facts. These are the in-process replacement for the
/// Python golden assertions (which had drifted from the emitter's actual
/// register-binding and "unused cbuffer member" behaviour).
/// </summary>
public class GoldenMetadataTests
{
    public static TheoryData<string> Fixtures => new()
    {
        "HOLO_Holo",
        "Hidden_BrightPassFilter2",
        "PicaVoxel_PicaVoxel Diffuse",
    };

    [Theory]
    [MemberData(nameof(Fixtures))]
    public void CbufferSlots_AreRepresentedInOutput(string fixture)
    {
        var result = FixtureCache.Decompile(fixture);
        int[] slots = CbufferSlots(result.Project.Metadata);

        foreach (int slot in slots)
        {
            bool explicitRegister = Regex.IsMatch(result.ShaderText, $@"register\(b{slot}\)");
            bool namedBinding = Regex.IsMatch(result.ShaderText, $@"cbuffer\s+\w*b{slot}\b");
            Assert.True(
                explicitRegister || namedBinding,
                $"{fixture}: no register(b{slot}) and no cbuffer name ending in b{slot}");
        }
    }

    [Theory]
    [MemberData(nameof(Fixtures))]
    public void AtLeastOneNamedCbufferMember_IsEmitted(string fixture)
    {
        var result = FixtureCache.Decompile(fixture);
        string[] members = NamedCbufferMembers(result.Project.Metadata);

        Assert.True(members.Length > 0, $"{fixture}: metadata has no named cbuffer members");
        Assert.Contains(members, member => result.ShaderText.Contains(member, StringComparison.Ordinal));
    }

    [Fact]
    public void PicaVoxel_EmitsLightingMemberThatBytecodeUses()
    {
        var text = FixtureCache.Decompile("PicaVoxel_PicaVoxel Diffuse").ShaderText;

        // Metadata lists _LightColor0, but this variant's bytecode never reads
        // it, so it is intentionally not emitted. _WorldSpaceLightPos0 *is*
        // read and must survive.
        Assert.Contains("_WorldSpaceLightPos0", text);
    }

    [Fact]
    public void PicaVoxel_WithKeepRegisterBindings_RetainsSamplerRegisters()
    {
        var kept = Parser.Decompiler.DecompileFolder(
            TestPaths.FixtureFolder("PicaVoxel_PicaVoxel Diffuse"),
            new DecompileOptions { Verbose = false, KeepRegisterBindings = true });

        Assert.Contains("register(s0)", kept.ShaderText);

        // Default output strips explicit sampler/texture registers; named
        // cbuffers still encode their slot in the name.
        var stripped = FixtureCache.Decompile("PicaVoxel_PicaVoxel Diffuse");
        Assert.DoesNotContain("register(s0)", stripped.ShaderText);
        Assert.Contains("cbuffer cb2 : register(b2)", stripped.ShaderText);
    }

    [Fact]
    public void Holo_MatchesCheckedInGoldenExample()
    {
        var result = FixtureCache.Decompile("HOLO_Holo");
        string golden = System.IO.Path.Combine(
            TestPaths.RepoRoot, "Shader Decompiler", "Output", "HOLO_Holo.shader");

        if (!System.IO.File.Exists(golden))
            return; // generated examples are optional in a source-only checkout

        Assert.Equal(
            Normalize(System.IO.File.ReadAllText(golden)),
            Normalize(result.ShaderText));
    }

    private static int[] CbufferSlots(ShaderMetadata metadata) =>
        metadata.SubShaders
            .SelectMany(ss => ss.Passes)
            .SelectMany(p => p.ConstantBuffers)
            .Select(cb => cb.Slot)
            .Where(slot => slot >= 0)
            .Distinct()
            .OrderBy(slot => slot)
            .ToArray();

    private static string[] NamedCbufferMembers(ShaderMetadata metadata) =>
        metadata.SubShaders
            .SelectMany(ss => ss.Passes)
            .SelectMany(p => p.ConstantBuffers)
            .SelectMany(cb => cb.Variables)
            .Select(v => v.Name)
            .Where(name => !string.IsNullOrEmpty(name))
            .Distinct()
            .ToArray();

    private static string Normalize(string text) => text.Replace("\r\n", "\n").TrimEnd();
}
