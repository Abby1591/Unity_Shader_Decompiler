using Parser;
using Parser.DXBC.Metadata;

namespace UnityShaderDecompiler.Tests;

public sealed class RuntimeVariantPlanTests
{
    [Fact]
    public void IndependentAndExclusiveKeywordsReconstructExactlyTheSerializedStates()
    {
        string[][] states = [ ["RED"], ["BLUE"], ["RED", "DETAIL"], ["BLUE", "DETAIL"] ];
        RuntimeVariantPlan plan = Plan(states, ["RED", "BLUE", "DETAIL", "STRIPPED"]);
        Assert.Equal(4, plan.States.Count);
        Assert.Contains(plan.Groups, group => group.Keywords.SequenceEqual(new[] { "BLUE", "RED" }) && !group.AllowsDisabled);
        Assert.Contains(plan.Groups, group => group.Keywords.SequenceEqual(new[] { "DETAIL" }) && group.AllowsDisabled);
        Assert.Equal(new[] { "STRIPPED" }, plan.StrippedKeywords);
    }

    [Fact]
    public void CorrelatedKeywordsAreRejectedInsteadOfInventingCombinations()
    {
        Assert.Throws<InvalidDataException>(() => Plan([[], ["A", "B"]], ["A", "B"]));
    }

    [Fact]
    public void IncompleteExclusiveSetsAreRejected()
    {
        Assert.Throws<InvalidDataException>(() => Plan([[], ["A"], ["B"], ["A", "C"]], ["A", "B", "C"]));
    }

    [Fact]
    public void DuplicateStateWithDifferentProgramsIsAmbiguous()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], []), new(1, "Vertex", [], []), new(2, "Fragment", [], [])];
        Assert.Throws<InvalidDataException>(() => RuntimeVariantPlan.Build(programs, new Dictionary<string, int>()));
    }

    [Fact]
    public void OneProgramCanServeMultipleKeywordStates()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(0, "Vertex", ["MODE"], ["MODE"]),
            new(1, "Fragment", [], ["MODE"]), new(1, "Fragment", ["MODE"], ["MODE"])];
        RuntimeVariantPlan plan = RuntimeVariantPlan.Build(programs, new Dictionary<string, int> { ["MODE"] = 0 });
        Assert.Equal(2, plan.States.Count);
    }

    [Theory]
    [InlineData("BAD NAME")]
    [InlineData("NAME\n#error injected")]
    [InlineData("1NAME")]
    public void KeywordsMustBePreprocessorIdentifiers(string keyword)
    {
        Assert.Throws<InvalidDataException>(() => Plan([[], [keyword]], [keyword]));
    }

    [Fact]
    public void MissingScopeMetadataIsNotGuessed()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(1, "Fragment", [], ["MODE"])];
        Assert.Throws<InvalidDataException>(() => RuntimeVariantPlan.Build(programs, new Dictionary<string, int>()));
    }

    [Fact]
    public void MasksMustBeConsistentWithinEachStage()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], []), new(1, "Vertex", [], ["MODE"]), new(2, "Fragment", [], [])];
        Assert.Throws<InvalidDataException>(() => VariantPairing.Pair(programs));
    }

    [Theory]
    [InlineData(2)]
    [InlineData(255)]
    public void UnknownScopeFlagsAreRejected(int flags)
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(1, "Fragment", [], [])];
        Assert.Throws<InvalidDataException>(() => RuntimeVariantPlan.Build(programs,
            new Dictionary<string, int> { ["MODE"] = flags }));
    }

    [Fact]
    public void ExclusiveGroupsCannotMixLocalAndGlobalKeywords()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", ["A"], ["A", "B"]),
            new(1, "Vertex", ["B"], ["A", "B"]), new(2, "Fragment", [], [])];
        Assert.Throws<InvalidDataException>(() => RuntimeVariantPlan.Build(programs,
            new Dictionary<string, int> { ["A"] = 0, ["B"] = 1 }));
    }

    [Fact]
    public void DisabledLocalKeywordsRetainTheirScope()
    {
        ProgramVariantMetadata[] programs = [new(0, "Vertex", [], ["MODE"]), new(1, "Fragment", [], [])];
        RuntimeVariantPlan plan = RuntimeVariantPlan.Build(programs, new Dictionary<string, int> { ["MODE"] = 1 });
        Assert.Contains("MODE", plan.StrippedKeywords);
        Assert.Contains("MODE", plan.LocalKeywords);
    }

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
