## Improvement

Add three BSD-licensed VolumetricLights shaders as an offline end-to-end regression corpus, with pinned source provenance, Unity 6000.0.75f1 D3D11 exports, migration snapshots, and integrity hashes. No production behavior changes.

## Validation / blockers

- All three input shaders compile and the asset bundle builds with Unity CLI 6000.0.75f1 / D3D11.
- Fixture integrity passes; all three extraction tests currently fail on upstream `417f26b` (`m_CompressedBlob` schema mismatch). Requires the schema support from #6.
- A diagnostic extraction with schema support reveals additional swallowed Unity 6 blob-reading errors in upstream. Keep this PR in draft; do not relax the assertions to accept partial output.
- These tests do not prove rendered equivalence or runtime keyword selection.
