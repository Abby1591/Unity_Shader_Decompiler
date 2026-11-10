# Shader Decompiler (Stage 1+) — Unity Shader Decompiler

This directory contains the CLI half of the C# (net10.0) backend: argument
dispatch plus the verification harnesses (spec vectors, faithfulness,
signature cross-check, strip analysis, recompile verification).

The actual pipeline lives in
[`../UnityShaderDecompiler.Core`](../UnityShaderDecompiler.Core):
DXBC container parsing, SM4/SM5 instruction decoding, SSA IR construction and
optimization, pattern recognition, HLSL AST building, and full `.shader`
output.

See the [project README](../../README.md) for the pipeline overview, repository
layout, all CLI flags, and current status. Highlights:

- **Entry point:** `Program.cs` (CLI dispatch and verification modes).
- **Pipeline:** `UnityShaderDecompiler.Core/Decompiler.cs` — blob classification
  → container parse → IR → SSA → optimization → AST → pretty print →
  surface-shader recognition. This is the reusable API the tests call
  in-process.
- **Parse:** `DXBC/Container` (`DxbcFile`, chunks), `DXBC/Chunks`
  (ISGN/OSGN/PSGN/RDEF/SFI0/STAT), `DXBC/Instructions` (`ShdrParser`),
  `DXBC/Extraction` (`UnityShaderBlob` classifier).
- **IR & SSA:** `DXBC/IR` + `Core/Analysis` — CFG, dominators, dominance
  frontiers, phi insertion, renaming, verifier, leave-SSA; `Core/Optimizations`
  has ~20 passes run to a fixed point plus matrix/vector/texture/loop pattern
  recognition.
- **AST & emit:** `Core/Hlsl` — `HlslAstBuilder`, `HlslPrettyPrinter`,
  `HlslSurfaceShaderRecognizer`, `HlslNameRecovery`, `HlslFuseTemps`.
- **Verification:** `Verification/` — `--run-spec-tests`, `--faithfulness-test`,
  `--verify-signatures`, `--strip-survivors`, `--recompile-verify`.
- **Tests:** `tests/UnityShaderDecompiler.Tests` — xUnit regression suite
  (`dotnet test`), backed by checked-in `tests/Fixtures/`. `tests/e2e/` holds
  the Python end-to-end runners (Stage 0 + CLI).
- **Unity blob reader:** `Unity/Blob/` in Core (AssetStudio `ShaderProgram`,
  `ShaderSubProgram`).

Requires a .NET SDK targeting `net10.0`; `Vortice.D3DCompiler` (Windows) is
needed for disassembly/recompilation. `AllowUnsafeBlocks` is enabled for the
pinned-buffer D3D compiler calls. The only NuGet package is
`Vortice.D3DCompiler` 3.8.3; the Unity shader-blob reader (`Unity/Blob/`) is
vendored AssetStudio code.

```bash
# From the repository root
dotnet restore UnityShaderDecompiler.sln
dotnet build UnityShaderDecompiler.sln -c Release
dotnet run --project "src/UnityShaderDecompiler.Cli/UnityShaderDecompiler.Cli.csproj" -- Output/Corpus_01 Properties

# Regression suite
dotnet test UnityShaderDecompiler.sln
```
