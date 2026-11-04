using Parser.DXBC.Metadata;
using Parser.DXBC.Chunks;

namespace Parser;

internal static class VariantPairing
{
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
            if ((available & input.Mask) != input.Mask) return false;
        }
        return true;
    }

    internal static List<(int Vertex, int Fragment)> Pair(IReadOnlyList<ProgramVariantMetadata> programs)
    {
        if (programs.Any(p => p.BlobIndex < 0 || p.Keywords.Any(string.IsNullOrWhiteSpace)
            || p.KeywordMask.Any(string.IsNullOrWhiteSpace)
            || p.Keywords.Distinct(StringComparer.Ordinal).Count() != p.Keywords.Length
            || p.KeywordMask.Distinct(StringComparer.Ordinal).Count() != p.KeywordMask.Length))
            throw new InvalidDataException("Shader variants contain invalid indices or duplicate/empty keywords.");
        if (programs.Any(p => p.Stage is not ("Vertex" or "Fragment")))
            throw new InvalidDataException("Serialized variant pairing currently supports vertex/fragment stages only.");
        ProgramVariantMetadata[] vertices = programs.Where(p => p.Stage == "Vertex").ToArray();
        ProgramVariantMetadata[] fragments = programs.Where(p => p.Stage == "Fragment").ToArray();
        if (programs.Any(p => p.Keywords.Except(p.KeywordMask).Any()))
            throw new InvalidDataException("A shader variant enables a keyword outside its stage mask.");
        foreach (ProgramVariantMetadata[] stage in new[] { vertices, fragments })
            if (stage.Any(p => !p.KeywordMask.ToHashSet(StringComparer.Ordinal).SetEquals(stage[0].KeywordMask)))
                throw new InvalidDataException("Shader variants have inconsistent keyword masks within a stage.");
        List<(int Vertex, int Fragment)> pairs = new List<(int Vertex, int Fragment)>();
        HashSet<ProgramVariantMetadata> matched = new HashSet<ProgramVariantMetadata>();
        foreach (ProgramVariantMetadata vertex in vertices)
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
        // A fragment-only keyword can reuse a vertex program; pairing is not 1:1.
        if (programs.Any(program => !matched.Contains(program)) || pairs.Count == 0)
            throw new InvalidDataException("Serialized shader variants contain an unmatched stage.");
        return pairs.Distinct().ToList();
    }
}
