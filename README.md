# Unity Shader Decompiler

A two-stage pipeline that decompiles **compiled Unity shaders** (the opaque binary `m_CompressedBlob` inside a serialized `Shader` asset) back into structured, human-readable ShaderLab + HLSL source.

- **Stage 0 (Python):** pulls a shader's raw blob + metadata out of an AssetStudio JSON export.
- **Stage 1+ (C# / .NET 10):** parses the embedded DXBC bytecode, builds a typed SSA IR, runs a full compiler-grade optimization + pattern-recognition pipeline, assembles an HLSL AST, and — for the first time — **emits a complete `.shader` file** (Stage 13/14 pretty printer), with surface-shader boilerplate recognition on top (Stage 13.5).

The pipeline is verified by recompiling the emitted passes with the real D3D compiler and matching their input/output signatures against the shipped bytecode.

## Pipeline overview

```
shaders_json/<Name>.json              AssetStudio export of a Unity Shader asset
        │
        │  Stage 0 (Python: Extract.py + libs/)
        │    blob.py      → LZ4-decompress m_CompressedBlob  (0.1)
        │    metadata.py  → flatten m_ParsedForm into metadata.json (0.2)
        │    dummy.py     → locate matching plain-text .shader reference (0.3)
        ▼
Output/<Name>/  blob.bin + metadata.json + (dummy.shader)
        │
        │  Stage 1+ (C#, Shader Decompiler/)
        │    ShaderProgram      → enumerate subprograms from the Unity blob
        │    UnityShaderBlob    → classify program kind + slice DXBC out
        │    DxbcFile           → parse container chunks (RDEF/ISGN/OSGN/SFI0/STAT)
        │    ShdrParser         → decode every tokenized instruction + operand
        │    IRBuilder          → flat IR statements (per-opcode builders)
        │    IRBlockBuilder     → basic blocks + CFG
        │    SSA                → dominators / dominance frontier / phis / renaming
        │    IROptimizationPipeline → ~20 passes to a fixed point
        │    IRShaderPatternRecognition → matrix/vector/texture/loop folding
        │    IRLeaveSsa         → phi elimination + copy coalescing
        │    IRMetadataBinding  → RDEF/ISGN/OSGN symbolic names onto the IR
        │    HlslAstBuilder     → Stage 2 HLSL AST (shell + per-pass functions)
        │    BuildVariantPasses → Stage 2b: recover passes & pair vertex/fragment
        │    HlslPrettyPrinter  → Stage 13/14: emit the full .shader text
        │    HlslSurfaceShaderRecognizer → Stage 13.5: rewrite lit passes to #pragma surface form
        ▼
Shader Decompiler/Output/<Name>.shader   (or --out-root override)
```

## Repository layout

```
.
├── Extract.py               Stage 0 orchestrator (Python) — see below
├── libs/                    Stage 0 support modules
│   ├── blob.py              m_CompressedBlob → raw bytes (via lz4util)
│   ├── metadata.py          m_ParsedForm → metadata.json
│   ├── dummy.py             locate/copy the matching dummy .shader reference
│   ├── lz4util.py           LZ4 block decompression
│   └── Reader.py            little-endian BinaryReader helper
│
├── Shader Decompiler/       Stage 1+ (C# console app, net10.0)
│   ├── Program.cs           CLI entrypoint; drives the whole pipeline
│   ├── Shader Decompiler.csproj
│   ├── Core/
│   │   ├── Analysis/        SSA verifier/renaming/phi-insertion, dominators,
│   │   │                    dominance frontier, def-use, leave-SSA
│   │   ├── Hlsl/            HlslAST, HlslAstBuilder, HlslRenderstateBuilder,
│   │   │                    HlslStatement, HlslSemanticNaming, HlslNameRecovery,
│   │   │                    HlslFuseTemps, HlslPrettyPrinter, HlslSurfaceShaderRecognizer
│   │   └── Optimizations/   ~20 rewrite passes + matrix/vector/texture/loop pattern recognition
│   ├── DXBC/
│   │   ├── Chunks/          RDEF / ISGN / OSGN / PSGN / SFI0 / STAT parsers
│   │   ├── Container/       DXBC container: DxbcFile, chunks, FourCC
│   │   ├── Disassembly/     DxbcDisassembler (Vortice D3DCompiler)
│   │   ├── Extraction/      UnityShaderBlob, DxbcExtractor
│   │   ├── Instructions/    opcode table, operand decoding, ShdrParser
│   │   ├── IR/              IR model + per-opcode Builders
│   │   └── Metadata/        ShaderProject + metadata.json deserialization
│   ├── Unity/Blob/          Unity shader blob model (ShaderProgram, ShaderSubProgram…)
│   ├── Docs/                reverse-engineering notes + parser specification
│   ├── Output/              generated .shader files (default write location)
│   └── Tests/               golden tests + verification harnesses
│
├── shaders_json/            AssetStudio JSON exports of Unity shaders (input corpus)
├── shaders_dummy/           matching plain-text .shader exports (debug/reference)
├── Output/                  Stage 0 output: <Name>/{blob.bin, metadata.json, dummy.shader}
└── .github/workflows/       CI build & publish workflow
```

## Requirements

- **Python 3.10+** with the `lz4` package (`pip install lz4`) — for Stage 0.
- **.NET SDK** that supports `net10.0` — for Stage 1+.
- **Windows** (or a machine with `d3dcompiler` available): `Vortice.D3DCompiler` P/Invokes the native D3D compiler for disassembly and recompile-verification. The DXBC parse + IR pipeline is platform-neutral; only the `Disassemble`/`RecompileVerify` steps need the native library.

NuGet dependencies (see `Shader Decompiler.csproj`): `Unity 5.11.10` (AssetStudio) and `Vortice.D3DCompiler 3.8.3`.

## Build & run

### Stage 0 — extract the blob + metadata from a JSON export

```bash
# One shader → Output/<Name>/{blob.bin, metadata.json, dummy.shader}
python Extract.py shaders_json/HOLO_Holo.json

# Custom dummy reference directory
python Extract.py shaders_json/HOLO_Holo.json --dummy-dir shaders_dummy

# Write directly into --out-dir with no per-shader subfolder
python Extract.py shaders_json/HOLO_Holo.json --flat
```

| Arg | Default | Effect |
| --- | --- | --- |
| `json_path` | — | AssetStudio shader JSON export (required) |
| `--dummy-dir` | `shaders_dummy` | directory of plain-text dummy exports |
| `--out-dir` | `Output` | root output directory |
| `--flat` | off | write `blob.bin`/`metadata.json`/`dummy.shader` directly into `--out-dir` |

### Stage 1+ — build and run the C# decompiler

```bash
cd "Shader Decompiler"
dotnet restore "Shader Decompiler.csproj"
dotnet build "Shader Decompiler.csproj" -c Release

# Decompile a Stage 0 output folder (default no-args input: ../Output/HOLO_Holo)
dotnet run --project "Shader Decompiler.csproj" -- path/to/output-folder

# Or a bare blob.bin (must sit next to metadata.json)
dotnet run --project "Shader Decompiler.csproj" -- path/to/blob.bin
```

The generated `.shader` is written to `Shader Decompiler/Output/` by default; `--out-root` overrides the destination.

### CLI flags

| Flag | Effect |
| --- | --- |
| `--out-root <dir>` | write generated `.shader` (+ optional subprogram artifacts) to `<dir>` instead of the project-local `Output/` |
| `--dump-stages` | print a full IR snapshot after *every* pipeline phase, so you can diff between passes |
| `--dump-keywords` | print each subprogram's keyword sets |
| `--save-subprograms` | also write per-subprogram debug artifacts: `program{i}.bin`, `program{i}.dxbc`, `program{i}.hlsl` |
| `--no-fuse-temps` | disable temp fusion in the pretty printer |
| `--no-surface-shaders` | disable Stage 13.5 surface-shader recognition (keep raw reconstructed HLSLPROGRAM passes) |
| `--keep-passes` | when a pass *is* recognized as a surface shader, keep the original compiled passes as comments (default: emit only the reconstructed surface source) |
| `--run-spec-tests` | run the parser spec-test vectors and exit |
| `--verify-signatures` | cross-check ISGN parsing against d3dcompiler's signature extraction across every shipped subprogram |
| `--strip-survivors` | report which DXBC chunks survive `D3DStripShader(flags=7)` |
| `--recompile-verify` | recompile one decompiled `.shader` with real d3dcompiler and match its signatures against shipped bytecode |
| `--recompile-verify-all` | aggregate recompile verification across every decompiled `.shader` in the output root |
| `--disasm` | dump every non-compute subprogram's DXBC disassembly to sibling `<name>.disasm.txt` |

## Outputs

A successful run prints a per-subprogram report (blob kind/header, DXBC size, instruction list, post-optimization IR, SSA verification result, recognized loops, ISGN/OSGN elements) and then writes one `.shader` file per shader:

| File | Contents |
| --- | --- |
| `<Name>.shader` | the reconstructed ShaderLab source — metadata shell + a pass per recovered vertex/fragment variant, structured statements, render state, resources, and (when recognized) reconstructed `#pragma surface` form |

With `--save-subprograms`, per-subprogram debug artifacts are also written:

| File | Contents |
| --- | --- |
| `program{i}.bin`  | raw Unity subprogram bytes |
| `program{i}.dxbc` | the extracted DXBC container |
| `program{i}.hlsl` | DXBC **disassembly** (assembly-like text, not reconstructed HLSL) |

## Architecture notes

The codebase is organized around an explicit stage map (referenced throughout the comments):

- **Stage 0** — Python extraction: `0.1` blob → `0.2` metadata → `0.3` dummy → `0.4` `ShaderProject` (single entry point for everything downstream).
- **Stage 1** — decode to IR: `ShdrParser` → `IRBuilder` → CFG → SSA.
- **Stage 2** — HLSL AST shell + function slots (`HlslAST.cs`, `HlslAstBuilder.cs`).
- **Stage 2b** — pass/variant recovery (`BuildVariantPasses` in `Program.cs`): Unity serializes subprograms pass-by-pass (all vertex variants, then all fragment variants per pass), so a stage regression marks a pass boundary; vertex/fragment variants are then paired by interpolator hand-off (OSGN ≡ ISGN) and byte-identical pairs are deduplicated.
- **Stages 6–10** — AST enrichment: render state (`HlslRenderstateBuilder`), RDEF cbuffer bodies, ISGN/OSGN signature typing, and the structured statement tree (`HlslStatement.cs`).
- **Stage 12** — name recovery (`HlslNameRecovery`) and **Stage 13** — pretty printer (`HlslPrettyPrinter`) now emit the full `.shader` text.
- **Stage 13.5** — surface-shader recognition (`HlslSurfaceShaderRecognizer`): when a pass carries the compiled signature of a `#pragma surface` source, the lit pass is rewritten back to canonical CGPROGRAM surface form (opt out with `--no-surface-shaders`; keep the original passes as comments with `--keep-passes`).
- **Verification** — `RecompileVerify` recompiles each emitted HLSLPROGRAM pass with the real D3D compiler (`vs_5_0`/`ps_5_0`) and matches its input/output signature set against the shipped subprograms — the gate surface-shader reconstruction waits on.

Inside `DXBC/IR/`, the phases are numbered independently: block splitting, CFG construction, dominators (CHK algorithm), dominance frontiers, phi insertion, SSA renaming, verification, leave-SSA, then the fixed-point optimization loop:

1. Constant folding → 2. Constant propagation → 3. Copy propagation → 4. Dead-code elimination → 5. Algebraic simplification → 6. Value numbering → 7. Strength reduction → 8. Loop-invariant code motion → 9. SCCP → 10a/b/c. Branch simplification / CFG cleanup / phi simplification

followed by matrix/vector/texture/loop pattern recognition, and finally metadata binding.

Design principles that are enforced throughout:

- **Nothing read off the wire is discarded.** Raw tokens, extension tokens, `ExtraData`, and even raw immediate bit patterns are preserved so future decode work never needs to re-parse.
- **SSA is verified, not assumed.** `IRSsaVerifier` runs after optimization and after pattern recognition; `--dump-stages` lets you pin any corruption to the exact pass that introduced it.
- **The AST is a tree, not text.** Nothing renders itself; the single pretty printer turns it into source.
- **Unknown input degrades gracefully.** Unknown opcodes, missing metadata, and unhandled chunk types produce warnings / raw fallbacks, never silent loss.
- **Output is proven against the compiler.** Every emitted pass is recompiled and its signatures compared with the shipped bytecode before surface-shader recognition is trusted.

## Tests

Located in `Shader Decompiler/Tests/`:

| File | Purpose |
| --- | --- |
| `test_picavoxel_shaders.py` | golden tests for the four PicaVoxel shaders whose real source ships in `shaders_dummy/Source/` — runs Stage 0 + the decompiler and asserts derivable facts (name, properties, fallback, cbuffer bindings) are preserved |
| `SpecTestVectors.cs` | spec-test vectors for the parser (via `--run-spec-tests`) |
| `SignatureCrossCheck.cs` | ISGN-vs-d3dcompiler signature cross-check (via `--verify-signatures`) |
| `StripSurvivors.cs` | DXBC chunk survival analysis (via `--strip-survivors`) |
| `RecompileVerify.cs` | recompile-and-match harness (via `--recompile-verify` / `--recompile-verify-all` / `--disasm`) |
| `DxbcTest.cs` | DXBC container/parse tests |

```bash
python "Shader Decompiler/Tests/test_picavoxel_shaders.py"
```

## Current status & limitations

- ✅ DXBC container/chunk parsing, full SM4/SM5 instruction decoding, per-subprogram extraction.
- ✅ Typed IR, CFG, SSA construction + verification, ~20 optimization passes, matrix/vector/texture/loop pattern recognition.
- ✅ RDEF/ISGN/OSGN metadata binding, Stage 2 HLSL AST with render state + structured statements, variant-pass recovery.
- ✅ Full `.shader` output (pretty printer) with surface-shader recognition.
- ✅ Recompile-verification harness against the shipped bytecode.
- ⏳ `--save-subprograms` `.hlsl` is DXBC **disassembly**, not reconstructed HLSL.
- ⏳ Hull/geometry/compute stages are parsed and IR-built, but the AST path currently maps only vertex/fragment; other stages attach to the shell pass by serialization order (see `Program.cs`).
- ⚠️ The CI workflow (`.github/workflows/ci-build-info.yml`) still references the old `Parser.csproj` project name and the `main` branch — it needs updating for the current `Shader Decompiler.csproj` / `master` before it will pass.
- ⚠️ Known correctness issues exist in the decoder/optimizer (e.g. `TestBoolean` polarity, `Saturate` bit, several opcode-table operand-count mismatches). Fixing those is the active work item.

## Contributing

- Open issues for bugs and feature requests.
- PRs welcome. The golden tests in `Tests/test_picavoxel_shaders.py` snapshot the four known-good PicaVoxel shaders; extending the corpus to more `shaders_dummy/` references is the most valuable thing you can add.
- If you extend the pretty printer or surface-shader recognition, validate against the `shaders_dummy/` references and keep `--recompile-verify` green.

## License

None yet — add one before publishing.