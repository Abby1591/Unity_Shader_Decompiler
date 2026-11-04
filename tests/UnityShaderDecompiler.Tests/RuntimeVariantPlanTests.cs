using UnityShaderDecompiler.Core;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Tests;

// Covers runtime variant plan tests.
public sealed class RuntimeVariantPlanTests
{
    // Verifies that independent and exclusive keywords reconstruct exactly the serialized states.
    [Fact]
    public void IndependentAndExclusiveKeywordsReconstructExactlyTheSerializedStates()
    {
        string[][] states = [["RED"], ["BLUE"], ["RED", "DETAIL"], ["BLUE", "DETAIL"]];
        RuntimeVariantPlan plan = Plan(states, ["RED", "BLUE", "DETAIL", "STRIPPED"]);
        Assert.Equal(4, plan.States.Count);
        Assert.Contains(plan.Groups, group => group.Keywords.SequenceEqual(new[] { "BLUE", "RED" }) && !group.AllowsDisabled);
        Assert.Contains(plan.Groups, group => group.Keywords.SequenceEqual(new[] { "DETAIL" }) && group.AllowsDisabled);
        Assert.Equal(new[] { "STRIPPED" }, plan.StrippedKeywords);
    }

    // Verifies that correlated keywords are rejected instead of inventing combinations.
    [Fact]
    public void CorrelatedKeywordsAreRejectedInsteadOfInventingCombinations()
    {
        Assert.Throws<InvalidDataException>(() => Plan([[], ["A", "B"]], ["A", "B"]));
    }

    // Verifies that incomplete exclusive sets are rejected.
    [Fact]
    public void IncompleteExclusiveSetsAreRejected()
    {
        Assert.Throws<InvalidDataException>(() => Plan([[], ["A"], ["B"], ["A", "C"]], ["A", "B", "C"]));
    }

    // Verifies that duplicate state with different programs is ambiguous.
    [Fact]
    public void DuplicateStateWithDifferentProgramsIsAmbiguous()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], []), new(1, "Vertex", [], []), new(2, "Fragment", [], [])];
        Assert.Throws<InvalidDataException>(() => RuntimeVariantPlan.Build(programs, new Dictionary<string, int>()));
    }

    // Verifies that one program can serve multiple keyword states.
    [Fact]
    public void OneProgramCanServeMultipleKeywordStates()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(0, "Vertex", ["MODE"], ["MODE"]),
            new(1, "Fragment", [], ["MODE"]), new(1, "Fragment", ["MODE"], ["MODE"])];
        RuntimeVariantPlan plan = RuntimeVariantPlan.Build(programs, new Dictionary<string, int> { ["MODE"] = 0 });
        Assert.Equal(2, plan.States.Count);
    }

    // Verifies that reused blob does not hide an unmatched keyword state.
    [Fact]
    public void ReusedBlobDoesNotHideAnUnmatchedKeywordState()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(0, "Vertex", ["MODE"], ["MODE"]),
            new(1, "Fragment", [], ["MODE"])];
        Assert.Throws<InvalidDataException>(() => RuntimeVariantPlan.Build(programs,
            new Dictionary<string, int> { ["MODE"] = 0 }));
    }

    // Verifies that keywords must be preprocessor identifiers.
    [Theory]
    [InlineData("BAD NAME")]
    [InlineData("NAME\n#error injected")]
    [InlineData("1NAME")]
    public void KeywordsMustBePreprocessorIdentifiers(string keyword)
    {
        Assert.Throws<InvalidDataException>(() => Plan([[], [keyword]], [keyword]));
    }

    // Verifies that missing scope metadata is not guessed.
    [Fact]
    public void MissingScopeMetadataIsNotGuessed()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(1, "Fragment", [], ["MODE"])];
        Assert.Throws<InvalidDataException>(() => RuntimeVariantPlan.Build(programs, new Dictionary<string, int>()));
    }

    // Verifies that masks must be consistent within each stage.
    [Fact]
    public void MasksMustBeConsistentWithinEachStage()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], []), new(1, "Vertex", [], ["MODE"]), new(2, "Fragment", [], [])];
        Assert.Throws<InvalidDataException>(() => VariantPairing.Pair(programs));
    }

    // Verifies that unknown scope flags are rejected.
    [Theory]
    [InlineData(2)]
    [InlineData(255)]
    public void UnknownScopeFlagsAreRejected(int flags)
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(1, "Fragment", [], [])];
        Assert.Throws<InvalidDataException>(() => RuntimeVariantPlan.Build(programs,
            new Dictionary<string, int> { ["MODE"] = flags }));
    }

    // Verifies that exclusive groups cannot mix local and global keywords.
    [Fact]
    public void ExclusiveGroupsCannotMixLocalAndGlobalKeywords()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", ["A"], ["A", "B"]),
            new(1, "Vertex", ["B"], ["A", "B"]), new(2, "Fragment", [], [])];
        Assert.Throws<InvalidDataException>(() => RuntimeVariantPlan.Build(programs,
            new Dictionary<string, int> { ["A"] = 0, ["B"] = 1 }));
    }

    // Verifies that disabled local keywords retain their scope.
    [Fact]
    public void DisabledLocalKeywordsRetainTheirScope()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(1, "Fragment", [], [])];
        RuntimeVariantPlan plan = RuntimeVariantPlan.Build(programs, new Dictionary<string, int> { ["MODE"] = 1 });
        Assert.Contains("MODE", plan.StrippedKeywords);
        Assert.Contains("MODE", plan.LocalKeywords);
    }

    // Builds a keyword plan from the supplied fixture metadata.
    private static RuntimeVariantPlan Plan(string[][] states, string[] mask)
    {
        List<ProgramVariantMetadata> programs = new List<ProgramVariantMetadata>();
        for (int index = 0; index < states.Length; index++)
        {
            programs.Add(new ProgramVariantMetadata(index * 2, "Vertex", states[index], mask));
            programs.Add(new ProgramVariantMetadata(index * 2 + 1, "Fragment", states[index], mask));
        }
        return RuntimeVariantPlan.Build(programs, mask.ToDictionary(keyword => keyword, _ => 0));
    }
}
