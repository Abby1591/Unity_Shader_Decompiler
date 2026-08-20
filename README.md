# Unity Shader Decompiler

Decompiles compiled Unity shaders — the LZ4-compressed `m_CompressedBlob` inside a serialized `Shader` asset — back into readable ShaderLab source. The input is the plain-text JSON that AssetStudio exports for a shader asset; the output is a `.shader` file with a reconstructed `Properties` block, subshader/pass structure, render state, and per-pass HLSL functions.

The decompilation itself is a C# pipeline: it slices the DXBC container out of each shipped GPU program, decodes every SM4/SM5 instruction, builds a typed SSA IR, runs ~20 optimization and pattern-recognition passes, and finally renders an HLSL AST back to source text. Where a pass is recognized as Unity surface-shader boilerplate, it is rewritten into the canonical `#pragma surface` form.

```
shaders_json/<Name>.json         AssetStudio JSON export of a Unity Shader asset
        │
        │  Stage 0 (Python: Extract.py + libs/)
        ▼
Output/<Name>/                   blob.bin + metadata.json + dummy.shader
        │
        │  Stage 1+ (C#: Shader Decompiler/)
        ▼
Shader Decompiler/Output/<Name>.shader
```

## Requirements

- **Python 3.10+** with the `lz4` package (`pip install lz4`) — for Stage 0.
- **.NET SDK** targeting `net10.0` — for Stage 1+.
- **Windows** with `d3dcompiler_47.dll` available — required for DXBC disassembly (`--disasm`), recompile verification (`--recompile-verify`), the signature cross-check (`--verify-signatures`), and the strip-survivor analysis (`--strip-survivors`). The DXBC parser and IR pipeline are platform-neutral; only the D3D-compiler-backed tools need the native library.

NuGet packages (`Shader Decompiler/Shader Decompiler.csproj`):

| Package | Version | Purpose |
| --- | --- | --- |
| `Unity` | 5.11.10 | AssetStudio — Unity shader-blob reader (`ShaderProgram`, `ShaderSubProgram`) |
| `Vortice.D3DCompiler` | 3.8.3 | D3D compiler P/Invoke — disassembly, recompilation, stripping |

## Stage 0 — extract the blob from a JSON export (Python)

```bash
pip install lz4
python Extract.py shaders_json/HOLO_Holo.json
```

This reads the export and writes three files into `Output/<Name>/`:

| File | Source |
| --- | --- |
| `blob.bin` | `m_CompressedBlob`, base64-decoded and LZ4-decompressed (`libs/blob.py` + `libs/lz4util.py`) |
| `metadata.json` | flattened `m_ParsedForm`: name, properties with defaults, subshaders/passes, render state, per-pass cbuffer layouts (`libs/metadata.py`) |
| `dummy.shader` | the matching plain-text reference export from `shaders_dummy/`, if one exists (`libs/dummy.py`) |

### Stage 0 flags

| Flag | Default | Effect |
| --- | --- | --- |
| `json_path` (positional) | — | the AssetStudio JSON export to process |
| `--dummy-dir` | `shaders_dummy` | where to look for the matching `.shader` reference |
| `--out-dir` | `Output` | root output directory |
| `--flat` | off | write `blob.bin`/`metadata.json`/`dummy.shader` directly into `--out-dir` with no per-shader subfolder |

`Extract.py` prints the exact C# invocation to use next. Folder names are sanitized (`/` and `\` → `_`, trailing dots/spaces stripped) so they are safe on Windows.

## Stage 1+ — decompile (C#)

```bash
cd "Shader Decompiler"
dotnet restore "Shader Decompiler.csproj"
dotnet build "Shader Decompiler.csproj" -c Release

# Decompile a Stage 0 output folder
dotnet run --project "Shader Decompiler.csproj" -- ../Output/HOLO_Holo

# Or a bare blob.bin that sits next to a metadata.json
dotnet run --project "Shader Decompiler.csproj" -- path/to/blob.bin
```

With no arguments it defaults to `../Output/HOLO_Holo`. The generated shader is written to the project-local `Shader Decompiler/Output/<Name>.shader`; `--out-root` redirects it. A summary is printed per subprogram (blob header, DXBC size, decoded instructions, post-optimization IR, SSA verification result, recognized loops, input/output signatures) followed by the pass-recovery report and the final writer stage.

### CLI flags

| Flag | Effect |
| --- | --- |
| `--out-root <dir>` | write output `.shader` files (and any `--save-subprograms` artifacts) to `<dir>` instead of the project-local `Output/` |
| `--dump-stages` | print a full IR snapshot after every pipeline phase, so passes can be diffed |
| `--dump-keywords` | print each subprogram's global + local keyword sets |
| `--save-subprograms` | also write per-subprogram debug artifacts: `program{i}.bin`, `program{i}.dxbc`, `program{i}.hlsl` |
| `--no-fuse-temps` | disable temp-fusion in the pretty printer (keep every SSA copy as its own statement) |
| `--no-surface-shaders` | disable surface-shader recognition; emit the raw reconstructed HLSLPROGRAM passes |
| `--keep-passes` | when a pass *is* recognized as a surface shader, keep the verified compiled passes as comments (default: omit them so output matches the original line count) |
| `--run-spec-tests` | run the parser spec-test vectors (§14 classifier + §15) and exit |
| `--verify-signatures [dir]` | cross-check our ISGN parser against d3dcompiler's `GetInputSignatureBlob` over every shipped subprogram in `dir` (defaults to the repo `Output/`) |
| `--strip-survivors` | compile synthetic shaders, `D3DStripShader(flags=7)` them, and record which DXBC chunks survive; also scans shipped bytecode |
| `--recompile-verify [file]` | recompile the HLSLPROGRAM blocks of one decompiled `.shader` with d3dcompiler (`vs_5_0`/`ps_5_0`) and match their signatures against shipped bytecode |
| `--recompile-verify-all [dir]` | the same verification aggregated over every decompiled `.shader` in `dir` |
| `--disasm [dir]` | dump the DXBC disassembly of every non-compute subprogram to sibling `<name>.disasm.txt` files |

## Pipeline overview

The C# side runs, per subprogram, the phases in `IRPipeline` (`DXBC/IR/IRPipeline.cs`):

1. **Blob classification** (`DXBC/Extraction/UnityShaderBlob.cs`) — distinguishes non-compute (`0x02` header), compute (u64 sentinel), raw-variant, and wire-frame payloads; slices the DXBC container out.
2. **Container parse** (`DXBC/Container/DxbcFile.cs`) — validates the `DXBC` magic/version/lengths and parses the typed chunks: `ISGN`, `OSGN`, `OSG5`, `PSGN`, `PCON`, `SFI0`, `RDEF`, `STAT`, and the `SHDR`/`SHEX` shader chunk. Unknown chunks are kept raw, never discarded.
3. **Instruction decode** (`DXBC/Instructions/ShdrParser.cs`) — every tokenized SM4/SM5 instruction and operand.
4. **IR build** (`DXBC/IR/IRBuilder.cs` + `Builders/`) — flat, typed IR statements.
5. **CFG** (`IRBlockBuilder` + `IRControlFlowGraphBuilder`) — basic blocks and edges.
6. **SSA** — dominators (CHK algorithm), dominance frontiers, phi insertion, renaming (`Core/Analysis/`).
7. **Optimization to a fixed point** (`Core/Optimizations/IROptimizationPipeline.cs`) — sweeps 9 statement-level passes (constant folding, constant propagation, copy propagation, DCE, algebraic simplification, value numbering, strength reduction, loop-invariant code motion, sparse conditional constant propagation) plus a CFG inner loop (branch simplification, CFG cleanup, phi simplification) until nothing changes (max 50 iterations), re-computing dominators whenever the CFG mutates.
8. **Pattern recognition** (`IRShaderPatternRecognition` + matrix/vector/texture/loop recognizers) — folds common shader idioms back into high-level IR; loop detection is read-only.
9. **Leave SSA** (`IRLeaveSsa` + `IRCopyCoalescing`) — phi elimination and vector-copy fusion.
10. **Metadata binding** (`IRMetadataBinding`) — attaches RDEF/ISGN/OSGN symbolic names to the IR.
11. **AST build** (`Core/Hlsl/HlslAstBuilder.cs`) — one `HlslFunctionNode` per subprogram; the Shader/SubShader/Pass shell comes straight from `metadata.json`.
12. **Pass/variant recovery** (`BuildVariantPasses` in `Program.cs`) — Unity serializes subprograms pass-by-pass (all vertex variants, then all fragment variants), so a stage regression marks a pass boundary; vertex/fragment variants are paired by interpolator hand-off signature and byte-identical pairs deduplicated. Geometry/hull/domain/compute functions attach by position.
13. **Pretty print** (`Core/Hlsl/HlslPrettyPrinter.cs`, stages 13/14) — the AST to `.shader` text: properties, tags, LOD, render state (cull/ztest/zwrite/blend/stencil), HLSLPROGRAM blocks with `#pragma vertex`/`#pragma fragment`, structs, resources with explicit register bindings, and per-function bodies. The printer also reconstructs matrix multiplies from outer-product accumulations and reverts recognized Unity macro idioms (`UnityObjectToClipPos`, `UnityObjectToWorldPos`, `LinearEyeDepth`, `Linear01Depth`) to `#define`s.
14. **Surface-shader recognition** (`Core/Hlsl/HlslSurfaceShaderRecognizer.cs`, stage 13.5) — when a lit pass carries the compiled signature of a `#pragma surface` source (a `_LightColor0`-driven lighting expression), the pass is rewritten to the canonical CGPROGRAM surface form with an `Input` struct and a `surf()` body.

### IR pipeline stages

The per-subprogram phase numbers used throughout the code:

```
01-cfg (pre-SSA)
02-phi-insertion (pre-rename)
03-ssa-renamed (pre-optimize)
04-optimize-<pass>  (every pass, per iteration)
05-pattern-recognized
06-left-ssa
06b-copy-coalesced
07-metadata-bound
```

`--dump-stages` prints each of these; diffing consecutive snapshots pins any corruption to the exact pass that introduced it.

## Repository layout

```
.
├── Extract.py                      Stage 0 orchestrator (Python)
├── libs/                           Stage 0 support modules
│   ├── blob.py                     m_CompressedBlob → raw bytes (base64 + LZ4)
│   ├── metadata.py                 m_ParsedForm → metadata.json
│   ├── dummy.py                    locate/copy the matching .shader reference
│   ├── lz4util.py                  lz4.block.decompress wrapper
│   └── Reader.py                   little-endian BinaryReader
│
├── Shader Decompiler/              Stage 1+ (C# console app, net10.0)
│   ├── Program.cs                  CLI entrypoint; drives the whole pipeline
│   ├── Shader Decompiler.csproj    net10.0, Unity 5.11.10, Vortice.D3DCompiler 3.8.3
│   ├── Core/
│   │   ├── Analysis/               SSA verifier/renaming/phi-insertion, dominators,
│   │   │                           dominance frontier, def-use, leave-SSA
│   │   ├── Hlsl/                   AST, pretty printer, surface-shader recognizer,
│   │   │                           name recovery, temp fusion, statement tree
│   │   └── Optimizations/          ~20 rewrite passes + matrix/vector/texture/loop
│   │                               pattern recognition
│   ├── DXBC/
│   │   ├── Chunks/                 ISGN/OSGN/PSGN/RDEF/SFI0/STAT parsers
│   │   ├── Container/              DxbcFile, chunks, FourCC
│   │   ├── Disassembly/            DxbcDisassembler (Vortice)
│   │   ├── Extraction/             UnityShaderBlob classifier, non-compute header
│   │   ├── Instructions/           opcode table, operand decoding, ShdrParser
│   │   ├── IR/                     IR model + per-opcode builders + IRPipeline
│   │   └── Metadata/               ShaderProject + metadata.json deserialization
│   ├── Unity/Blob/                 Unity shader-blob reader (AssetStudio)
│   ├── Docs/                       reverse-engineering notes and parser spec
│   ├── Output/                     generated .shader files (default location)
│   └── Tests/                      spec vectors, signature cross-check, strip
│                                   analysis, recompile verification, golden tests
│
├── shaders_json/                   AssetStudio JSON exports (input corpus, 39)
├── shaders_dummy/                  plain-text reference exports (+ Source/ PicaVoxel)
├── Output/                         Stage 0 output: <Name>/{blob.bin, metadata.json,
│                                   dummy.shader}, plus decompiled .shader files
└── .github/workflows/              CI build & publish
```

## Outputs

By default each run writes one `.shader` file per input shader to `Shader Decompiler/Output/` (or `--out-root`). With `--save-subprograms`, per-subprogram debug artifacts are also written:

| File | Contents |
| --- | --- |
| `<Name>.shader` | the reconstructed ShaderLab source |
| `program{i}.bin` | raw Unity subprogram bytes |
| `program{i}.dxbc` | the extracted DXBC container |
| `program{i}.hlsl` | DXBC disassembly (assembly text) via Vortice |

## Tests

- `Tests/test_picavoxel_shaders.py` — golden tests over the four PicaVoxel shaders whose real source is in `shaders_dummy/Source/`. For each: re-runs `Extract.py`, runs the decompiler, and asserts the output preserves the shader name, all declared properties, the fallback, cbuffer register bindings, and named cbuffer members, and that the pipeline reached the final writer stage.
- `Tests/SpecTestVectors.cs` — offline vectors for the §14 blob classifier and §15 parser behaviors (`--run-spec-tests`).
- `Tests/SignatureCrossCheck.cs` — our ISGN parser vs. d3dcompiler's own signature extraction, element by element (`--verify-signatures`).
- `Tests/StripSurvivors.cs` — which DXBC chunks survive `D3DStripShader(flags=7)` (RDEF/STAT are removed; ISGN/OSGN and the shader chunk survive), verified on both synthetic and shipped bytecode (`--strip-survivors`).
- `Tests/RecompileVerify.cs` — recompiles each decompiled HLSLPROGRAM pass and matches its input/output signature sets against shipped subprograms (`--recompile-verify`, `--recompile-verify-all`, `--disasm`).

The surface-shader recognizer only rewrites passes that pass this recompile gate — the compiled output must match shipped bytecode signatures before it is trusted.

## Documentation

`Shader Decompiler/Docs/` contains the reverse-engineering work this project is based on:

- `shader_compiler_analysis.md` — Ghidra analysis of `UnityShaderCompiler.exe`: the IPC wire protocol, how reflection metadata is extracted and how `D3DStripShader(flags=7)` strips the RDEF/debug chunks from shipped bytecode.
- `shader_parser_spec.md` — an implementation-grade spec for the blob parser, with claims tagged PROVEN / STRONGLY INFERRED / POSSIBLE / UNKNOWN.

## Current status & limitations

- ✅ Full SM4/SM5 DXBC instruction decoding, per-subprogram extraction, blob classification.
- ✅ Typed SSA IR with CFG, dominators, ~20 optimization passes to a fixed point, and matrix/vector/texture/loop pattern recognition.
- ✅ Metadata binding from RDEF/ISGN/OSGN, per-pass cbuffer layouts recovered from the serialized shader metadata.
- ✅ Full `.shader` output via the pretty printer, with Unity macro reversion, matrix-multiply reconstruction, and surface-shader recognition.
- ✅ Recompile verification of emitted passes against shipped bytecode.
- ⏳ Hull/geometry/compute subprograms are parsed and IR-built, but the AST path mainly targets vertex/fragment; other stages attach to the shell pass by serialization order.
- ⚠️ The CI workflow (`.github/workflows/ci-build-info.yml`) still references the old `Parser.csproj` project name and the `main` branch; the project is `Shader Decompiler.csproj` on `master`, so the workflow needs updating before it will pass.

## Contributing

- Open issues for bugs and feature requests.
- PRs welcome. The most valuable contributions right now are extending the golden-test corpus (more real source in `shaders_dummy/`), fixing decoder/optimizer correctness issues, and updating the CI workflow to the current project layout.
- If you change the pretty printer or surface-shader recognition, keep `--recompile-verify-all` green.

## License

None — add one before publishing.