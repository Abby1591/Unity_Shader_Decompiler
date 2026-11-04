using System.Text.RegularExpressions;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Core;

// Reconstructs exact Unity keyword groups from serialized program states.
internal sealed class RuntimeVariantPlan
{
    internal required string[] Mask { get; init; }
    internal required List<RuntimeVariantState> States { get; init; }
    internal required List<RuntimeKeywordGroup> Groups { get; init; }
    internal required string[] StrippedKeywords { get; init; }
    internal required HashSet<string> LocalKeywords { get; init; }

    // Reconstructs complete keyword groups from serialized program states.
    internal static RuntimeVariantPlan Build(IReadOnlyList<ProgramVariantMetadata> programs,
        IReadOnlyDictionary<string, int> keywordFlags)
    {
        VariantPairing.Pair(programs);
        string[] mask = programs.SelectMany(p => p.KeywordMask).Distinct(StringComparer.Ordinal)
            .Order(StringComparer.Ordinal).ToArray();
        ValidateKeywords(mask, keywordFlags);
        Dictionary<string, RuntimeVariantState> states = BuildStates(programs);
        HashSet<string>[] enabledStates = states.Values.Select(s => s.Keywords.ToHashSet(StringComparer.Ordinal)).ToArray();
        string[] active = enabledStates.SelectMany(s => s).Distinct(StringComparer.Ordinal).Order(StringComparer.Ordinal).ToArray();
        List<RuntimeKeywordGroup> groups = BuildGroups(active, enabledStates, states.Count, keywordFlags);
        return new RuntimeVariantPlan
        {
            Mask = mask,
            States = states.OrderBy(p => p.Key, StringComparer.Ordinal).Select(p => p.Value).ToList(),
            Groups = groups,
            StrippedKeywords = mask.Except(active, StringComparer.Ordinal).ToArray(),
            LocalKeywords = mask.Where(keyword => keywordFlags[keyword] == 1).ToHashSet(StringComparer.Ordinal),
        };
    }

    // Rejects invalid keyword identifiers and missing scope flags.
    private static void ValidateKeywords(string[] mask, IReadOnlyDictionary<string, int> keywordFlags)
    {
        foreach (string keyword in mask)
        {
            if (!Regex.IsMatch(keyword, @"\A[A-Za-z_][A-Za-z0-9_]*\z"))
            {
                throw new InvalidDataException($"Invalid shader keyword '{keyword}'.");
            }
            if (!keywordFlags.TryGetValue(keyword, out int flags) || flags is not (0 or 1))
            {
                throw new InvalidDataException($"Missing or unsupported serialized scope flags for keyword '{keyword}'.");
            }
        }
    }

    // Pairs compatible stages and rejects ambiguous keyword states.
    private static Dictionary<string, RuntimeVariantState> BuildStates(IReadOnlyList<ProgramVariantMetadata> programs)
    {
        Dictionary<string, RuntimeVariantState> states = new Dictionary<string, RuntimeVariantState>(StringComparer.Ordinal);
        foreach (ProgramVariantMetadata vertex in programs.Where(p => p.Stage == "Vertex"))
        {
            foreach (ProgramVariantMetadata fragment in programs.Where(p => p.Stage == "Fragment"))
            {
                HashSet<string> shared = vertex.KeywordMask.Intersect(fragment.KeywordMask).ToHashSet(StringComparer.Ordinal);
                if (!vertex.Keywords.Where(shared.Contains).ToHashSet(StringComparer.Ordinal)
                    .SetEquals(fragment.Keywords.Where(shared.Contains)))
                {
                    continue;
                }
                string[] enabled = vertex.Keywords.Union(fragment.Keywords, StringComparer.Ordinal)
                    .Order(StringComparer.Ordinal).ToArray();
                string key = string.Join(";", enabled);
                RuntimeVariantState state = new RuntimeVariantState(vertex.BlobIndex, fragment.BlobIndex, enabled);
                if (states.TryGetValue(key, out RuntimeVariantState? previous)
                    && (previous.Vertex != state.Vertex || previous.Fragment != state.Fragment))
                {
                    throw new InvalidDataException($"Ambiguous shader programs for keyword state '{key}'.");
                }
                states[key] = state;
            }
        }
        return states;
    }

    // Builds independent keyword groups and checks their Cartesian product.
    private static List<RuntimeKeywordGroup> BuildGroups(string[] active, HashSet<string>[] enabledStates, int stateCount, IReadOnlyDictionary<string, int> keywordFlags)
    {
        HashSet<string> remaining = active.ToHashSet(StringComparer.Ordinal);
        List<RuntimeKeywordGroup> groups = new List<RuntimeKeywordGroup>();
        long combinations = 1;
        while (remaining.Count != 0)
        {
            HashSet<string> group = FindExclusiveGroup(remaining, active, enabledStates);
            if (enabledStates.Any(state => state.Count(group.Contains) > 1))
            {
                throw new InvalidDataException("Serialized keyword states cannot be represented by independent Unity keyword sets.");
            }
            bool allowsDisabled = enabledStates.Any(state => !state.Overlaps(group));
            combinations = checked(combinations * (group.Count + (allowsDisabled ? 1 : 0)));
            if (combinations > stateCount)
            {
                throw new InvalidDataException("Serialized variants are incomplete for the reconstructed Unity keyword sets.");
            }
            if (group.Select(keyword => keywordFlags[keyword]).Distinct().Count() != 1)
            {
                throw new InvalidDataException("An exclusive keyword set mixes local and global scope.");
            }
            groups.Add(new RuntimeKeywordGroup(group.Order(StringComparer.Ordinal).ToArray(), allowsDisabled, keywordFlags[group.First()] == 1));
            remaining.ExceptWith(group);
        }
        // Disjoint exclusive sets plus equal cardinality prove the exact Cartesian product.
        if (combinations != stateCount)
        {
            throw new InvalidDataException("Serialized variants do not form complete Unity keyword sets.");
        }
        return groups;
    }

    // Finds keywords that cannot be enabled together.
    private static HashSet<string> FindExclusiveGroup(HashSet<string> remaining, string[] active, HashSet<string>[] enabledStates)
    {
        HashSet<string> group = new HashSet<string>(StringComparer.Ordinal) { remaining.Order(StringComparer.Ordinal).First() };
        Queue<string> pending = new Queue<string>(group);
        while (pending.TryDequeue(out string? keyword))
        {
            foreach (string other in active)
            {
                if (!enabledStates.Any(state => state.Contains(keyword) && state.Contains(other)) && group.Add(other))
                {
                    pending.Enqueue(other);
                }
            }
        }
        return group;
    }
}
