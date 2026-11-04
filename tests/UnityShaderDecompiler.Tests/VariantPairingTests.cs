using Parser;
using Parser.DXBC.Metadata;

namespace UnityShaderDecompiler.Tests;

public class VariantPairingTests
{
    [Fact]
    public void FragmentOnlyKeywordReusesTheVertexProgram()
    {
        ProgramVariantMetadata[] programs = new[]
        {
            new ProgramVariantMetadata(1, "Vertex", [], ["SHARED"]),
            new ProgramVariantMetadata(2, "Fragment", [], ["SHARED", "DETAIL"]),
            new ProgramVariantMetadata(3, "Fragment", ["DETAIL"], ["SHARED", "DETAIL"]),
        };
        Assert.Equal(new[] { (1, 2), (1, 3) }, VariantPairing.Pair(programs));
    }

    [Fact]
    public void SharedKeywordMatchesByStateInsteadOfSerializedOrder()
    {
        ProgramVariantMetadata[] programs = new[]
        {
            new ProgramVariantMetadata(1, "Vertex", [], ["MODE"]),
            new ProgramVariantMetadata(2, "Vertex", ["MODE"], ["MODE"]),
            new ProgramVariantMetadata(3, "Fragment", ["MODE"], ["MODE"]),
            new ProgramVariantMetadata(4, "Fragment", [], ["MODE"]),
        };
        Assert.Equal(new[] { (1, 4), (2, 3) }, VariantPairing.Pair(programs));
    }

    [Fact]
    public void MissingVariantFailsEvenWhenItsKeywordIsNeverEnabledInTheOtherStage()
    {
        ProgramVariantMetadata[] programs = new[]
        {
            new ProgramVariantMetadata(1, "Vertex", [], ["MODE"]),
            new ProgramVariantMetadata(2, "Fragment", ["MODE"], ["MODE"]),
        };
        Assert.Throws<System.IO.InvalidDataException>(() => VariantPairing.Pair(programs));
    }
}
