# Corpus decompile gap audit

Measured on `master` (`9bee586`, 2026-11-14; decompiler code unchanged since
`16fadea`) against the 48 corpus shaders in `shaders_json/` and their original
sources in `tests/Sources/`. On this commit the gates are green:

| Runner | Result |
|---|---|
| `tests/e2e/test_faithfulness.py` | 48/48 |
| `tests/e2e/test_source_fidelity.py` | 48/48 |
| `tests/e2e/test_corpus_shaders.py` | 48/48 |
| `dotnet test --filter "Category!=D3D"` | 126/126 |

Everything below is outside what those runners assert. Counts are shader
instances, not lines of code.

## 1. Pass bodies are not mapped to their ShaderLab passes

21 authored passes in 6 shaders have no `HLSLPROGRAM` body. Including the two
GrabPass shells (expected empty), 23 pass blocks are empty:

| Shader | Source passes | Output passes | With HLSL | Missing |
|---|---:|---:|---:|---:|
| `Corpus/02 Render States` | 8 | 8 | 1 | 7 |
| `Corpus/03 Stencil` | 8 | 8 | 1 | 7 |
| `Corpus/33 Transparency` | 5 | 5 | 1 | 4 |
| `Corpus/14 Shadow Depth Meta Motion` | 5 | 4 | 3 | 1 (+ META dropped) |
| `Corpus/16 UsePass Consumer` | 2 | 2 | 1 | 1 |
| `Corpus/44 ShaderLab Misc` | 3 | 3 | 2 | 1 |

Cause: `BuildVariantPasses` (`src/UnityShaderDecompiler.Core/Decompiler.cs`)
groups decoded subprograms by stage order and pairs one vertex with the first
signature-compatible fragment. It never reuses a vertex for a second fragment
and never consults the per-pass `m_ProgVertex`/`m_ProgFragment` /
`m_PlayerSubPrograms` references that Unity serializes. Consequently:

- `Corpus/33` logs `1 verts x 4 frags => 1 pass`; the other 3 fragments are
  dropped without a log line.
- `Corpus/02` logs `Pass group 1: 1 verts x 1 frags produced no renderable
  variant (skipped)`; one whole vertex+fragment pair is lost.
- `Corpus/14` drops the META pass entirely (no DXBC program is attached to it)
  and leaves MOTION_VECTORS without a body.
- `Corpus/16` and `Corpus/44` inline the used pass but leave the authored
  overlay/transparent pass empty.

Impact: pass indices and render state survive, so the output looks complete,
but reimporting it leaves 21 passes with no program. Those passes render
nothing.

Fix: build the pass-to-candidate association from the serialized per-pass
subprogram references (Stage 0 already walks `m_Prog*` for constant buffers)
and reuse the referenced candidate for every pass instead of positional
grouping. This is the highest-value remaining fix.

## 2. `[Property]` render-state references become literal placeholders

Ten render-state lines use material property references:

| Shader | Lines |
|---|---|
| `Corpus/03 Stencil` | `Ref [_StencilRef]`, `ReadMask [_StencilReadMask]`, `WriteMask [_StencilWriteMask]` |
| `Corpus/30 Sprite UI` | `Ref [_Stencil]`, `Comp [_StencilComp]`, `Pass [_StencilOp]`, `ReadMask [_StencilReadMask]`, `WriteMask [_StencilWriteMask]`, `ZTest [unity_GUIZTestMode]`, `ColorMask [_ColorMask]` |

The player build serializes the unresolved value, so output emits `Ref 0`,
`ReadMask 0`, `WriteMask 0`, `Comp Disabled`, `ColorMask 0`, and
`ZTest Disabled`. Sprite UI therefore writes no color and skips the stencil
test at runtime.

This value is not recoverable from the blob in general. Options: emit a
warning comment when a state field is zero/default while the ShaderLab source
used a property reference, or special-case the Unity built-ins
(`unity_GUIZTestMode`, `_ColorMask`, `_Stencil*`) that the decompiler knows
about. The source-fidelity runner deliberately skips these fields, so it
cannot flag this.

## 3. GrabPass is flattened and its texture is renamed

`Corpus/15 Grab Pass` and `Corpus/37 Water` emit a plain pass where the source
has `GrabPass { "_GrabTexture" }` / `{ "_WaterGrab" }`. Output has no
`GrabPass` block, the grab texture becomes `Texture2D t1`, and the fragment
reads `t1.Sample(...)` instead of `tex2Dproj(_GrabTexture, ...)`. The pass
samples an unbound texture, so the refraction effect is lost at runtime.

Cause: the emitter prints pass state and decoded programs only; the
`GrabPass` directive and its texture name are not part of the render state it
consumes. Texture names for non-property textures are not in metadata either,
so `tN` is the only name available.

Fix: recognise the program-less, depth-disabled pass that Unity emits for a
GrabPass, emit `GrabPass { "_GrabTexture" }` (Unity's default name when the
source omits it), and rename the corresponding `tN` resource to that name.
The custom name (`_WaterGrab`) is not recoverable; use the default name or a
documented placeholder.

## 4. Keyword variants are collapsed to one base variant

Sources contain 38 `#pragma multi_compile*` lines (including 7
`multi_compile_instancing`) and 2 `#pragma shader_feature` lines across 16
shaders. Output contains zero. `BuildVariantPasses` picks the variant with the
fewest keywords, emits its body, and records the rest in a comment:

```hlsl
// Folded keyword variants (base state emitted): ETC1_EXTERNAL_ALPHA, PIXELSNAP_ON
```

Impact: every non-base permutation is missing. `Corpus/30 Sprite UI`,
`Corpus/27 Keywords`, `Corpus/31 Particles` and the other 13 keyword shaders
do not reproduce their variant behaviour. The keyword names themselves are
recoverable from the subprogram data, so this is an emission gap, not data
loss.

Fix: emit `#pragma multi_compile`/`#pragma shader_feature` lines from the
serialized keyword sets, and either emit one pass per keyword set (matching
Unity's variant expansion) or wrap variant bodies in `#if` blocks. This
interacts with item 1: both need the pass-to-subprogram association.

## 5. Surface-shader reconstruction matches 0 of 8

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

## 6. Stage entry points, `#pragma target`, and compute

- `Corpus/19 Hull Domain` emits hull and domain functions but no
  `#pragma hull`/`#pragma domain`, `[domain(...)]`, `[partitioning(...)]`,
  `[outputtopology(...)]`, or `[patchconstantfunc(...)]`. The block is not a
  valid Unity hull/domain shader.
- No corpus shader is a compute shader, so `#pragma kernel` and
  `[numthreads(...)]` are untested. The printer has a compute path but nothing
  exercises it.
- All 48 sources have `#pragma target` (75 lines total: 3.0 through 5.0);
  output has none. The emitted HLSL uses SM4+ syntax (`Texture2D`,
  `SamplerState`, `.Sample`, structured buffers), so reimporting without a
  target pragma may compile for an older profile or fail. The target is not in
  the serialized metadata, so it must be inferred from the constructs used.
- 75 `#pragma only_renderers d3d11` lines in the sources are not emitted
  either, so the output no longer restricts itself to D3D11.

Cause: hull/domain/compute functions are printed without their ShaderLab
attributes (`HlslPrettyPrinter.cs:225`, comment: "not wired yet"). Nothing
tracks the minimum shader model required by the emitted code.

## 7. Build-stripped or unemitted metadata

These facts are not present in a player build, or are present but not printed.
Counts are from the 48 sources versus the 48 outputs:

| Fact | Source | Output | Notes |
|---|---:|---:|---|
| Pass `Name "..."` | 66 | 0 | `m_Name` serializes as `""` |
| Named texture defaults (`"white"`, `"black"`, `"bump"`) | 79 | 0 | all emitted as `"" {}` |
| Property attributes | 16 standalone lines | 22 | `Header`, `Space`, `Toggle`, `ToggleOff`, `Enum`, `PowerSlider`, `IntRange` recover; `PerRendererData` and `HideInInspector` do not |
| `LOD` | 11 explicit | 49 | explicit values survive; unset LOD serializes `0` and is emitted as `LOD 0` (38 outputs) |
| `Fog` | 0 in corpus | 0 | `fogMode` is parsed but never printed |
| Separate front/back Stencil | 0 in corpus | 0 | only the single-face form is emitted (`shortcut:` at `HlslPrettyPrinter.cs:274`) |
| `Category { }` wrappers | 1 (`Corpus/44`) | 0 | flattened into SubShaders |

The source-fidelity runner skips LOD, pass names, texture defaults, property
attributes, and `[Property]` refs. Its docstring says LOD is "serialized as
0", which is only true when the source does not set it; 11 subshaders carry
real LOD values.

## 8. Emitter fallbacks and latent paths

These are marked `shortcut:`/`TODO` in the code. None are hit by the current
corpus (outputs contain no `TODO` comments today), so they are latent rather
than observed failures:

| Location | Gap |
|---|---|
| `Decompiler.cs:692` | A variable declared in two cbuffers keeps the lowest slot's name; reads that resolve to the duplicate use the kept name and may read the wrong buffer value. |
| `HlslAstBuilder.cs:220` | `SV_GSInstanceID` is not routed out of the per-vertex array (only `SV_PrimitiveID` is). |
| `HlslAstBuilder.cs:403` | Structured buffer element type is guessed: `float4` for stride 16, `uint` otherwise. |
| `HlslPrettyPrinter.cs:94,103` | Range bounds and unknown property kinds fall back to `Float /* TODO ... */`. |
| `HlslPrettyPrinter.cs:799` | Unrecognised macros emit `#define name(v) /* TODO ... */ (v)`. |
| `HlslPrettyPrinter.Registers.cs:142` | Unhandled IR nodes emit `// TODO: unhandled IR node` (`hs_fork_phase`, `emitStream`/`cutStream`, ...). |
| `HlslPrettyPrinter.Registers.cs:1125` | `bfe` sign-extend shift is UB for width 0 or 32 (DXBC does not emit it today). |
| `HlslPrettyPrinter.Registers.cs:1254` | Abs-fold guard only covers `max(a, -a)`; other spellings can fail with X8000. |
| `HlslPrettyPrinter.Registers.cs:1385,1397,1403,1526` | Unmapped intrinsics/texture ops (`DistanceVector`, `MaskedSumOfAbsoluteDifferences`, `Eval*`, unknown texture ops) and empty matrices fall back to `TODO` text. |
| `HlslPrettyPrinter.Registers.cs:1422` | ResInfo maps 2D/3D/cube; multisampled targets omit the mip parameter and exotic resource types fall back to 3. |
| `HlslSurfaceShaderRecognizer.cs:186` | Surface `Input` struct recovers only vertex colour, not `uv_*` fields. |

## 9. Platform coverage

Only DX11 SM4/5 subprograms are decoded. Everything else is logged and
skipped (`Decompiler.cs:196,329`):

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

## 10. Test blind spots

- `test_faithfulness.py` recompiles every `HLSLPROGRAM` block and compares
  input/output signatures plus metadata. It does not compare instructions or
  rendered results, so a semantically wrong body still passes.
- `test_source_fidelity.py` compares name, properties (name/description/type/
  numeric default), fallback, SubShader count/tags, pass count, and per-pass
  render state. It skips LOD, pass names, texture defaults, property
  attributes, `[Property]` state refs, surface-shader structure, and all HLSL
  text.
- No corpus shader covers compute, hull/domain attributes, separate stencil
  faces, `Fog`, `SetTexture`, MRT blend targets, or a GrabPass whose name
  differs from `_GrabTexture`.
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

# Count empty passes
python - <<'PY'
import re, pathlib
for p in sorted(pathlib.Path("src/UnityShaderDecompiler.Cli/Output").glob("*.shader")):
    text = p.read_text(encoding="utf-8")
    passes = len(re.findall(r"(?m)^\s{8}Pass\b", text))
    hlsl = text.count("HLSLPROGRAM")
    if passes != hlsl:
        print(f"{p.stem}: {passes} passes, {hlsl} HLSL blocks")
PY
```

## Suggested fix order

1. Pass-to-program mapping (item 1) — the only gap that removes authored code.
2. `[Property]` render-state refs (item 2) — two corpus shaders render wrong.
3. GrabPass (item 3) — two shaders lose their effect.
4. Keyword variants (item 4) — 16 shaders lose non-base behaviour.
5. `#pragma target`/hull attributes (item 6) — needed for re-import.
6. Surface reconstruction (item 5) — quality of life, not visual correctness.
