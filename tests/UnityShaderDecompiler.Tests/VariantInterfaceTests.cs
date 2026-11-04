using Parser;
using Parser.DXBC.Chunks;

namespace UnityShaderDecompiler.Tests;

public sealed class VariantInterfaceTests
{
    [Theory]
    [InlineData(1, 3, 3, true)]
    [InlineData(0, 3, 3, false)]
    [InlineData(1, 1, 3, false)]
    [InlineData(1, 3, 7, false)]
    public void AdjacentStagesRequireMatchingRegisterTypeAndComponents(int register, int type, int mask, bool expected)
    {
        SignatureElement output = new SignatureElement
        {
            SemanticName = "TEXCOORD", Register = 1, ComponentType = 3, Mask = 3,
        };
        SignatureElement input = new SignatureElement
        {
            SemanticName = "texcoord", Register = (uint)register, ComponentType = (uint)type, Mask = (byte)mask,
        };
        Assert.Equal(expected, VariantPairing.InterfacesMatch([output], [input]));
    }
}
