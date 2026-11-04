namespace UnityShaderDecompiler.Core;

// Describes one vertex/fragment combination for native compilation.
internal sealed record RuntimeCompilationCase(int Pass, int Variant, string Hlsl,
    int Vertex, int Fragment, string VertexProfile, string FragmentProfile);
