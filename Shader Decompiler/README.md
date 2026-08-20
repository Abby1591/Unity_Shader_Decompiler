# Shader Decompiler (Stage 1+) — Unity Shader Decompiler

This directory contains the C# (net10.0) backend of the Unity Shader Decompiler:
DXBC container parsing, instruction decoding, SSA IR construction + optimization,
pattern recognition, the Stage 2 HLSL AST, and — since the pretty-printer landed —
full `.shader` emission with surface-shader recognition.

See the [project README](../README.md) for the full pipeline overview, repository
layout, build/run instructions, CLI flags, and current status. Highlights:

- **Entry point:** `Program.cs` (drives extraction → disassembly → IR → AST →
  pretty printing, plus the verification/test modes).
- **Parse:** `DXBC/Container` (DxbcFile, chunks), `DXBC/Chunks` (RDEF/ISGN/OSGN/SFI0/STAT),
  `DXBC/Instructions` (opcode table, `ShdrParser`, operands), `DXBC/Extraction`
  (`UnityShaderBlob`), `Unity/Blob` (Unity subprogram model).
- **IR & SSA:** `DXBC/IR` and `Core/Analysis` — CFG, dominators, phi insertion,
  renaming, verifier, leave-SSA; ~20 optimization passes + pattern recognition in
  `Core/Optimizations`.
- **AST & emit:** `Core/Hlsl` — `HlslAST`, `HlslAstBuilder`, `HlslRenderstateBuilder`,
  `HlslStatement`, `HlslPrettyPrinter`, `HlslSurfaceShaderRecognizer`.
- **Tests:** `Tests/` — golden PicaVoxel tests (`test_picavoxel_shaders.py`),
  spec vectors, signature cross-check, strip-survivor analysis, and the
  recompile-verification harness.
- **Outputs:** `Output/<Name>.shader` — full reconstructed ShaderLab source
  (default write location). `--save-subprograms` additionally writes
  `program{i}.{bin,dxbc,hlsl}`; the `.hlsl` artifact is DXBC disassembly, not
  reconstructed HLSL.

Requires a .NET SDK supporting `net10.0` and the `Vortice.D3DCompiler` native
library (Windows). `AllowUnsafeBlocks` is enabled for the disassembler's pinned
buffer call. NuGet packages: `Unity 5.11.10` (AssetStudio), `Vortice.D3DCompiler 3.8.3`.

```bash
dotnet restore "Shader Decompiler.csproj"
dotnet build "Shader Decompiler.csproj" -c Release
dotnet run --project "Shader Decompiler.csproj" -- path/to/output-folder
```