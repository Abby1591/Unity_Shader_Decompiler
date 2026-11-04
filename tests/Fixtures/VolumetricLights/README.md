# VolumetricLights regression corpus

Three shaders from [SlightlyMad/VolumetricLights](https://github.com/SlightlyMad/VolumetricLights/tree/d20b6f9a47ae857e1d313b147db2df3ef44b9196), distributed under the included BSD-3-Clause license. Unity Standard Assets are excluded.

- `Source/`: unchanged upstream sources.
- `Imported/`: sources after Unity 6000.0.75f1's automatic shader migration. This migration replaces legacy Unity 5 identifiers and matrix expressions before compilation; it is not a decompiler output repair.
- `Json/`: unmodified AssetStudioModCLI 0.20.0.0 JSON dumps, renamed using their parsed shader names.
- `manifest.json`: provenance and SHA-256 hashes of all three representations.

## Regeneration

Use Windows, Unity CLI, Unity **6000.0.75f1**, a disposable Built-in project, and [AssetStudioModCLI 0.20.0](https://github.com/aelurum/AssetStudioMod/releases/tag/v0.20.0). Paths below are relative to this directory; executable locations may be supplied through PATH.

1. Create the project with `unity projects create VolumetricLightFixtures --path . --editor-version 6000.0.75f1 --template com.unity.template.3d --no-cloud --non-interactive`.
2. Copy `Source/*.shader` into its `Assets/VolumetricLights/` and `BuildFixtures.cs` into `Assets/Editor/`.
3. Run `unity run ./VolumetricLightFixtures --editor-version 6000.0.75f1 --timeout 1800 --no-tail -- -executeMethod BuildFixtures.Run -force-d3d11`. Require exit code zero and `fixture-build.json` with `passed: true`. The build includes all three shaders, uses D3D11 only, and rejects shader compilation errors.
4. Review the imported source changes against `Imported/`. Do not disable migration: the original Unity 5 `_Object2World` identifier does not compile in this Editor.
5. Run `AssetStudioModCLI ./VolumetricLightFixtures/FixtureBundle/volumetriclights -m jsonDump -t shader -g none -f assetName -o ./exported`. Require exactly three exports; map their `m_ParsedForm.m_Name` to the matching filenames in `Json/`.
6. Review source/export differences and update the SHA-256 manifest explicitly. Never patch generated decompiled shaders.

## Tests and current limitations

From the repository root:

```sh
dotnet build src/UnityShaderDecompiler.Cli/UnityShaderDecompiler.Cli.csproj -c Release
python tests/e2e/test_volumetric_lights.py
```

The tests read expected vertex/fragment code indices directly from the original JSON, require a collected function with the matching stage for every index, and verify each saved DXBC artifact. Parameter-record indices are not code references: interpreting them as program headers can print misleading GLES labels and `No DXBC:` diagnostics. Such diagnostics alone do not establish a lost DirectX program. A missing expected program always fails.

Coverage: BilateralBlur **13** programs (5 vertex / 8 fragment), BlitAdd **2** (1 / 1), and VolumetricLight **184** (76 / 108): **199 unique programs across the three fixtures**. These checks establish extraction and per-program decompilation coverage, not successful recompilation of generated HLSL, complete runtime keyword selection, or GPU rendering equivalence.

## Dependency and before/after validation

**Merge [PR #6](https://github.com/Abby1591/Unity_Shader_Decompiler/pull/6) before [PR #14](https://github.com/Abby1591/Unity_Shader_Decompiler/pull/14).** No other PR is required for these assertions.

| Implementation tested with the same corpus/tests | Result |
| --- | --- |
| Upstream `417f26b` | Three shader tests fail at extraction (`m_CompressedBlob`); four integrity/guard tests pass |
| PR #6 alone, `9677441` | All seven tests pass; all 199 expected DirectX programs are collected |
| All twelve correction PRs integrated with upstream `417f26b` | All seven tests pass; all 199 expected DirectX programs are collected |

To repeat the comparison without copying or editing fixtures, build the Release CLI in each target checkout, then run this test file with `USD_REPO_ROOT` set to that checkout. For example, from this PR's repository root:

```bash
USD_REPO_ROOT=../decompiler-under-test python tests/e2e/test_volumetric_lights.py
```

Keep #14 in draft until #6 is integrated into its base. Passing this corpus does not independently prove the necessity or correctness of the other correction PRs.
