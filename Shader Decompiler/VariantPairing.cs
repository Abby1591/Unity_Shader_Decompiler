using Parser.DXBC.Metadata;

namespace Parser;

internal static class VariantPairing
{
    internal static List<(int Vertex, int Fragment)> Pair(IReadOnlyList<ProgramVariantMetadata> programs)
    {
        if (programs.Any(p => p.Stage is not ("Vertex" or "Fragment")))
            throw new InvalidDataException("Serialized variant pairing currently supports vertex/fragment stages only.");
        ProgramVariantMetadata[] vertices = programs.Where(p => p.Stage == "Vertex").ToArray();
        ProgramVariantMetadata[] fragments = programs.Where(p => p.Stage == "Fragment").ToArray();
        if (programs.Any(p => p.Keywords.Except(p.KeywordMask).Any()))
            throw new InvalidDataException("A shader variant enables a keyword outside its stage mask.");
        List<(int Vertex, int Fragment)> pairs = new List<(int Vertex, int Fragment)>();
        foreach (ProgramVariantMetadata vertex in vertices)
            foreach (ProgramVariantMetadata fragment in fragments)
            {
                HashSet<string> shared = vertex.KeywordMask.Intersect(fragment.KeywordMask).ToHashSet();
                if (vertex.Keywords.Where(shared.Contains).ToHashSet().SetEquals(fragment.Keywords.Where(shared.Contains)))
                    pairs.Add((vertex.BlobIndex, fragment.BlobIndex));
            }
        // A fragment-only keyword can reuse a vertex program; pairing is not 1:1.
        if (vertices.Any(v => !pairs.Any(p => p.Vertex == v.BlobIndex)) ||
            fragments.Any(f => !pairs.Any(p => p.Fragment == f.BlobIndex)) || pairs.Count == 0)
            throw new InvalidDataException("Serialized shader variants contain an unmatched stage.");
        return pairs.Distinct().ToList();
    }
}
