# Unity Shader Decompiler

A small Unity shader parsing and DXBC inspection tool that extracts embedded DXBC blobs from Unity shader subprograms and produces DXBC disassembly and IR diagnostics.

This repository provides a console parser (Program.cs) and supporting DXBC parsing and IR builder code. It is not a complete high-level HLSL decompiler — the current output is DXBC disassembly (text produced by Vortice.D3DCompiler) and an intermediate representation (IR) constructed from parsed DXBC instructions.

Key points (accurate)
- The CLI reads a Unity shader "blob" (default path `../blob.bin`), enumerates ShaderSubProgram entries, and for each subprogram saves:
  - program{i}.bin — the raw Unity subprogram bytes
  - program{i}.dxbc — the extracted DXBC blob starting at the ASCII signature "DXBC"
  - program{i}.hlsl — currently this file contains the DXBC disassembly text (not reconstructed high-level HLSL source)
- Extraction is performed by DxbcExtractor (searches for the "DXBC" signature in the subprogram byte array).
- Disassembly is performed by DxbcDisassembler which calls into Vortice.D3DCompiler (native D3DCompiler) to produce assembly-like disassembly text.
- An IRBuilder exists and Program.cs uses it to produce an IRProgram from the loaded DxbcFile.Shader; the IR is printed to the console for inspection but is not currently emitted as high-level HLSL.

Stack
- Language(s): C# (primary), small HLSL snippets and DXBC data
- Target framework: net10.0 (see Parser.csproj)
- Notable libraries (from Parser.csproj):
  - Vortice.D3DCompiler (for disassembly)
  - K4os.Compression.LZ4
  - SevenZip

Repository layout (top-level, with accurate responsibilities)
```
Program.cs                CLI entrypoint; drives extraction, disassembly, IR build, and file output
Parser.csproj             .NET project file (TargetFramework: net10.0)
Decompiler/               Core decompilation helpers (interfaces and HLSL generator that currently delegates to disassembler)
  Disassemblers/          DxbcDisassembler.cs — wraps Vortice.D3DCompiler.Disassemble
  Extractors/             DxbcExtractor.cs — finds and slices the DXBC blob from subprogram bytes
  HLSL/                   HlslGenerator.cs — validates DXBC header and calls disassembler (returns text)
  Interfaces/             IDxbcDecompiler.cs
DXBC/                     DXBC parsing and IR
  Container/              DxbcFile, BinaryReader extensions for DXBC container handling
  Chunks/                 RDEF/ISGN/OSGN/STAT chunk parsers and related types
  Instructions/           DXBC opcode definitions and ShdrParser (parses tokens/instructions)
  IR/                     IRBuilder and IR data structures: builds IRProgram from parsed instructions
Unity/                    Unity blob parsing helpers (ShaderProgram, ShaderSubProgram, ShaderSubProgramEntry)
Output/                   Runtime output folder (generated files are created here by Program)
Tests/                    Placeholder for tests
```

How it fits together (runtime flow)
- Program.cs opens the provided blob and constructs an AssetStudio-style ShaderProgram which contains ShaderSubProgramEntry items and then reads ShaderSubProgram instances.
- For each ShaderSubProgram, Program saves the raw bytes and uses DxbcExtractor to find a "DXBC" sub-block.
- The extracted DXBC bytes are saved to disk and loaded into a DxbcFile which exposes chunks, InputSignature, and a parsed Shader (ShdrParser).
- IRBuilder consumes the parsed Shader (ShdrParser) and produces an IRProgram; this IR is printed for inspection.
- HlslGenerator.Decompile currently calls into DxbcDisassembler.Disassemble(dxbc) and returns the disassembly text (saved as .hlsl).

Build
Requirements
- .NET SDK that supports net10.0 (specified in Parser.csproj). Adjust the SDK if your environment targets a different runtime.
- The Vortice.D3DCompiler package requires access to the native D3DCompiler library (commonly available on Windows). On non-Windows platforms you must provide a compatible native library or run the disassembly step in an environment where D3DCompiler is available.

From repository root:
```bash
dotnet restore Parser.csproj
dotnet build Parser.csproj -c Release
```

Run
- The app accepts a single optional argument: the path to the Unity shader blob. If omitted it defaults to `../blob.bin`.

Example:
```bash
dotnet run --project Parser.csproj -- path/to/blob.bin
```

Outputs (written to Output/ by default)
- program{i}.bin  — raw subprogram bytes
- program{i}.dxbc — extracted DXBC blob
- program{i}.hlsl — DXBC disassembly text (not guaranteed to be valid high-level HLSL source)

Limitations & notes
- The project currently produces DXBC disassembly (assembly-like text), not reconstructed high-level HLSL. Although IRBuilder builds an IRProgram from parsed instructions, there is not yet a complete high-level HLSL emitter that reconstructs function/variable names and original HLSL syntax.
- Disassembly requires the native D3DCompiler library; in CI or cross-platform scenarios you may need to provide that native dependency or skip disassembly.
- Parser.csproj enables unsafe code (AllowUnsafeBlocks) because DxbcDisassembler pins the byte array and calls into native APIs.
- There is no LICENSE file in the repo — add one if you plan to publish the code.

Contributing
- Please open issues for bugs and feature requests.
- PRs are welcome. If you add an HLSL emitter or CI test, include a small sample blob and a smoke test that validates the output.

If you'd like, I will:
- Add an explicit note in the README that `program{i}.hlsl` contains DXBC disassembly until a high-level emitter is implemented.
- Add a small CI workflow that builds the project and optionally skips disassembly if native D3DCompiler is unavailable.
