using System;
using System.Text.RegularExpressions;
using UnityShaderDecompiler.Core;

namespace UnityShaderDecompiler.Tests;

// Covers golden native compilation tests.
public class GoldenNativeCompilationTests
{
    // Verifies that golden fixture produces compilable stages.
    [Theory]
    [InlineData("vert", "vs_5_0")]
    [InlineData("frag", "ps_5_0")]
    [Trait("Category", "D3D")]
    public void GoldenFixtureProducesCompilableStages(string entry, string profile)
    {
        if (!OperatingSystem.IsWindows())
        {
            return;
        }

        DecompilationResult result = FixtureCache.Decompile("HOLO_Holo");
        MatchCollection blocks = Regex.Matches(result.ShaderText,
            @"HLSLPROGRAM(.*?)ENDHLSL", RegexOptions.Singleline);
        Assert.NotEmpty(blocks);
        foreach (Match block in blocks)
        {
            Assert.NotEmpty(UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile(block.Groups[1].Value, entry, profile));
        }
    }
}
