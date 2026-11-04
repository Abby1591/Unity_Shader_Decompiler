using Parser.DXBC;
using Parser.DXBC.Instructions;

namespace UnityShaderDecompiler.Tests;

public sealed class SaturatedMoveTests
{
    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    [Trait("Category", "D3D")]
    public void SaturatedMovesClampFloatValuesBeforeStoringBits(bool conditional)
    {
        if (!OperatingSystem.IsWindows()) return;
        string selection = conditional ? "((asuint(value.y) & 1u) != 0u ? value : float4(-0.5, 0.25, 1.5, 0))" : "value";
        DxbcFile original = RegisterRoundTrip.Compile(
            $"uint4 main(float4 value:TEXCOORD0):SV_Target {{ return asuint(saturate({selection})); }}");
        Assert.Contains(original.Shader!.Instructions, instruction => instruction.Saturate);
        DxbcFile recompiled = RegisterRoundTrip.Recompile(original);
        uint[] input = [0xbf000000u, 0x3e800001u, 0x3fc00000u, 0x7fc12345u];
        uint[] expected = [0, 0x3e800001u, 0x3f800000u, 0];
        Assert.Equal(expected, RegisterRoundTrip.Evaluate(original, input));
        Assert.Equal(expected, RegisterRoundTrip.Evaluate(recompiled, input));
        if (conditional)
        {
            input[1] = 0;
            expected[1] = 0x3e800000u;
            Assert.Equal(expected, RegisterRoundTrip.Evaluate(original, input));
            Assert.Equal(expected, RegisterRoundTrip.Evaluate(recompiled, input));
        }
    }
}
