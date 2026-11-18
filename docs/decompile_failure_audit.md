# Corpus decompile gap audit

Measured on `master` (2026-11-18) against the 48 corpus shaders in
`shaders_json/` and their original sources in `tests/Sources/`. On this commit
the gates are green:

| Runner | Result |
|---|---|
| `tests/e2e/test_faithfulness.py` | 48/48 |
| `tests/e2e/test_source_fidelity.py` | 48/48 |
| `tests/e2e/test_corpus_shaders.py` | 48/48 |
| `dotnet test --filter "Category!=D3D"` | 128/128 |

Everything below is outside what those runners assert. Counts are shader
instances, not lines of code.

## 1. Keyword variant bodies beyond 4 permutations are not reconstructed

Sources contain 38 `#pragma multi_compile*` lines (including 7
`multi_compile_instancing`) and 2 `#pragma shader_feature` lines across 16
shaders. A pass whose compiled subprograms group into at most 4 distinct
keyword sets now emits one body per set, most keywords first, with the
fewest-keyword set as the `#else` fallback and one
`#pragma multi_compile _ <keyword>` line per keyword:

```hlsl
#pragma multi_compile _ LIGHTPROBE_SH
#pragma multi_compile _ UNITY_HDR_ON
#if defined(LIGHTPROBE_SH) && defined(UNITY_HDR_ON)
...
#elif defined(LIGHTPROBE_SH)
...
#elif defined(UNITY_HDR_ON)
...
#else
...
#endif
```

16 passes are covered (2-4 sets). Larger passes keep one base body and a single
merged `#pragma multi_compile` line: one pass in `Corpus/27 Keywords` compiled
768 vertex / 384 fragment permutations, and 11 passes have 16 sets (the
forward-base lighting cross-product). Emitting those would multiply a single
pass into hundreds of bodies.

Impact for the uncovered passes: a re-imported shader keeps the keyword
interface (material keyword toggles compile), but every permutation beyond the
first 4 renders the base behaviour. Which keywords came from
`shader_feature`, `*_local`, or a built-in group (`multi_compile_fwdbase`,
`multi_compile_fog`, ...) is not recoverable from the blob, so the original
pragma grouping is lost for every pass; the emitted set is always
`multi_compile` with one group per uncovered keyword.

Shortcut: `MaxEmittedVariantBodies = 4` in `Decompiler.cs`; raise it only if
the generated file size is acceptable for the 16-set lighting passes.

## 2. Surface-shader reconstruction is best-effort, not dataflow-exact

`HlslSurfaceShaderRecognizer` rewrites all 8 surface shaders (`05`, `06`, `07`,
`08`, `09`, `10`, `11`, `36`) back to `#pragma surface surf <model>` with an
`Input` struct and a `surf()` body, dropping the 2-4 compiled passes by default
(`--keep-passes` restores them as a comment).

Detection uses the compiled pass set (ForwardBase + ForwardAdd + `appdata_full`)
rather than a lighting fingerprint, so every surface shader is recognized. Input
fields come from the vertex pass's `_ST` transforms (`uv_MainTex`,
`uv2_LightMap`, ...), and the body is reconstructed from the deferred G-buffer
writes plus the property set: Standard, StandardSpecular, Lambert and BlinnPhong
templates, and a heuristic custom-lighting model for `Corpus/09`.

Remaining gap: the original `surf()` body is not recovered line-for-line. A
compiled blob carries no source text, and Unity inlines and optimizes the body,
so dead stores and folded expressions leave no trace. Reconstructed bodies are
therefore close but not identical: `Corpus/05` loses its `vertex:vert` /
`finalcolor:finalColor` functions, `Corpus/10` omits tessellation, `Corpus/11`
omits `vert`/`finalColor`, and a custom lighting function is emitted from a
template because its name is not serialized.

Impact: the output is source-shaped rather than fully pass-expanded, which is
the intended goal (readability, not visual correctness). `test_source_fidelity.py`
still skips surface pass structure. `docs/future_features.md` describes the
dataflow reconstruction that would close the remaining gap.

## 3. Hull/domain and compute entry points

Hull/domain are now emitted as a valid Unity tessellation shader.
`Corpus/19 Hull Domain` carries `#pragma hull hull` / `#pragma domain domain`,
the `[domain("tri")]`, `[partitioning("fractional_odd")]`,
`[outputtopology("triangle_cw")]`, `[outputcontrolpoints(3)]` and
`[patchconstantfunc("hull_const")]` attributes, `InputPatch`/`OutputPatch`
parameters, the domain's `CONST` patch-constant parameter, and the fork phase
as the patch-constant function `hull_const` returning a struct with
`float edges[3] : SV_TessFactor` / `float inside : SV_InsideTessFactor`.
A domain shader that reads the tess factors (`vpcN`) routes them to `CONST`.
The hull's control-point phase is synthesized as a pass-through because the
shipped bytecode contains only the fork phase. Both entry points compile with
`d3dcompiler_47` (`hs_5_0`, `ds_5_0`).

Remaining gaps in this area:

- No corpus shader is a compute shader and no serialized subprogram type maps
  to compute, so the printer's `#pragma kernel` / `[numthreads(...)]` path is
  unreachable from a Shader asset.
- 75 `#pragma only_renderers d3d11` lines in the sources are not emitted; the
  renderer restriction is not recoverable from a player build.

## 4. Build-stripped or unemitted metadata

These facts are not present in a player build, or are present but not printed.
Counts are from the 48 sources versus the 48 outputs:

| Fact | Source | Output | Notes |
|---|---:|---:|---|
| Pass `Name "..."` | 66 | 0 | `m_Name` serializes as `""` |
| `Fog` | 0 in corpus | 0 | `fogMode` is parsed but never printed |
| Separate front/back Stencil | 0 in corpus | 0 | only the single-face form is emitted (`shortcut:` at `HlslPrettyPrinter.cs:402`) |
| `Category { }` wrappers | 1 (`Corpus/44`) | 0 | flattened into SubShaders |

The source-fidelity runner skips pass names and `[Property]` refs. Texture
defaults, property attributes (including the ones derived from
`ShaderPropertyFlags`) and LOD are now recovered and compared.

## 5. Emitter fallbacks and latent paths

These are marked `shortcut:`/`TODO` in the code. None are hit by the current
corpus (outputs contain no `TODO` comments today), so they are latent rather
than observed failures:

| Location | Gap |
|---|---|
| `Decompiler.cs:637` | A grab texture is matched to the lowest-slot anonymous `tN` resource; a pass binding several anonymous textures can pick the wrong one. |
| `Decompiler.cs:780` | `#pragma target` is inferred from the program shader model (SM4.0→3.5, SM5.0→4.5, tessellation→5.0), not the source's value. |
| `Decompiler.cs:876` | A variable declared in two cbuffers keeps the lowest slot's name; reads that resolve to the duplicate use the kept name and may read the wrong buffer value. |
| `HlslAstBuilder.cs:316` | Hull fork and join statements both run inside the emitted fork-instance loop; join writes are idempotent, and no corpus shader has a join phase. |
| `HlslAstBuilder.cs:442` | `SV_GSInstanceID` is not routed out of the per-vertex array (only `SV_PrimitiveID` is). |
| `HlslAstBuilder.cs:635` | Structured buffer element type is guessed: `float4` for stride 16, `uint` otherwise. |
| `HlslPrettyPrinter.cs:233` | Keywords beyond the 4 emitted permutations become one merged `#pragma multi_compile` line per pass; `shader_feature`/`_local` and the original grouping are lost. |
| `HlslPrettyPrinter.cs:94,103` | Range bounds and unknown property kinds fall back to `Float /* TODO ... */`. |
| `HlslPrettyPrinter.cs:1027` | Unrecognised macros emit `#define name(v) /* TODO ... */ (v)`. |
| `HlslPrettyPrinter.Registers.cs:142` | Unhandled IR nodes emit `// TODO: unhandled IR node` (`emitStream`/`cutStream`, ...). |
| `HlslPrettyPrinter.Registers.cs:1231` | `bfe` sign-extend shift is UB for width 0 or 32 (DXBC does not emit it today). |
| `HlslPrettyPrinter.Registers.cs:1360` | Abs-fold guard only covers `max(a, -a)`; other spellings can fail with X8000. |
| `HlslPrettyPrinter.Registers.cs:1503,1509,1632` | Unmapped intrinsics/texture ops (`DistanceVector`, `MaskedSumOfAbsoluteDifferences`, `Eval*`, unknown texture ops) and empty matrices fall back to `TODO` text. |
| `HlslPrettyPrinter.Registers.cs:1528` | ResInfo maps 2D/3D/cube; multisampled targets omit the mip parameter and exotic resource types fall back to 3. |
| `HlslSurfaceShaderRecognizer.cs` | `surf` bodies come from per-model templates, not the pass dataflow; functions outside `surf` (vert, finalcolor, tessellation) are omitted and custom lighting is a template. |

## 6. Platform coverage

Only DX11 SM4/5 subprograms are decoded. Everything else is logged and
skipped (`Decompiler.cs:200`):

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
  numeric and texture default/attributes), fallback, SubShader count/tags/LOD,
  pass count, and per-pass render state. It skips pass names, `[Property]`
  state refs, surface-shader structure, and all HLSL text. Int/UInt property
  types are compared as Float because the build stores them as `m_Type` 2.
- No corpus shader covers compute, separate stencil faces, `Fog`,
  `SetTexture`, or MRT blend targets. Hull/domain is covered by
  `Corpus/19`, including `hs_5_0`/`ds_5_0` recompilation in the D3D test tier.
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

1. Keyword variant bodies beyond 4 permutations (item 1) — 16 passes emit
   per-variant bodies; larger passes still lose non-base behaviour.
2. Surface dataflow reconstruction (item 2) — readability only; see
   `docs/future_features.md` for the design.
