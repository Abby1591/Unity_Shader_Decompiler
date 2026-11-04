using System;
using System.Text.RegularExpressions;
using Parser;

namespace UnityShaderDecompiler.Tests;

public class GoldenNativeCompilationTests
{
    [Theory]
    [InlineData("vert", "vs_5_0")]
    [InlineData("frag", "ps_5_0")]
    [Trait("Category", "D3D")]
    public void GoldenFixtureProducesCompilableStages(string entry, string profile)
    {
        if (!OperatingSystem.IsWindows()) return;

        DecompilationResult result = FixtureCache.Decompile("HOLO_Holo");
        MatchCollection blocks = Regex.Matches(result.ShaderText,
            @"HLSLPROGRAM(.*?)ENDHLSL", RegexOptions.Singleline);
        Assert.NotEmpty(blocks);
        foreach (Match block in blocks)
            Assert.NotEmpty(RecompileVerify.CompileHlsl(block.Groups[1].Value, entry, profile));
    }
}
