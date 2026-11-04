# Accept AssetStudio and AssetRipper shader JSON schemas

Normalize the two exporters' field names, serialized maps, property defaults and render states at the JSON input boundary. Recover the ShaderLab name from ParsedForm when the object name is empty. Both metadata extraction and blob extraction use the same loader; the original JSON is never rewritten.

Read `m_OffsetInConstantBuffer` when present and legacy `m_Index` otherwise. AssetRipper's `Pass002_RenameSubnodes` explicitly normalizes this rename. Both layout readers reject invalid or missing offsets instead of inventing zero. Conflicting aliases and duplicate map keys also fail explicitly.

Validation: ten generic Python tests and all four existing PicaVoxel extraction/decompilation tests pass. Two additional local shaders were exported directly from the same game bundle with AssetStudioMod CLI v0.20.0 and AssetRipper: decompressed blobs and extracted metadata match across exporters. Those external fixtures are not included in this PR.

All 51 baseline C# tests pass with an en-US default culture. The unchanged golden test fails under fr-FR on upstream because of decimal separators; the numeric-formatting PR fixes that independently. No existing assertions or golden files are changed here.
