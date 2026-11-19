# `UnityShaderCompiler.exe` decompilation archive

Raw decompiler output for every function of the shader compilation pipeline
described in [`../shader_compiler_analysis.md`](../shader_compiler_analysis.md).
The prose there explains the pipeline; these files are the evidence, so the
analysis can be re-checked without opening Ghidra again.

- **Target**: `Unity 6` `UnityShaderCompiler.exe` from
  `Editor/Data/Tools/`, image base `0x140000000`.
- **Source**: Ghidra decompiler, one function at a time.
- **Edits**: none. Function names and the leading comment block are the
  annotations stored in the Ghidra database; everything else is unmodified
  decompiler output (`uVar`/`param_` naming, `FUN_` calls and warnings
  included). A `FUN_` heading means that function was deliberately left
  unnamed — see the note under the matching group in §12 of the analysis.

| File | Contents | Functions |
|---|---|---|
| [`01-transport.md`](01-transport.md) | worker loop, command dispatcher, IPC frame magic, stream read/write | 6 |
| [`02-handlers.md`](02-handlers.md) | the eight `Cmd: …` handlers | 8 |
| [`03-source.md`](03-source.md) | frontends, pragma parser, preprocessor, stage split/validation, response assembly | 18 |
| [`04-surface.md`](04-surface.md) | surface shader expansion and pass emission | 14 |
| [`05-compilers.md`](05-compilers.md) | plugin slots, FXC compile/reflect/strip, DXC driver, disassembly, kernel lookup | 14 |
| [`06-d3dcompiler.md`](06-d3dcompiler.md) | `D3DCompiler_47.dll` loader and its seven wrapper stubs | 8 |

Notes on reading the output:

- `0x1400cc6d0` (`CmdDispatcher_Dispatch`, in `01-transport.md`) is the largest
  body in the archive by far: the command comparisons are inlined into an
  unrolled `strcmp` chain, so most of it is byte-shuffling rather than logic.
  Use §2 of the analysis for the command order and read the body only for the
  argument a handler receives.
- The surface shader generator emits source by building small `Utf8String`
  objects; string literals appear as integer constants (for example
  `0x49434e4154534e49` is `"INSTANCING_ON"`).
- GLSL, Metal, WGSL and SPIR-V paths are included for completeness only. This
  project consumes the D3D path, and those bodies were not analysed further.

To regenerate against a future build, decompile the addresses listed in §12 of
the analysis with the same tool and keep the names from the Ghidra database.
Addresses will move between Unity versions; the names are what stay stable.
