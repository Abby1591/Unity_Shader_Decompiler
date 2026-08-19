# Unity Shader Decompiler

A two-stage pipeline that decompiles **compiled Unity shaders** (the opaque binary `m_CompressedBlob` inside a serialized `Shader` asset) back into structured, human-readable form.

- **Stage 0 (Python):** pulls a shader's raw blob + metadata out of an AssetStudio JSON export.
- **Stage 1+ (C# / .NET 10):** parses the embedded DXBC bytecode, builds a typed SSA IR, runs a full compiler-grade optimization + pattern-recognition pipeline, and assembles an HLSL AST tree.

The end goal is lossless reconstruction of ShaderLab + HLSL source. Today the tool already produces a faithful IR, a structured AST, and DXBC disassembly for every subprogram — a high-level HLSL *emitter* (the final "pretty printer" stage) is the remaining gap.

## Pipeline overview

```
shaders_json/<Name>.json            AssetStudio export of a Unity Shader asset
        │
        │  Stage 0 (Python, libs/)
        │    blob.py      → LZ4-decompress m_CompressedBlob
        │    metadata.py  → flatten m_ParsedForm into metadata.json
        │    dummy.py     → locate matching plain-text .shader reference
        ▼
Output/  blob.bin + metadata.json + (dummy.shader)
        │
        │  Stage 1+ (C#, Parser/)
        │    ShaderProgram   → enumerate subprograms from the Unity blob
        │    DxbcExtractor   → slice the "DXBC" container out of each
        │    DxbcFile        → parse container chunks (RDEF/ISGN/OSGN/STAT)
        │    ShdrParser      → decode every tokenized instruction + operand
        │    IRBuilder       → flat IR statements
        │    IRBlockBuilder  → basic blocks + CFG
        │    SSA             → dominators / dominance frontier / phis / renaming
        │    IROptimizationPipeline → ~15 passes to a fixed point
        │    IRShaderPatternRecognition → matrix/vector/texture/loop folding
        │    IRLeaveSsa      → phi elimination + copy coalescing
        │    IRMetadataBinding → RDEF/ISGN/OSGN symbolic names onto the IR
        │    HlslAstBuilder  → Stage 2 HLSL AST (shell + per-pass functions)
        ▼
Output/  program{i}.bin · program{i}.dxbc · program{i}.hlsl (+ console IR dump)
```

## Repository layout

```
.
├── libs/                  Stage 0 (Python)
│   ├── blob.py            m_CompressedBlob → raw bytes (via lz4util)
│   ├── metadata.py        m_ParsedForm → metadata.json
│   ├── dummy.py           locate/copy the matching dummy .shader reference
│   ├── lz4util.py         LZ4 block decompression
│   └── Reader.py          little-endian BinaryReader helper
│
├── Parser/                Stage 1+ (C# console app, net10.0)
│   ├── Program.cs         CLI entrypoint; drives the whole pipeline
│   ├── Decompiler/        DxbcExtractor, DxbcDisassembler (Vortice), HlslGenerator
│   ├── DXBC/
│   │   ├── Container/     DXBC container: DxbcFile, chunks, FourCC
│   │   ├── Chunks/        RDEF / ISGN / OSGN / PSGN / STAT parsers
│   │   ├── Instructions/  opcode table, operand decoding, ShdrParser
│   │   ├── IR/            IR model + CFG + SSA + optimizations + patterns
│   │   │   ├── Analysis/        dominators, DF, phi, renaming, verifier, leave-SSA
│   │   │   ├── Builders/        per-opcode IR emission (arithmetic/flow/texture/…)
│   │   │   └── Optimizations/   ~20 rewrite passes + pattern recognition
│   │   ├── HLSL/          Stage 2 AST: shell, render state, structured statements
│   │   └── Metadata/      ShaderProject + metadata.json deserialization
│   └── Output/            sample generated program{i}.{bin,dxbc,hlsl}
│
├── shaders_json/          AssetStudio JSON exports of Unity shaders (input corpus)
├── shaders_dummy/         matching plain-text .shader exports (debug/reference)
├── Output/                Stage 0 output: blob.bin + metadata.json + dummy.shader
└── blob.bin               an extracted raw blob (back-compat direct input)
```

## Requirements

- **Python 3.10+** with the `lz4` package (`pip install lz4`) — for Stage 0.
- **.NET SDK** that supports `net10.0` — for Stage 1+.
- **Windows** (or a machine with `d3dcompiler` available): `Vortice.D3DCompiler` P/Invokes the native D3D compiler for disassembly. The DXBC parse + IR pipeline is platform-neutral; only the `Disassemble` step needs the native library.

## Build & run

```bash
# Stage 0 — produce Output/blob.bin + Output/metadata.json from a JSON export.
# (Driver script not yet in-tree; the pieces live in libs/ and are wired by the
#  eventual Extract.py. Any folder containing blob.bin + metadata.json works.)

# Stage 1+ — build the C# project
cd Parser
dotnet restore Parser.csproj
dotnet build Parser.csproj -c Release

# Run against the Stage 0 output folder (defaults to ../Output)
dotnet run --project Parser.csproj -- path/to/output-folder

# Or a bare blob.bin (must sit next to metadata.json)
dotnet run --project Parser.csproj -- path/to/blob.bin
```

Useful CLI flag:

| Flag | Effect |
| --- | --- |
| `--dump-stages` | print a full IR snapshot after *every* pipeline phase, so you can diff between passes |

## Outputs

For each subprogram `i`, written to `Parser/Output/` (and also printed to the console: instruction list, IR statements, SSA verification result, recognized loops):

| File | Contents |
| --- | --- |
| `program{i}.bin`  | raw Unity subprogram bytes |
| `program{i}.dxbc` | the extracted DXBC container |
| `program{i}.hlsl` | DXBC **disassembly** (assembly-like text, not yet reconstructed HLSL source) |

A Stage 2 summary is also printed: per-pass `vert`/`frag` function attachments, input/output struct fields, and resource lists built from the AST.

## Architecture notes

The codebase is organized around an explicit stage/phase map (referenced throughout the comments):

- **Stage 0** — Python extraction: `0.1` blob → `0.2` metadata → `0.3` dummy → `0.4` `ShaderProject` (single entry point for everything downstream).
- **Stage 1** — decode to IR: `ShdrParser` → `IRBuilder` → CFG → SSA.
- **Stage 2** — HLSL AST shell + function slots (`HlslAST.cs`, `HlslAstBuilder.cs`).
- **Stages 6–10** — AST enrichment: render state (`HlslRenderstateBuilder`), RDEF cbuffer bodies, ISGN/OSGN signature typing, and the structured statement tree (`HlslStatement.cs`).
- **Stage 12** (name recovery) and **Stage 13** (pretty printer → real `.shader` text) are the two remaining stages; the IR and AST are already structured so those become formatting passes.

Inside `DXBC/IR/`, the phases are numbered independently: block splitting, CFG construction, dominators (CHK algorithm), dominance frontiers, phi insertion, SSA renaming, verification, leave-SSA, then the fixed-point optimization loop:

1. Constant folding → 2. Constant propagation → 3. Copy propagation → 4. Dead-code elimination → 5. Algebraic simplification → 6. Value numbering → 7. Strength reduction → 8. Loop-invariant code motion → 9. SCCP → 10a/b/c. Branch simplification / CFG cleanup / phi simplification

followed by matrix/vector/texture/loop pattern recognition, and finally metadata binding.

Design principles that are enforced throughout:

- **Nothing read off the wire is discarded.** Raw tokens, extension tokens, `ExtraData`, and even raw immediate bit patterns are preserved so future decode work never needs to re-parse.
- **SSA is verified, not assumed.** `IRSsaVerifier` runs after optimization and after pattern recognition; `--dump-stages` lets you pin any corruption to the exact pass that introduced it.
- **The AST is a tree, not text.** Nothing renders itself; a single future pretty printer turns it into source.
- **Unknown input degrades gracefully.** Unknown opcodes, missing metadata, and unhandled chunk types produce warnings / raw fallbacks, never silent loss.

## Current status & limitations

- ✅ DXBC container/chunk parsing, full SM4/SM5 instruction decoding, per-subprogram extraction.
- ✅ Typed IR, CFG, SSA construction + verification, ~20 optimization passes, matrix/vector/texture/loop pattern recognition.
- ✅ RDEF/ISGN/OSGN metadata binding, Stage 2 HLSL AST with render state + structured statements.
- ⏳ `program{i}.hlsl` is still DXBC **disassembly**, not reconstructed HLSL.
- ⏳ Stage 12 name recovery and Stage 13 pretty printer not yet implemented.
- ⏳ Hull/geometry/compute stages are parsed and IR-built, but the AST path currently maps only vertex/fragment (and per-pass pass-slot assignment assumes serialization order — see `Program.cs`).
- ⚠️ Known correctness issues exist in the decoder/optimizer (e.g. `TestBoolean` polarity, `Saturate` bit, several opcode-table operand-count mismatches). Fixing those is the active work item.

## Contributing

- Open issues for bugs and feature requests.
- PRs welcome. The single most valuable contribution right now is a **golden-IR test harness**: run the pipeline with `--dump-stages` over the sample blobs in `shaders_json/`/`Output/`, snapshot the IR, and assert it doesn't change as passes are fixed.
- If you add the Stage 13 pretty printer, include sample outputs validated against the `shaders_dummy/` references.

## License

None yet — add one before publishing.
