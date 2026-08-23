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
cd "Shader Decompiler"
dotnet restore "Shader Decompiler.csproj"
dotnet build "Shader Decompiler.csproj" -c Release
dotnet run --project "Shader Decompiler.csproj" -- ../Output/HOLO_Holo
```
Output goes to `Shader Decompiler/Output/<Name>.shader`. Default input: `../Output/HOLO_Holo`.

### Golden tests (Python)
```bash
python Shader Decompiler/Tests/test_picavoxel_shaders.py
```
Tests 4 PicaVoxel shaders end-to-end (Stage 0 + Stage 1+). Requires the C# binary to be built first (`dotnet build`).

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
- The `.github/workflows/ci-build-info.yml` is outdated — references old `Parser.csproj` and `main` branch; actual project is `Shader Decompiler.csproj` on `master`.
- `AllowUnsafeBlocks` is enabled in the csproj (pinned-buffer D3D calls).
- C# namespace is `Parser`, not `ShaderDecompiler`.
- Folder names are sanitized on Windows (`/` `\` → `_`, trailing dots/spaces stripped).
- The decompiler defaults to `../Output/HOLO_Holo` when invoked with no arguments.
- Output location: `.shader` files go to `Shader Decompiler/Output/` (the project's `ProjectOutputRoot`), not the repo-root `Output/`.
- **Golden test binary path is stale**: `test_picavoxel_shaders.py` defaults `--parser` to `Parser/bin/Debug/net10.0/Parser.exe` (old project name). Pass the actual path after building: `python Shader Decompiler/Tests/test_picavoxel_shaders.py --parser "Shader Decompiler/bin/Debug/net10.0/Shader Decompiler.exe"`
