## Improvement

Add three BSD-licensed VolumetricLights shaders as an offline regression corpus, with pinned source provenance, Unity 6000.0.75f1 D3D11 exports, migration snapshots, and integrity hashes. No production behavior changes.

## Dependency / merge order

**Depends on #6. Merge #6 before #14.** No other correction PR is required for the current assertions. Keep this PR in draft until its base includes #6.

## Validation

The same seven tests were run against:

- Upstream `417f26b`: three shader cases fail at extraction (`m_CompressedBlob`); four integrity/guard tests pass.
- #6 alone (`9677441`): **7/7 pass**.
- All twelve correction PRs integrated with upstream `417f26b`: **7/7 pass**.

The tests require every serialized DirectX code reference to produce a function of the expected stage and a DXBC artifact: **13 BilateralBlur + 2 BlitAdd + 184 VolumetricLight = 199 programs**. They also check final shader identity and vertex/fragment pragmas. Negative tests verify missing programs cannot pass.

The previous blanket `No DXBC:` assertion was incorrect: these D3D11-only exports also contain parameter records, whose indices are separate from code references. Reading those records as program headers can produce misleading GLES labels. The corrected assertions use the original JSON code references, not those labels or a blanket log filter.

All three input shaders compile with Unity CLI 6000.0.75f1 / D3D11. These tests do not verify compilation of generated HLSL, runtime keyword selection, or rendered equivalence, and do not demonstrate a dependency on the other correction PRs. See [fixture documentation](tests/Fixtures/VolumetricLights/README.md) for the `USD_REPO_ROOT` before/after procedure.
