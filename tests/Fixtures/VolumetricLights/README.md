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

The tests require strict conversion with `--fail-on-error`, `--no-fuse-temps`
and `--restore-keyword-variants`. They verify:

- Every DirectX vertex/fragment code reference is collected and saved as DXBC.
- The generated shader preserves the original pass count and order.
- The hash-bound manifest contains exactly the keyword/program pairs derived
  independently from the original JSON, without missing or duplicate states.
- Every manifest variant recompiles through the native D3D compiler.

Run the independent oracle guards with:

```sh
python tests/e2e/test_shader_variant_contract.py
```

Coverage remains 199 unique programs across the three fixtures. Parameter-record
indices are not code references. Successful extraction alone is insufficient:
a strict conversion error fails the shader test, even when all programs were found.

## Dependencies and remaining validation

These stronger checks require PR #6 (input schema), PR #9 (runtime variants and
manifest verification), PR #8 (strict resource validation), and the separate
code-generation corrections. Keep this PR in draft while its prerequisites
are missing. The previous seven passing tests checked extraction only; that
historical result does not apply to this stronger gate.

The current parameter extractor does not recover all resource bindings from
serialized parameter records. Strict conversion must fail until that extraction
is implemented. Do not weaken these checks or repair the generated shaders.

Set `USD_REPO_ROOT` to a source checkout under test and build its Release CLI
before running the corpus. Set `USD_CORPUS_OUTPUT` to a fresh directory outside
the repository to retain successful artifacts for Unity validation. Existing
output directories are rejected to avoid reusing stale shaders.

After the offline gate passes, use the `tests/UnityRuntime` import/variant checks
from PR #9 in a disposable Built-in project with Unity CLI, Editor **6000.0.75f1**,
and Direct3D 11. Require an error-free import and compilation of every manifest
entry. Then compare original and regenerated shaders with identical scene,
material, camera, texture and keyword inputs. The offline checks do not establish
resource-binding or image equivalence in Unity. That rendering validation remains
blocked until reconstruction succeeds; no black-screen case is considered fixed.
