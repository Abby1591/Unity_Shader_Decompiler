using UnityShaderDecompiler.Core.DXBC;
using UnityShaderDecompiler.Core.DXBC.Instructions;
using UnityShaderDecompiler.Core.DXBC.IR;

namespace UnityShaderDecompiler.Tests;

// Covers structured load compatibility tests.
public sealed class StructuredLoadCompatibilityTests
{
    // Verifies that existing public entry points and enum values remain available.
    [Fact]
    public void ExistingPublicEntryPointsAndEnumValuesRemainAvailable()
    {
        Assert.NotNull(typeof(IRBuilder).GetConstructor(Type.EmptyTypes));
        Assert.NotNull(typeof(IRPipeline).GetMethod("Run", new[] { typeof(DxbcFile), typeof(bool) }));
        Assert.Equal(7, (int)IRExpression.TextureOperation.Gather);
        Assert.Equal(14, (int)IRExpression.TextureOperation.CheckAccessFullyMapped);
    }

    // Verifies that structured loads keep exact words with default options and dynamic offsets.
    [Theory]
    [InlineData(true, false)]
    [InlineData(false, false)]
    [InlineData(true, true)]
    [InlineData(false, true)]
    [Trait("Category", "D3D")]
    public void StructuredLoadsKeepExactWordsWithDefaultOptionsAndDynamicOffsets(bool fuseTemps, bool dynamicOffset)
    {
        if (!OperatingSystem.IsWindows())
        {
            return;
        }
        string member = dynamicOffset ? "i.y & 3" : "2";
        string source = "struct Element { uint value[4]; }; StructuredBuffer<Element> data : register(t7); "
            + $"uint4 main(nointerpolation uint2 i : TEXCOORD0) : SV_Target {{ return data[i.x].value[{member}]; }}";
        DxbcFile original = RegisterRoundTrip.Compile(source);
        if (dynamicOffset)
        {
            Assert.Contains(original.Shader!.Instructions, instruction => instruction.Opcode == Opcode.LdStructured
                && instruction.Operands[2].RegisterType != RegisterType.Immediate32);
        }
        DxbcFile rebuilt = RegisterRoundTrip.Recompile(original, fuseTemps);
        uint[] words = { 1, 0xffffffffu, 0x7fc12345u, 0x80000000u, 0x01000001u, 0xffc54321u, 0x7fffffffu, 0x80000001u };
        for (uint index = 0; index < 2; index++)
        {
            for (uint component = 0; component < 4; component++)
            {
                uint[] input = { index, component, 0, 0 };
                uint expected = words[index * 4 + (dynamicOffset ? component : 2)];
                uint[] output = { expected, expected, expected, expected };
                Assert.Equal(output, RegisterRoundTrip.Evaluate(original, input, words));
                Assert.Equal(output, RegisterRoundTrip.Evaluate(rebuilt, input, words));
            }
        }
    }
}
