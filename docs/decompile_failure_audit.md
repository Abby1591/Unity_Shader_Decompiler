# Corpus decompile gap audit

Measured on `master` (2026-11-15) against the 48 corpus shaders in
`shaders_json/` and their original sources in `tests/Sources/`. On this commit
the gates are green:

| Runner | Result |
|---|---|
| `tests/e2e/test_faithfulness.py` | 48/48 |
| `tests/e2e/test_source_fidelity.py` | 48/48 |
| `tests/e2e/test_corpus_shaders.py` | 48/48 |
| `dotnet test --filter "Category!=D3D"` | 126/126 |

Everything below is outside what those runners assert. Counts are shader
instances, not lines of code.

## 1. Keyword variant bodies are not reconstructed

Sources contain 38 `#pragma multi_compile*` lines (including 7
`multi_compile_instancing`) and 2 `#pragma shader_feature` lines across 16
shaders. The keyword names now survive as one `#pragma multi_compile` line per
pass, but every variant compiles the base variant's body, and the pragma is a
single group rather than the source's groups:

```hlsl
// Folded keyword variants (base state emitted): ETC1_EXTERNAL_ALPHA, PIXELSNAP_ON
#pragma multi_compile _ ETC1_EXTERNAL_ALPHA PIXELSNAP_ON
```

Impact: a re-imported shader keeps its keyword interface (material keyword
toggles compile), but every non-base permutation still renders the base
behaviour. `Corpus/30 Sprite UI`, `Corpus/27 Keywords`, `Corpus/31 Particles`
and the other 13 keyword shaders differ from their source only in the variant
bodies. Whether a keyword came from `shader_feature`, `*_local`, or a built-in
group (`multi_compile_fwdbase`, `multi_compile_fog`, ...) is not recoverable
from the blob.

Fix (remaining): emit one body per compiled variant, each under the `#if`
condition for its keyword set. The variant list per pass already exists; the
work is emitting several bodies per pass instead of one.

## 2. Surface-shader reconstruction matches 0 of 8

`HlslSurfaceShaderRecognizer` runs by default and is meant to rewrite a
compiled lit pass back to `#pragma surface surf <model>`. It returns `null`
for all 8 surface shaders in the corpus (`05`, `06`, `07`, `08`, `09`, `10`,
`11`, `36`), so they remain expanded into 2-4 ForwardBase/ForwardAdd/Deferred/
ShadowCaster/Meta passes with no `#pragma surface` and no `surf()` function.

Cause: recognition is a set of regex fingerprints for Unity's Standard/Lambert
lighting boilerplate (GGX constants, `_LightColor0` chains, `sv_Target0`
writes). None of the corpus fragments match those fingerprints. The Input
reconstruction also only recovers vertex colour; `uv_*` fields are a TODO
(`HlslSurfaceShaderRecognizer.cs:186`).

Impact: output is valid ShaderLab but is not the source form; pass count and
structure differ. `test_source_fidelity.py` skips surface pass structure for
this reason.

## 3. Hull/domain attributes and compute are not emitted

- `Corpus/19 Hull Domain` emits hull and domain functions but no
  `#pragma hull`/`#pragma domain`, `[domain(...)]`, `[partitioning(...)]`,
  `[outputtopology(...)]`, or `[patchconstantfunc(...)]`. The block is not a
  valid Unity hull/domain shader. The hull body is also only partly
  decompiled: `hs_fork_phase` is unhandled and the patch-constant function is
  missing from the output.
- No corpus shader is a compute shader, so `#pragma kernel` and
  `[numthreads(...)]` are untested. The printer has a compute path but nothing
  exercises it.
- 75 `#pragma only_renderers d3d11` lines in the sources are not emitted
  either, so the output no longer restricts itself to D3D11.

Cause: hull/domain/compute functions are printed without their ShaderLab
attributes (`HlslPrettyPrinter.cs:262`, comment: "not wired yet").
Domain/partitioning/outputtopology are compile directives that are not in the
bytecode, so they can only be inferred from the signatures or defaulted.

## 4. Build-stripped or unemitted metadata

These facts are not present in a player build, or are present but not printed.
Counts are from the 48 sources versus the 48 outputs:

| Fact | Source | Output | Notes |
|---|---:|---:|---|
| Pass `Name "..."` | 66 | 0 | `m_Name` serializes as `""` |
| Named texture defaults (`"white"`, `"black"`, `"bump"`) | 79 | 0 | all emitted as `"" {}` |
| Property attributes | 16 standalone lines | 22 | `Header`, `Space`, `Toggle`, `ToggleOff`, `Enum`, `PowerSlider`, `IntRange` recover; `PerRendererData` and `HideInInspector` do not |
| `LOD` | 11 explicit | 49 | explicit values survive; unset LOD serializes `0` and is emitted as `LOD 0` (38 outputs) |
| `Fog` | 0 in corpus | 0 | `fogMode` is parsed but never printed |
| Separate front/back Stencil | 0 in corpus | 0 | only the single-face form is emitted (`shortcut:` at `HlslPrettyPrinter.cs:335`) |
| `Category { }` wrappers | 1 (`Corpus/44`) | 0 | flattened into SubShaders |

The source-fidelity runner skips LOD, pass names, texture defaults, property
attributes, and `[Property]` refs. Its docstring says LOD is "serialized as
0", which is only true when the source does not set it; 11 subshaders carry
real LOD values.

## 5. Emitter fallbacks and latent paths

These are marked `shortcut:`/`TODO` in the code. None are hit by the current
corpus (outputs contain no `TODO` comments today), so they are latent rather
than observed failures:

| Location | Gap |
|---|---|
| `Decompiler.cs:636` | A grab texture is matched to the lowest-slot anonymous `tN` resource; a pass binding several anonymous textures can pick the wrong one. |
| `Decompiler.cs:721` | `#pragma target` is inferred from the program shader model (SM4.0→3.5, SM5.0→4.5, tessellation→5.0), not the source's value. |
| `Decompiler.cs:813` | A variable declared in two cbuffers keeps the lowest slot's name; reads that resolve to the duplicate use the kept name and may read the wrong buffer value. |
| `HlslAstBuilder.cs:153` | Hull/domain patch inputs are flattened to per-element `float4` parameters instead of `OutputPatch<T, N>`. |
| `HlslAstBuilder.cs:252` | `SV_GSInstanceID` is not routed out of the per-vertex array (only `SV_PrimitiveID` is). |
| `HlslAstBuilder.cs:449` | Structured buffer element type is guessed: `float4` for stride 16, `uint` otherwise. |
| `HlslPrettyPrinter.cs:221` | Folded keywords become one `#pragma multi_compile` group per pass; `shader_feature`/`_local` and the original grouping are lost. |
| `HlslPrettyPrinter.cs:94,103` | Range bounds and unknown property kinds fall back to `Float /* TODO ... */`. |
| `HlslPrettyPrinter.cs:884` | Unrecognised macros emit `#define name(v) /* TODO ... */ (v)`. |
| `HlslPrettyPrinter.Registers.cs:142` | Unhandled IR nodes emit `// TODO: unhandled IR node` (`hs_fork_phase`, `emitStream`/`cutStream`, ...). |
| `HlslPrettyPrinter.Registers.cs:1131` | `bfe` sign-extend shift is UB for width 0 or 32 (DXBC does not emit it today). |
| `HlslPrettyPrinter.Registers.cs:1260` | Abs-fold guard only covers `max(a, -a)`; other spellings can fail with X8000. |
| `HlslPrettyPrinter.Registers.cs:1391,1403,1409,1532` | Unmapped intrinsics/texture ops (`DistanceVector`, `MaskedSumOfAbsoluteDifferences`, `Eval*`, unknown texture ops) and empty matrices fall back to `TODO` text. |
| `HlslPrettyPrinter.Registers.cs:1428` | ResInfo maps 2D/3D/cube; multisampled targets omit the mip parameter and exotic resource types fall back to 3. |
| `HlslSurfaceShaderRecognizer.cs:186` | Surface `Input` struct recovers only vertex colour, not `uv_*` fields. |

## 6. Platform coverage

Only DX11 SM4/5 subprograms are decoded. Everything else is logged and
skipped (`Decompiler.cs:196`):

```
SubProgram Type not supported: GLES3
SubProgram Type not supported: GLES31AEP
SubProgram Type not supported: GLES31
SubProgram Type not supported: GLLegacy
```

Every corpus shader carries GLES subprograms in addition to its D3D11 ones,
so this is visible in normal runs. It is a scope limitation (the project is a
DXBC decompiler), not a regression, but it means platform-specific shader
code is never emitted.

## 7. Test blind spots

- `test_faithfulness.py` recompiles every `HLSLPROGRAM` block and compares
  input/output signatures plus metadata. It does not compare instructions or
  rendered results, so a semantically wrong body still passes.
- `test_source_fidelity.py` compares name, properties (name/description/type/
  numeric default), fallback, SubShader count/tags, pass count, and per-pass
  render state. It skips LOD, pass names, texture defaults, property
  attributes, `[Property]` state refs, surface-shader structure, and all HLSL
  text.
- No corpus shader covers compute, hull/domain attributes, separate stencil
  faces, `Fog`, `SetTexture`, or MRT blend targets.
- The xUnit golden test compares only the 8 fixtures in
  `tests/UnityShaderDecompiler.Tests/GoldenMetadataTests.cs`; the other 40
  samples are refreshed manually.

## Reproduction

```bash
# Current gate results
python tests/e2e/test_source_fidelity.py
python tests/e2e/test_faithfulness.py
python tests/e2e/test_corpus_shaders.py

# Inspect one shader's pass grouping
python Extract.py shaders_json/Corpus_02\ Render\ States.json --out-dir Output
dotnet run --project "src/UnityShaderDecompiler.Cli/UnityShaderDecompiler.Cli.csproj" -- "Output/Corpus_02 Render States"

# Count passes with no body
python - <<'PY'
import re, pathlib
mark = re.compile(r"(?m)^\s{8}(Pass|GrabPass|UsePass)\b")
for p in sorted(pathlib.Path("src/UnityShaderDecompiler.Cli/Output").glob("*.shader")):
    text = p.read_text(encoding="utf-8")
    hits = list(mark.finditer(text))
    for i, m in enumerate(hits):
        end = hits[i + 1].start() if i + 1 < len(hits) else len(text)
        if m.group(1) == "Pass" and "HLSLPROGRAM" not in text[m.end():end]:
            print(p.stem)
PY
```

At the time of writing this prints nothing: every emitted `Pass` has a body.

## Suggested fix order

1. Keyword variant bodies (item 1) — 16 shaders lose non-base behaviour.
2. Hull/domain attributes (item 3) — `Corpus/19` is not a valid hull shader.
3. Surface reconstruction (item 2) — quality of life, not visual correctness.
