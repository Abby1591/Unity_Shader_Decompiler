# Unity Shader Decompiler

[![CI](https://github.com/Abby1591/Unity_Shader_Decompiler/actions/workflows/ci-build-info.yml/badge.svg?branch=master)](https://github.com/Abby1591/Unity_Shader_Decompiler/actions/workflows/ci-build-info.yml)
[![Nightly](https://github.com/Abby1591/Unity_Shader_Decompiler/actions/workflows/nightly.yml/badge.svg?branch=master)](https://github.com/Abby1591/Unity_Shader_Decompiler/actions/workflows/nightly.yml)
[![.NET](https://img.shields.io/badge/.NET-10.0-512BD4?logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/download/dotnet/10.0)
[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Unity](https://img.shields.io/badge/Unity-2022.3%20D3D11-black?logo=unity&logoColor=white)](https://unity.com/)

**Turn compiled Unity shaders back into readable ShaderLab and HLSL.**

Unity ships shaders as LZ4-compressed blobs of stripped D3D11 DXBC bytecode.
This project accepts `Shader` JSON exports from [AssetStudio](https://github.com/Perfare/AssetStudio)
or AssetRipper, recovers the serialized ShaderLab metadata, and
decompiles every shipped GPU program through a typed SSA IR into per-pass HLSL.

> Not affiliated with, sponsored by, or endorsed by Unity Technologies.

## Features

- **Complete ShaderLab output** — shader name, properties and defaults,
  fallback, custom editor, tags, LOD, render state, subshaders, and passes.
- **Readable HLSL** — cbuffers with `packoffset`, textures and samplers, input
  and output structs, vertex/fragment entry points, expressions, control flow,
  and intrinsics.
- **A real compiler pipeline** — typed IR, CFG, dominance, SSA, ~20
  optimization passes run to a fixed point, and matrix/vector/texture/loop
  pattern recognition.
- **Unity-aware reconstruction** — restores macros such as
  `UnityObjectToClipPos`, reconstructs matrix multiplies, and rewrites lit
  passes back to `#pragma surface` form when they match.
- **Verified against the original bytecode** — emitted passes are recompiled
  with `d3dcompiler` and their signatures are matched against the shipped
  subprograms.
- **Debuggable** — dump the IR after every phase and write per-subprogram
  `.bin`, `.dxbc`, and disassembly artifacts.

## Example

`Toon/Basic`, decompiled from a stripped DXBC blob:

```hlsl
#pragma vertex vert
program2Output vert(program2Input i)
{
    program2Output o = (program2Output)0;
    #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
    #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
    float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
    o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
    o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
    ...
}

#pragma fragment frag
program6Output frag(program6Input i)
{
    program6Output o = (program6Output)0;
    float4 r0_xyzw_1 = _ToonShade.Sample(sampler_ToonShade, i.texcoord1.xyz);
    float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
    float4 r1_xyzw_2 = (r1_xyzw_1 * _Color);
    o.sv_Target0.xyz = ((((r0_xyzw_1.xyzx + r0_xyzw_1.xyzx)).xyzx * r1_xyzw_2.xyzx)).xyz;
    o.sv_Target0.w = r1_xyzw_2.w;
    return o;
}
```

Thirty-nine complete examples are checked in under
[`Shader Decompiler/Output/`](Shader%20Decompiler/Output).

## Builds

- **CI** runs on every push and pull request. It builds on Windows, Linux, and
  macOS and runs the offline spec tests, but does not publish binaries.
- **Nightly** runs at 03:00 UTC and publishes
  `UnityShaderDecompiler-nightly-<date>-<os>` artifacts only when `master`
  received a commit in the previous 24 hours. It can also be triggered manually
  with the **force** option.

## Requirements

- **[.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0)** — build
  and run the decompiler.
- **Python 3.10+** with [`lz4`](https://pypi.org/project/lz4/) — Stage 0 only.
- **Windows** with `d3dcompiler_47.dll` — verification modes only.

The core pipeline is platform-neutral. Only `--disasm`,
`--recompile-verify`, `--recompile-verify-all`, `--verify-signatures`,
`--strip-survivors`, and `--faithfulness-test` call into the native D3D
compiler.

The only NuGet dependency is
[`Vortice.D3DCompiler`](https://github.com/amerkoleci/Vortice.Windows) 3.8.3.
The Unity shader-blob reader is vendored AssetStudio code in
`Shader Decompiler/Unity/Blob/`.

## Getting started

```bash
git clone https://github.com/Abby1591/Unity_Shader_Decompiler.git
cd Unity_Shader_Decompiler

pip install lz4
python Extract.py shaders_json/HOLO_Holo.json
```

Extraction accepts legacy and current parameter-offset fields without rewriting
the source JSON. Missing or invalid offsets and conflicting schema aliases fail explicitly.

`Extract.py` writes `Output/HOLO_Holo/`:

| File | Contents |
| --- | --- |
| `blob.bin` | `m_CompressedBlob`, base64-decoded and LZ4-decompressed |
| `metadata.json` | flattened `m_ParsedForm`: properties, subshaders, render state, cbuffer layouts |
| `dummy.shader` | optional plain-text reference from `shaders_dummy/`, when a match exists |

Then build and run the decompiler:

```bash
dotnet build "Shader Decompiler/Shader Decompiler.csproj"
dotnet run --project "Shader Decompiler/Shader Decompiler.csproj" -- Output/HOLO_Holo
```

The result is written to `Shader Decompiler/Output/HOLO_Holo.shader`.

## Usage

`Shader Decompiler` accepts a Stage 0 output folder or a `blob.bin` with a
sibling `metadata.json`:

```bash
# Stage 0 output folder
dotnet run --project "Shader Decompiler/Shader Decompiler.csproj" -- Output/HOLO_Holo

# Bare blob.bin with metadata.json next to it
dotnet run --project "Shader Decompiler/Shader Decompiler.csproj" -- path/to/blob.bin

# Write output somewhere other than Shader Decompiler/Output/
dotnet run --project "Shader Decompiler/Shader Decompiler.csproj" -- Output/HOLO_Holo --out-root ./decompiled
```

With no arguments, the decompiler defaults to `../Output/HOLO_Holo` relative to
the project directory.

### Common options

| Option | Purpose |
| --- | --- |
| `--out-root <dir>` | Write the `.shader` and subprogram artifacts to `<dir>` |
| `--dump-stages` | Print the IR after every pipeline phase |
| `--save-subprograms` | Write per-subprogram `.bin`, `.dxbc`, and disassembly files |
| `--no-surface-shaders` | Emit raw HLSLPROGRAM passes instead of surface-shader form |
| `--keep-passes` | Keep original passes as comments when a surface shader is recognized |
| `--keep-register-bindings` | Keep explicit `register(tN)` / `register(bN)` bindings |

<details>
<summary><b>Full CLI reference</b></summary>

<br>

#### Stage 0 — `Extract.py`

| Argument | Default | Effect |
| --- | --- | --- |
| `json_path` (positional) | — | AssetStudio or AssetRipper Shader JSON export to process |
| `--dummy-dir` | `shaders_dummy` | Directory to search for the matching `.shader` reference |
| `--out-dir` | `Output` | Root output directory |
| `--flat` | off | Write the three files directly into `--out-dir` instead of a per-shader subfolder |

Folder names are sanitized for Windows (`/` and `\` become `_`, trailing dots
and spaces are stripped).

#### Stage 1 — `Shader Decompiler`

| Argument | Effect |
| --- | --- |
| `<folder>` / `<blob.bin>` (positional) | Stage 0 output folder, or a `blob.bin` with a sibling `metadata.json` |
| `--out-root <dir>` | Write `.shader` output and subprogram artifacts to `<dir>` instead of the project-local `Output/` |
| `--dump-stages` | Print a full IR snapshot after every pipeline phase and every optimization pass |
| `--dump-keywords` | Print each subprogram's global and local keyword sets |
| `--save-subprograms` | Also write per-subprogram `program{i}.bin`, `program{i}.dxbc`, and `program{i}.hlsl` (disassembly) |
| `--no-fuse-temps` | Disable temp fusion; keep every SSA copy as a separate statement |
| `--no-surface-shaders` | Disable surface-shader recognition; emit raw reconstructed HLSLPROGRAM passes |
| `--keep-passes` | When a pass is recognized as a surface shader, keep the original compiled passes as comments |
| `--keep-register-bindings` | Keep explicit `register(tN)` / `register(bN)` bindings (stripped by default) |
| `--faithfulness-test <folder>` | Decompile one folder, then verify recompiled signatures and metadata fidelity; exit code 0 on pass, 1 on failure |
| `--run-spec-tests` | Run the offline parser spec vectors and exit |
| `--verify-signatures [dir]` | Cross-check the ISGN parser against `d3dcompiler`'s `GetInputSignatureBlob` for every shipped subprogram in `dir` (default: the project-local `Output/`) |
| `--strip-survivors` | Compile synthetic shaders, run `D3DStripShader(flags=7)`, and record which DXBC chunks survive; also scans shipped bytecode |
| `--recompile-verify [file]` | Recompile the HLSLPROGRAM blocks of one `.shader` and match their signatures against shipped bytecode |
| `--recompile-verify-all [dir]` | Aggregate recompile verification over every decompiled `.shader` in `dir` |
| `--disasm [dir]` | Dump DXBC disassembly for every non-compute subprogram into sibling `<name>.disasm.txt` files |

</details>

## How it works

```
AssetStudio / AssetRipper JSON export
  └─ Stage 0: base64 + LZ4 → blob.bin + metadata.json
       └─ Stage 1: DXBC → typed IR → SSA → optimize → HLSL AST → .shader
```

1. **Extract** the compressed blob and flatten `m_ParsedForm` into
   `metadata.json`.
2. **Parse** the DXBC container, its typed chunks, and the SM4/SM5 instruction
   stream.
3. **Rebuild** a typed SSA IR, optimize it to a fixed point, recognize shader
   patterns, and bind symbolic names from the shader metadata.
4. **Emit** the `.shader`: pair variants into passes, pretty-print the AST, and
   recognize Unity surface-shader boilerplate.

<details>
<summary><b>Pipeline details</b></summary>

<br>

Each subprogram goes through `IRPipeline` (`DXBC/IR/IRPipeline.cs`):

1. **Blob classification** — distinguish non-compute (`0x02` header), compute
   (u64 sentinel), raw-variant, and wire-frame payloads, then slice out the
   DXBC container.
2. **Container parse** — validate the `DXBC` magic and lengths; parse `ISGN`,
   `OSGN`, `OSG5`, `PSGN`, `PCON`, `SFI0`, `RDEF`, `STAT`, and the
   `SHDR`/`SHEX` shader chunk. Unknown chunks are preserved raw.
3. **Instruction decode** — decode every SM4/SM5 instruction and operand.
4. **IR build** — build flat, typed IR statements.
5. **CFG** — build basic blocks and edges.
6. **SSA** — dominators (CHK algorithm), dominance frontiers, phi insertion,
   and renaming.
7. **Optimization** — nine statement-level passes (constant folding, constant
   propagation, copy propagation, dead-code elimination, algebraic
   simplification, value numbering, strength reduction, loop-invariant code
   motion, sparse conditional constant propagation) plus a CFG inner loop
   (branch simplification, CFG cleanup, phi simplification), up to 50
   iterations.
8. **Pattern recognition** — fold shader idioms back into high-level IR with
   the matrix, vector, texture, loop, and shader-pattern recognizers.
9. **Leave SSA** — eliminate phis and coalesce copies.
10. **Metadata binding** — attach RDEF/ISGN/OSGN symbolic names to the IR.
11. **AST build** — one function node per subprogram; the
    Shader/SubShader/Pass shell comes from `metadata.json`.
12. **Pass and variant recovery** — `BuildVariantPasses` groups subprograms
    into passes. Unity serializes them pass-by-pass, so a stage regression
    marks a pass boundary. Vertex and fragment variants are paired by
    interpolator hand-off signature, and byte-identical pairs are deduplicated.
13. **Pretty print** — emit properties, tags, LOD, render state,
    `HLSLPROGRAM` blocks, structs, resources, and function bodies.
14. **Surface-shader recognition** — rewrite a pass to `#pragma surface` form
    when it carries the compiled signature of a surface shader.

`--dump-stages` labels snapshots with these phase names:

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

</details>

## Testing

The primary regression suite is a normal `dotnet test` project:

```bash
dotnet test UnityShaderDecompiler.sln
```

It runs in a few seconds and covers:

- offline blob-classifier and DXBC-container vectors,
- in-process decompilation of checked-in fixture blobs,
- metadata fidelity (name, properties, fallback, cbuffer slots),
- SSA validity, variant pairing, and deterministic output,
- Windows-only `d3dcompiler` round-trips under `Category=D3D`.

Every push and pull request runs the fast tier (everything except the native
D3D checks):

```bash
dotnet test UnityShaderDecompiler.sln --filter "Category!=D3D"
```

The end-to-end Python runners exercise Stage 0 plus the CLI:

```bash
# Four PicaVoxel shaders with real source in shaders_dummy/Source/
python Shader Decompiler/Tests/test_picavoxel_shaders.py

# Every shader folder in Output/
python Shader Decompiler/Tests/test_faithfulness.py

# Narrow the faithfulness suite to one or more shaders
python Shader Decompiler/Tests/test_faithfulness.py --filter PicaVoxel
```

Both default to `Shader Decompiler/bin/Debug/net10.0/Shader Decompiler.exe`;
pass `--parser` to point somewhere else.

Additional verification modes live on the CLI. Run them from the repository
root, prefixing each with
`dotnet run --project "Shader Decompiler/Shader Decompiler.csproj" --`.

| Command | What it does |
| --- | --- |
| `--run-spec-tests` | Offline parser vectors (also run in CI as a smoke test) |
| `--verify-signatures` | Cross-check ISGN parsing against `d3dcompiler` |
| `--recompile-verify-all` | Recompile every emitted pass and match shipped signatures |
| `--strip-survivors` | Check which chunks survive `D3DStripShader(flags=7)` |
| `--faithfulness-test <folder>` | Decompile, recompile, and check metadata fidelity for one shader |

## Limitations

- Targets Unity 2022.3 D3D11 shader blobs.
- Vertex and fragment stages are fully reconstructed. Hull, geometry, domain,
  and compute programs are parsed and IR-built, but the AST/emit path mainly
  targets vertex/fragment; other stages attach by serialization order.
- Surface-shader rewrites are gated on recompiled signature matches. Passes
  that do not match are emitted as HLSLPROGRAM.
- Passes declared in metadata with no compiled DX11 variants in the blob are
  emitted as empty shells; the decompiler does not fabricate program bodies.

## Documentation

- [`Shader Decompiler/Docs/shader_compiler_analysis.md`](Shader%20Decompiler/Docs/shader_compiler_analysis.md) —
  Ghidra analysis of `UnityShaderCompiler.exe`, covering the IPC wire protocol,
  RDEF extraction, and `D3DStripShader(flags=7)`.
- [`Shader Decompiler/Docs/shader_parser_spec.md`](Shader%20Decompiler/Docs/shader_parser_spec.md) —
  implementation-grade parser spec with every fact labeled PROVEN, STRONGLY
  INFERRED, POSSIBLE, or UNKNOWN.

## Project layout

<details>
<summary><b>Repository map</b></summary>

<br>

```
.
├── UnityShaderDecompiler.sln        Solution (app + tests)
├── Extract.py                       Stage 0 orchestrator (Python)
├── libs/                            blob/metadata/dummy helpers
│   ├── blob.py                      m_CompressedBlob → raw bytes
│   ├── metadata.py                  m_ParsedForm → metadata.json
│   ├── dummy.py                     matching .shader reference lookup
│   ├── lz4util.py                   LZ4 decompression wrapper
│   └── Reader.py                    little-endian BinaryReader
│
├── Shader Decompiler/               Stage 1 (C#, net10.0)
│   ├── Program.cs                   CLI dispatch and verification modes
│   ├── Decompiler.cs                Reusable, in-process pipeline API
│   ├── Core/
│   │   ├── Analysis/                SSA, dominators, phi insertion, def-use
│   │   ├── Hlsl/                    AST, pretty printer, surface recognition
│   │   └── Optimizations/           rewrite passes and pattern recognizers
│   ├── DXBC/
│   │   ├── Chunks/                  ISGN/OSGN/PSGN/RDEF/SFI0/STAT
│   │   ├── Container/               DxbcFile and chunk parsing
│   │   ├── Disassembly/             Vortice-backed disassembler
│   │   ├── Extraction/              blob classifier
│   │   ├── Instructions/            opcodes, operands, ShdrParser
│   │   ├── IR/                      IR model, builders, IRPipeline
│   │   └── Metadata/                ShaderProject and metadata loading
│   ├── Unity/Blob/                  vendored AssetStudio blob reader
│   ├── Docs/                        reverse-engineering notes and parser spec
│   ├── Output/                      39 checked-in example decompilations
│   └── Tests/                       golden, faithfulness, and verification harnesses
│
├── tests/
│   ├── UnityShaderDecompiler.Tests/ xUnit regression suite (`dotnet test`)
│   └── Fixtures/                    checked-in blob.bin + metadata.json fixtures
│
├── shaders_json/                    39 AssetStudio JSON exports
├── shaders_dummy/                   reference shaders and Source/
└── Output/                          generated Stage 0 output (not checked in)
```

</details>

## Contributing

Issues and pull requests are welcome.

- Add more real shader sources under `shaders_dummy/Source/` to grow the golden
  corpus.
- Fix decoder and optimizer correctness bugs.
- Improve the AST path for hull, geometry, domain, and compute stages.

If you change the pretty printer or surface-shader recognition, keep
`--recompile-verify-all` green.

## Credits

- [AssetStudio](https://github.com/Perfare/AssetStudio) — the shader-blob reader
  in `Shader Decompiler/Unity/Blob/` is vendored from it.
- [Vortice.Windows](https://github.com/amerkoleci/Vortice.Windows) — D3D compiler
  P/Invoke used for disassembly and recompilation.
- The reverse-engineering notes in `Shader Decompiler/Docs/` document the
  UnityShaderCompiler work this project is built on.

## License

No license is currently specified.
