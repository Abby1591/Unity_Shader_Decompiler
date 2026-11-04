# Runtime keyword regression

The native fixture decompiles six synthetic DXBC programs into two ShaderLab
passes. The Unity check reads nine GPU results, including material keyword
changes and global overrides of global versus local keywords. No game assets
are needed. Use Windows, Direct3D 11 and Unity **6000.0.75f1** (Built-in pipeline).

With `UNITY_CLI` pointing to the Unity CLI executable and `TEST_PROJECT` to a
disposable project created with that Editor version:

```bash
export SHADER_RUNTIME_TEST_OUTPUT="$TEST_PROJECT/Assets"
dotnet test UnityShaderDecompiler.sln -c Release --filter FullyQualifiedName~RuntimeVariantEmissionTests
mkdir -p "$TEST_PROJECT/Assets/Editor"
cp tests/UnityRuntime/*.cs "$TEST_PROJECT/Assets/Editor/"
"$UNITY_CLI" run "$TEST_PROJECT" --editor-version 6000.0.75f1 --timeout 180 --format json -- -executeMethod RuntimeKeywordChecks.Run -force-d3d11
```

Require a successful CLI exit and `runtime-keyword-results.json` with
`passed: true` and `cases: 9` in the project directory. These checks validate
keyword selection, pass order and scope; they do not prove arbitrary shader
arithmetic or resource bindings equivalent to an original application.

To compile every combination of other generated shaders, copy each `.shader`
and matching `.variants.json` under a project asset folder, copy
`ShaderVariantChecks.cs` and `ShaderVariant*Data.cs` into `Assets/Editor`, and set
`SHADER_VARIANT_DIRECTORY` to that folder (for example `Assets/Generated`).
Run the same CLI command with `-executeMethod ShaderVariantChecks.Run`.
It checks the shader hash, pass count and nonempty compiled bytecode for both
stages of every manifest entry. Results go to `shader-variant-results.json`.
