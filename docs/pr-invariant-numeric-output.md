# Use invariant numeric literals in shader output

ShaderLab properties, render-state offsets and HLSL constants must use decimal points regardless of the Windows locale. Preserve round-trip float precision. Regression cases exercise French and German cultures.

Validation: 53 C# tests and all four existing PicaVoxel extraction/decompilation tests pass.

This branch is based directly on upstream `1850608`; it does not include the other review branches. No proprietary fixtures or machine-specific paths are added.
