# Unity Shader Decompiler

A Unity shader decompiler built on top of AssetStudio concepts. This tool locates DXBC shader blobs embedded in Unity shader binary programs, disassembles them, builds a small IR, and attempts to reconstruct readable HLSL.

This repository contains a console parser (Program.cs) that extracts DXBC blobs from Unity shader subprograms and writes outputs to the Output/ directory.

## Features
- Locate and extract DXBC blobs from Unity shader subprograms (DxbcExtractor).
- Disassemble DXBC using Vortice.D3DCompiler (DxbcDisassembler).
- Build a simple IR and generate HLSL text (IRBuilder + HlslGenerator).
- Save raw program, extracted DXBC, and generated HLSL to Output/.

## Stack
- Language(s): C# (primary), small HLSL snippets
- Target framework: .NET 10.0 (see Parser.csproj)
- Notable libraries:
  - Vortice.D3DCompiler (DXBC disassembly)
  - K4os.Compression.LZ4 (used elsewhere in repo)
  - SevenZip (used elsewhere in repo)

## Repository layout (top-level)
```
Program.cs           CLI entrypoint that drives extraction and decompilation
Parser.csproj        .NET project file (TargetFramework: net10.0)
Decompiler/          Core decompilation components
  Disassemblers/     DXBC disassembler (DxbcDisassembler.cs)
  Extractors/        Blob extraction from Unity subprograms (DxbcExtractor.cs)
  HLSL/              HLSL generation (HlslGenerator.cs)
  Interfaces/        Decompiler interfaces (IDxbcDecompiler.cs)
DXBC/                DXBC parsing helpers and chunk implementations
  Container/         DXBC container reading helpers (DxbcFile, Reader extensions)
  Chunks/            RDEF/ISGN/OSGN/STAT chunk parsing implementations
  IR/                Intermediate representation (IRBuilder consumes these)
  Instructions/      Instruction definitions/parsing
Output/              Generated files (created at runtime)
Unity/               Unity-related helpers or integration (inspect for Unity-specific code)
Tests/               Tests placeholder
```

## How it fits together
- Program.cs reads a Unity shader blob (default `../blob.bin` or provided path), constructs a ShaderProgram and enumerates subprograms.
- For each subprogram the code saves the raw program bytes, attempts to locate a DXBC blob with DxbcExtractor, writes the DXBC to disk, and uses DxbcFile + IRBuilder to build an IR.
- HlslGenerator calls into DxbcDisassembler (which uses Vortice.D3DCompiler) to disassemble DXBC; the resulting text is saved as `program{i}.hlsl`.

## Build
Requirements
- .NET SDK that supports net10.0 (check Parser.csproj for the exact target). 
- Native D3DCompiler support for Vortice.D3DCompiler (commonly available on Windows via system DLLs). If you are not on Windows you may need the appropriate D3DCompiler native library available to the runtime.

From repository root:
```bash
# restore & build
dotnet restore Parser.csproj
dotnet build Parser.csproj -c Release
```

## Run
The console application expects a path to a Unity shader blob. If no argument is provided it defaults to `../blob.bin`.

Example:
```bash
# run with an explicit blob
dotnet run --project Parser.csproj -- path/to/blob.bin

# or, after building, run the produced executable (platform-dependent)
# outputs are written to the Output/ directory: program{i}.bin, program{i}.dxbc, program{i}.hlsl
```

Notes from the code
- Program.cs creates the Output/ directory and writes files named `program{i}.bin`, `program{i}.dxbc`, and `program{i}.hlsl`.
- DxbcExtractor searches for the ASCII signature "DXBC" inside the subprogram program bytes and copies the remaining bytes starting at that offset.
- HlslGenerator validates the DXBC header then delegates to DxbcDisassembler.Disassemble.
- DxbcDisassembler performs an unsafe fixed-pointer call into `Vortice.D3DCompiler.Compiler.Disassemble` and returns the disassembly as text.

## Limitations & platform notes
- The disassembly step uses Vortice.D3DCompiler and likely requires the native D3DCompiler library available on your system (commonly Windows-only). Running the disassembler on other platforms may require providing a compatible native library.
- Parser.csproj enables AllowUnsafeBlocks; the disassembler uses unsafe code.
- There is no LICENSE file in the repository root — add one if you intend to open-source this project.

## Contributing
- Open issues for bugs and feature requests.
- Branch from the default branch and open a PR with a clear description and tests where applicable.

## Next steps I can do for you
- Commit this README.md to the repository (I will do that now).
- Extend the README with example DXBC blobs and a small CI smoke test that runs the parser against a sample blob.
- Add a LICENSE file if you want to make the project explicitly open-source.
