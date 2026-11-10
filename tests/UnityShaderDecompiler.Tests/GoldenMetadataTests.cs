using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityShaderDecompiler.Core;
using UnityShaderDecompiler.Core.DXBC.Metadata;

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
        "Corpus_01 Properties",
        "Corpus_04 Vertex Fragment",
        "Corpus_05 Surface Standard",
        "Corpus_14 Shadow Depth Meta Motion",
        "Corpus_19 Hull Domain",
        "Corpus_20 Instancing",
        "Corpus_26 Multiple Render Targets",
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
    public void Properties_WithKeepRegisterBindings_RetainsSamplerRegisters()
    {
        var kept = UnityShaderDecompiler.Core.Decompiler.DecompileFolder(
            TestPaths.FixtureFolder("Corpus_01 Properties"),
            new DecompileOptions { Verbose = false, KeepRegisterBindings = true });

        Assert.Contains("register(s0)", kept.ShaderText);

        // Default output strips explicit sampler/texture registers; named
        // cbuffers still encode their slot in the name.
        var stripped = FixtureCache.Decompile("Corpus_01 Properties");
        Assert.DoesNotContain("register(s0)", stripped.ShaderText);
        Assert.Contains("cbuffer _UnityPerFrameCB_b2", stripped.ShaderText);
    }

    [Theory]
    [MemberData(nameof(Fixtures))]
    public void Fixture_MatchesCheckedInSample(string fixture)
    {
        var result = FixtureCache.Decompile(fixture);
        string golden = Path.Combine(TestPaths.RepoRoot, "samples", fixture + ".shader");

        if (!File.Exists(golden))
            return; // generated examples are optional in a source-only checkout

        string expected = Normalize(File.ReadAllText(golden));
        string actual = Normalize(result.ShaderText);
        Assert.True(
            expected == actual,
            $"{fixture}: output no longer matches samples/{fixture}.shader\n" +
            FirstDifference(expected, actual));
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

    private static string FirstDifference(string expected, string actual)
    {
        string[] expectedLines = expected.Split('\n');
        string[] actualLines = actual.Split('\n');
        int count = Math.Max(expectedLines.Length, actualLines.Length);

        for (int i = 0; i < count; i++)
        {
            string e = i < expectedLines.Length ? expectedLines[i] : "<end of file>";
            string a = i < actualLines.Length ? actualLines[i] : "<end of file>";
            if (e != a)
            {
                return $"  first difference at line {i + 1}\n" +
                       $"  expected: {e}\n" +
                       $"  actual:   {a}";
            }
        }

        return "  files differ only in trailing whitespace";
    }
}
