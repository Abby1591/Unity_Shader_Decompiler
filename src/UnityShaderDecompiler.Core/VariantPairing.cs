using UnityShaderDecompiler.Core.DXBC.Metadata;
using UnityShaderDecompiler.Core.DXBC.Chunks;

namespace UnityShaderDecompiler.Core;

// Matches serialized graphics stages without inventing keyword combinations.
internal static class VariantPairing
{
    // Expanded passes may contain any serialized graphics stage, not only vertex/fragment.
    internal static List<ProgramVariantMetadata[]> Group(IReadOnlyList<ProgramVariantMetadata> programs)
    {
        string[] stageOrder = { "Vertex", "Hull", "Domain", "Geometry", "Fragment" };
        if (programs.Count == 0 || programs.Any(program => !stageOrder.Contains(program.Stage)))
        {
            throw new InvalidDataException("Serialized variants contain an unknown graphics stage.");
        }
        List<ProgramVariantMetadata[]> groups = new List<ProgramVariantMetadata[]> { Array.Empty<ProgramVariantMetadata>() };
        foreach (string stageName in stageOrder)
        {
            ProgramVariantMetadata[] stage = programs.Where(program => program.Stage == stageName).ToArray();
            if (stage.Length == 0)
            {
                continue;
            }
            ValidateStage(stage);
            List<ProgramVariantMetadata[]> next = new List<ProgramVariantMetadata[]>();
            foreach (ProgramVariantMetadata[] group in groups)
            {
                foreach (ProgramVariantMetadata candidate in stage)
                {
                    bool compatible = group.All(previous => StatesMatch(previous, candidate));
                    if (compatible)
                    {
                        next.Add(group.Append(candidate).ToArray());
                    }
                }
            }
            groups = next;
        }
        HashSet<ProgramVariantMetadata> matched = groups.SelectMany(group => group).ToHashSet();
        if (programs.Any(program => !matched.Contains(program)))
        {
            throw new InvalidDataException("Serialized shader variants contain an unmatched stage.");
        }
        return groups.DistinctBy(group => string.Join(",", group.Select(program => program.BlobIndex))).ToList();
    }

    // Checks register locations, component types and masks between stages.
    internal static bool InterfacesMatch(IReadOnlyList<SignatureElement> outputs, IReadOnlyList<SignatureElement> inputs)
    {
        // Adjacent DirectX stages share register locations as well as semantics.
        foreach (SignatureElement input in inputs.Where(element => element.SystemValue == 0))
        {
            int available = outputs.Where(output =>
                string.Equals(output.SemanticName, input.SemanticName, StringComparison.OrdinalIgnoreCase)
                && output.SemanticIndex == input.SemanticIndex && output.ComponentType == input.ComponentType
                && output.Register == input.Register)
                .Aggregate(0, (mask, output) => mask | output.Mask);
            if ((available & input.Mask) != input.Mask)
            {
                return false;
            }
        }
        return true;
    }

    // Matches vertex and fragment programs by their shared keyword states.
    internal static List<(int Vertex, int Fragment)> Pair(IReadOnlyList<ProgramVariantMetadata> programs)
    {
        (ProgramVariantMetadata[] vertices, ProgramVariantMetadata[] fragments) = ValidatePairing(programs);
        List<(int Vertex, int Fragment)> pairs = new List<(int Vertex, int Fragment)>();
        HashSet<ProgramVariantMetadata> matched = new HashSet<ProgramVariantMetadata>();
        foreach (ProgramVariantMetadata vertex in vertices)
        {
            foreach (ProgramVariantMetadata fragment in fragments)
            {
                HashSet<string> shared = vertex.KeywordMask.Intersect(fragment.KeywordMask).ToHashSet();
                if (vertex.Keywords.Where(shared.Contains).ToHashSet().SetEquals(fragment.Keywords.Where(shared.Contains)))
                {
                    pairs.Add((vertex.BlobIndex, fragment.BlobIndex));
                    matched.Add(vertex);
                    matched.Add(fragment);
                }
            }
        }
        // A fragment-only keyword can reuse a vertex program; pairing is not 1:1.
        if (programs.Any(program => !matched.Contains(program)) || pairs.Count == 0)
        {
            throw new InvalidDataException("Serialized shader variants contain an unmatched stage.");
        }
        return pairs.Distinct().ToList();
    }

    // Rejects invalid indices and inconsistent keyword masks within a stage.
    private static void ValidateStage(ProgramVariantMetadata[] stage)
    {
        foreach (ProgramVariantMetadata program in stage)
        {
            if (program.BlobIndex < 0 || program.Keywords.Any(string.IsNullOrWhiteSpace)
                || program.KeywordMask.Any(string.IsNullOrWhiteSpace)
                || program.Keywords.Distinct(StringComparer.Ordinal).Count() != program.Keywords.Length
                || program.KeywordMask.Distinct(StringComparer.Ordinal).Count() != program.KeywordMask.Length
                || program.Keywords.Except(program.KeywordMask).Any()
                || !program.KeywordMask.ToHashSet(StringComparer.Ordinal).SetEquals(stage[0].KeywordMask))
            {
                throw new InvalidDataException("Serialized variants contain invalid or inconsistent stage metadata.");
            }
        }
    }

    // Validates vertex and fragment metadata before pairing.
    private static (ProgramVariantMetadata[] Vertices, ProgramVariantMetadata[] Fragments) ValidatePairing(IReadOnlyList<ProgramVariantMetadata> programs)
    {
        if (programs.Any(p => p.BlobIndex < 0 || p.Keywords.Any(string.IsNullOrWhiteSpace)
            || p.KeywordMask.Any(string.IsNullOrWhiteSpace)
            || p.Keywords.Distinct(StringComparer.Ordinal).Count() != p.Keywords.Length
            || p.KeywordMask.Distinct(StringComparer.Ordinal).Count() != p.KeywordMask.Length))
        {
            throw new InvalidDataException("Shader variants contain invalid indices or duplicate/empty keywords.");
        }
        if (programs.Any(p => p.Stage is not ("Vertex" or "Fragment")))
        {
            throw new InvalidDataException("Serialized variant pairing currently supports vertex/fragment stages only.");
        }
        ProgramVariantMetadata[] vertices = programs.Where(p => p.Stage == "Vertex").ToArray();
        ProgramVariantMetadata[] fragments = programs.Where(p => p.Stage == "Fragment").ToArray();
        if (programs.Any(p => p.Keywords.Except(p.KeywordMask).Any()))
        {
            throw new InvalidDataException("A shader variant enables a keyword outside its stage mask.");
        }
        foreach (ProgramVariantMetadata[] stage in new[] { vertices, fragments })
        {
            if (stage.Any(p => !p.KeywordMask.ToHashSet(StringComparer.Ordinal).SetEquals(stage[0].KeywordMask)))
            {
                throw new InvalidDataException("Shader variants have inconsistent keyword masks within a stage.");
            }
        }
        return (vertices, fragments);
    }
    // Compares the enabled state of keywords shared by adjacent stages.
    internal static bool StatesMatch(ProgramVariantMetadata previous, ProgramVariantMetadata candidate)
    {
        HashSet<string> shared = previous.KeywordMask.Intersect(candidate.KeywordMask).ToHashSet(StringComparer.Ordinal);
        return previous.Keywords.Where(shared.Contains).ToHashSet(StringComparer.Ordinal)
            .SetEquals(candidate.Keywords.Where(shared.Contains));
    }
}
