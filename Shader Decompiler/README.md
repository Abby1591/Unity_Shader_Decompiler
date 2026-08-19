# Parser (Stage 1+) — Unity Shader Decompiler

This directory contains the C# (net10.0) backend of the Unity Shader Decompiler:
DXBC container parsing, instruction decoding, SSA IR construction + optimization,
pattern recognition, and the Stage 2 HLSL AST.

See the [project README](../README.md) for the full pipeline overview, repository
layout, build/run instructions, and current status. Highlights:

- **Entry point:** `Program.cs` (drives extraction → disassembly → IR → AST).
- **Parse:** `DXBC/Container` (DxbcFile, chunks), `DXBC/Chunks` (RDEF/ISGN/OSGN/STAT),
  `DXBC/Instructions` (opcode table, `ShdrParser`, operands).
- **IR & SSA:** `DXBC/IR` — CFG, dominators, phi insertion, renaming, verifier,
  leave-SSA, ~20 optimization passes in `Optimizations/`, pattern recognition.
- **AST:** `DXBC/HLSL` — `HlslAST`, `HlslAstBuilder`, `HlslRenderstateBuilder`,
  `HlslStatement` (structured statement tree).
- **Outputs:** `Output/program{i}.{bin,dxbc,hlsl}` — note `.hlsl` currently contains
  DXBC disassembly, not reconstructed HLSL source.

Requires a .NET SDK supporting `net10.0` and the `Vortice.D3DCompiler` native
library (Windows). `AllowUnsafeBlocks` is enabled for the disassembler's pinned
buffer call.

```bash
dotnet restore Parser.csproj
dotnet build Parser.csproj -c Release
dotnet run --project Parser.csproj -- path/to/output-folder
```
