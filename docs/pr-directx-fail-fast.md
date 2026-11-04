# Propagate DirectX subprogram decompilation failures

A malformed DirectX program was logged as "No DXBC" and omitted from an apparently successful export. Propagate the failure with the program index and stage, retaining its original cause. A synthetic malformed program verifies the pipeline fails before writing a shader.

Validation: 53 C# tests and all four existing PicaVoxel extraction/decompilation tests pass. C# tests use an en-US default culture; the upstream fr-FR golden-output failure is addressed independently by the numeric-formatting PR.

This branch is based directly on upstream `1850608`; it does not include the other review branches. No proprietary fixtures or machine-specific paths are added.
