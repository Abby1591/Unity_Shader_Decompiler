# Shader Decompiler (Stage 1+) — Unity Shader Decompiler

This directory contains the C# (net10.0) backend of the Unity Shader Decompiler:
DXBC container parsing, SM4/SM5 instruction decoding, SSA IR construction and
optimization, pattern recognition, HLSL AST building, and full `.shader` output.

See the [project README](../README.md) for the pipeline overview, repository
layout, all CLI flags, and current status. Highlights:

- **Entry point:** `Program.cs` (blob classification → container parse → IR →
  SSA → optimization → AST → pretty print → surface-shader recognition, plus
  the verification/test modes).
- **Parse:** `DXBC/Container` (`DxbcFile`, chunks), `DXBC/Chunks`
  (ISGN/OSGN/PSGN/RDEF/SFI0/STAT), `DXBC/Instructions` (`ShdrParser`),
  `DXBC/Extraction` (`UnityShaderBlob` classifier).
- **IR & SSA:** `DXBC/IR` + `Core/Analysis` — CFG, dominators, dominance
  frontiers, phi insertion, renaming, verifier, leave-SSA; `Core/Optimizations`
  has ~20 passes run to a fixed point plus matrix/vector/texture/loop pattern
  recognition.
- **AST & emit:** `Core/Hlsl` — `HlslAstBuilder`, `HlslPrettyPrinter`,
  `HlslSurfaceShaderRecognizer`, `HlslNameRecovery`, `HlslFuseTemps`.
- **Tests:** `Tests/` — golden PicaVoxel tests (`test_picavoxel_shaders.py`),
  spec vectors, signature cross-check, strip-survivor analysis, recompile
  verification.
- **Unity blob reader:** `Unity/Blob/` (AssetStudio `ShaderProgram`,
  `ShaderSubProgram`).

Requires a .NET SDK targeting `net10.0`; `Vortice.D3DCompiler` (Windows) is
needed for disassembly/recompilation. `AllowUnsafeBlocks` is enabled for the
pinned-buffer D3D compiler calls. NuGet packages: `Unity` 5.11.10 (AssetStudio),
`Vortice.D3DCompiler` 3.8.3.

```bash
dotnet restore "Shader Decompiler.csproj"
dotnet build "Shader Decompiler.csproj" -c Release
dotnet run --project "Shader Decompiler.csproj" -- ../Output/HOLO_Holo
```