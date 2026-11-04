using UnityShaderDecompiler.Core;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Tests;

// Covers variant pairing tests.
public class VariantPairingTests
{
    // Verifies that expanded variants preserve geometry and tessellation stages.
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

    // Verifies that expanded variants reject unmatched intermediate stages.
    [Fact]
    public void ExpandedVariantsRejectUnmatchedIntermediateStages()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(1, "Geometry", ["MODE"], ["MODE"])];
        Assert.Throws<System.IO.InvalidDataException>(() => VariantPairing.Group(programs));
    }

    // Verifies that fragment only keyword reuses the vertex program.
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

    // Verifies that shared keyword matches by state instead of serialized order.
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

    // Verifies that missing variant fails even when its keyword is never enabled in the other stage.
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
