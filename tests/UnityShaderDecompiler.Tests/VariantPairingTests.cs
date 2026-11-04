using Parser;
using Parser.DXBC.Metadata;

namespace UnityShaderDecompiler.Tests;

public class VariantPairingTests
{
    [Fact]
    public void ExpandedVariantsPreserveGeometryAndTessellationStages()
    {
        ProgramVariantMetadata[] programs =
        [
            new(0, "Vertex", [], []),
            new(1, "Hull", [], ["MODE"]), new(2, "Hull", ["MODE"], ["MODE"]),
            new(3, "Domain", ["MODE"], ["MODE"]), new(4, "Domain", [], ["MODE"]),
            new(5, "Geometry", [], []),
            new(6, "Fragment", [], ["DETAIL"]), new(7, "Fragment", ["DETAIL"], ["DETAIL"]),
        ];
        List<ProgramVariantMetadata[]> groups = VariantPairing.Group(programs);
        Assert.Equal(4, groups.Count);
        Assert.Contains(groups, group => group.Select(program => program.BlobIndex).SequenceEqual(new[] { 0, 1, 4, 5, 6 }));
        Assert.Contains(groups, group => group.Select(program => program.BlobIndex).SequenceEqual(new[] { 0, 2, 3, 5, 7 }));
        Assert.All(groups, group => Assert.Equal(new[] { "Vertex", "Hull", "Domain", "Geometry", "Fragment" },
            group.Select(program => program.Stage)));
    }

    [Fact]
    public void ExpandedVariantsRejectUnmatchedIntermediateStages()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(1, "Geometry", ["MODE"], ["MODE"])];
        Assert.Throws<System.IO.InvalidDataException>(() => VariantPairing.Group(programs));
    }

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
