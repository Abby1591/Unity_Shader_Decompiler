# Accept both serialized constant-buffer offset names

Read `m_OffsetInConstantBuffer` when present and the legacy `m_Index` otherwise. AssetRipper's `Pass002_RenameSubnodes` explicitly normalizes that rename for vector, matrix and struct parameters. Both layout readers now reject absent, negative, unaligned or non-integer offsets instead of inventing zero.

Validation: five Python regression tests and all four existing PicaVoxel extraction/decompilation tests pass. All 51 baseline C# tests pass with an en-US default culture. Under the machine's fr-FR default, the unchanged golden test fails on decimal separators; that pre-existing defect is addressed separately by the numeric-formatting PR. No existing assertions or golden files are changed here.
