namespace UnityShaderDecompiler.Core;

// Associates an enabled keyword state with its vertex and fragment programs.
internal sealed record RuntimeVariantState(int Vertex, int Fragment, string[] Keywords);
