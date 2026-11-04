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

The test checks fixture integrity, D3D11-only inputs, extraction, CLI completion, absence of swallowed blob errors, and output shader identity/stages. It does **not** establish GPU rendering equivalence, complete runtime keyword selection, or successful recompilation of the generated HLSL.

On upstream `417f26b`, all three extraction cases fail because the JSON contains `compressedBlob`, while the extractor requires `m_CompressedBlob`. PR #6 addresses schema compatibility. A diagnostic run using the compatible extractor also exposes `No DXBC: Unknown shader blob format` on upstream's Unity 6 blob reader. These failures are intentional regression signals, not skipped tests. Keep this PR in draft until the production fixes are available and the full cases pass.
