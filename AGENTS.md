# AGENTS.md

Two-stage shader decompiler: Python extracts blobs from AssetStudio JSON exports, C# decompiles DXBC back to ShaderLab/HLSL.

## Commands

### Stage 0 — extract blob (Python, requires `lz4`)
```bash
pip install lz4
python Extract.py shaders_json/HOLO_Holo.json
```
Writes `Output/<Name>/{blob.bin, metadata.json, dummy.shader}`.

### Stage 1+ — decompile (C#)
```bash
cd "src/UnityShaderDecompiler.Cli"
dotnet restore "UnityShaderDecompiler.Cli.csproj"
dotnet build "UnityShaderDecompiler.Cli.csproj" -c Release
dotnet run --project "UnityShaderDecompiler.Cli.csproj" -- ../../Output/HOLO_Holo
```
Output goes to `src/UnityShaderDecompiler.Cli/Output/<Name>.shader`. With no
arguments the CLI looks for `Output/HOLO_Holo` in the working directory, then
one level up.

### Regression tests (C#, xUnit)
```bash
dotnet test UnityShaderDecompiler.sln

# Fast tier used by per-commit CI (no native d3dcompiler):
dotnet test UnityShaderDecompiler.sln --filter "Category!=D3D"

# Native d3dcompiler round-trips (Windows):
dotnet test UnityShaderDecompiler.sln --filter "Category=D3D"
```
The suite lives in `tests/UnityShaderDecompiler.Tests` and uses checked-in fixtures under `tests/Fixtures/` (blob.bin + metadata.json), so it needs no Python or network access. It ports the old spec vectors into individual xUnit cases and covers the whole in-process pipeline via `Parser.Decompiler`.

### Golden tests (Python, end-to-end)
```bash
python tests/e2e/test_picavoxel_shaders.py
```
Tests 4 PicaVoxel shaders end-to-end (Stage 0 + Stage 1+). Requires the C# binary to be built first (`dotnet build`). Defaults to `src/UnityShaderDecompiler.Cli/bin/Debug/net10.0/Shader Decompiler.exe`; pass `--parser` to override.

### Faithfulness tests (C# + Python)
```bash
# Single shader folder:
dotnet run --project "src/UnityShaderDecompiler.Cli/UnityShaderDecompiler.Cli.csproj" -- --faithfulness-test ../Output/HOLO_Holo

# All shaders in Output/:
python tests/e2e/test_faithfulness.py --parser "src/UnityShaderDecompiler.Cli/bin/Debug/net10.0/Shader Decompiler.exe"

# Filter to specific shaders:
python tests/e2e/test_faithfulness.py --filter PicaVoxel
```
Decompiles the blob, recompiles every HLSLPROGRAM block with d3dcompiler, compares input/output signatures against the shipped subprograms, and checks metadata fidelity (properties, fallback, cbuffer bindings). Reports PASS/FAIL per shader. Requires Windows + d3dcompiler_47.dll.

### Verification/analysis modes (C# CLI flags, run after build)
- `--run-spec-tests` — offline spec vectors (no D3D needed)
- `--verify-signatures [dir]` — ISGN vs d3dcompiler cross-check (Windows)
- `--strip-survivors` — D3DStripShader chunk analysis (Windows)
- `--recompile-verify [file]` / `--recompile-verify-all [dir]` — recompile HLSLPROGRAM blocks (Windows)
- `--disasm [dir]` — DXBC disassembly dumps (Windows)

## Requirements
- **Python 3.10+** with `lz4` (`pip install lz4`)
- **.NET SDK targeting `net10.0`**
- **Windows** with `d3dcompiler_47.dll` for D3D-backed modes (disasm, recompile, signatures, strip). Core pipeline is platform-neutral.

## Gotchas
- CI (`.github/workflows/ci-build-info.yml`) builds every push/PR on Windows, Linux, and macOS, runs `dotnet test --filter "Category!=D3D"`, and smoke-tests `--run-spec-tests`; nightly (`.github/workflows/nightly.yml`) publishes artifacts at 03:00 UTC only when `master` has commits in the previous 24h, then runs the full test tier plus the Windows golden e2e suite.
- `Program.cs` is only CLI dispatch. The pipeline lives in `src/UnityShaderDecompiler.Core/Decompiler.cs` (`Decompiler.Decompile` / `DecompileFolder`) and is the entry point tests should use.
- `AllowUnsafeBlocks` is enabled in both C# projects (pinned-buffer D3D calls).
- C# namespace is `Parser`, not `ShaderDecompiler`.
- Folder names are sanitized on Windows (`/` `\` → `_`, trailing dots/spaces stripped).
- With no arguments the CLI looks for `Output/HOLO_Holo` in the working directory, then one level up.
- Output location: `.shader` files go to `src/UnityShaderDecompiler.Cli/Output/` (the project's `ProjectOutputRoot`), not the repo-root `Output/`.
- Checked-in example decompilations live in `samples/`; the xUnit golden test compares against `samples/HOLO_Holo.shader`.
- Both Python runners auto-detect a `dotnet` install with a net10.0 runtime (explicit `DOTNET`, then PATH, then `~/.dotnet`), so they work locally and in CI without a hard-coded user path.
- Test fixtures are deliberately checked in under `tests/Fixtures/`; regenerate one with `python Extract.py shaders_json/<name>.json --out-dir Output` and copy the folder.
- `test_faithfulness.py` treats a decompiler crash or a missing `Result:` line as a hard failure (never a skip).
