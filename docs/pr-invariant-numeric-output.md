# Use invariant numeric literals in shader output

Shader output used the current locale, producing invalid literals such as `0,5` under fr-FR. Emit `0.5` consistently and retain round-trip precision for floats. Locale tests cover French and German formatting.

Validation: 53 C# tests and all four existing PicaVoxel extraction/decompilation tests pass.

Upstream sync: merged `417f26b` (Core/Cli split and namespace rename). Adapted regression tests to the new layout and shared DXBC compiler; no test assertions were relaxed.
