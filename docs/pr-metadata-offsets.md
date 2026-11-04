# Accept AssetStudio and AssetRipper shader JSON schemas

Extraction fails when an export uses legacy `m_Index` offsets or different field/map encodings. Normalize both exporters at the input boundary, prefer `m_OffsetInConstantBuffer` when present, and fall back to `m_Index`. Reject missing/invalid offsets, conflicting aliases and duplicate map keys. Source JSON files remain unchanged.

Reproducible validation: ten generic Python tests, 51 baseline C# tests and all four checked-in PicaVoxel extraction/decompilation cases pass. The isolated C# suite uses en-US; upstream's fr-FR golden-output failure is addressed separately in #5. No existing assertions or generated references are changed.

Additional local validation used two external shaders exported from the same bundle with AssetStudioMod CLI v0.20.0 and AssetRipper. Their normalized metadata and decompressed blobs match. With the separate emitter fixes combined, all four exports also produced identical artifacts across exporters and passed native recompilation and finite interpreter comparisons with serialized constants. Those external fixtures are not distributed, so this additional check is not reproducible from the PR alone and does not prove GPU equivalence.
