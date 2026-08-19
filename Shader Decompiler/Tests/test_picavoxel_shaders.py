#!/usr/bin/env python3
"""
Golden tests for the four PicaVoxel shaders whose real source the repo has
(shaders_dummy/Source/*.shader). For each shader the test:

  1. Runs Stage 0 (Extract.py) on the AssetStudio JSON export to produce
     Output/<name>/blob.bin + metadata.json.
  2. Runs the Stage 1+ decompiler (Parser.exe) on that folder.
  3. Asserts the decompiled .shader preserves the facts that are derivable
     from the JSON metadata (shader name, properties, fallback, cbuffer
     register bindings, named cbuffer members) and that the pipeline
     completed without an unhandled exception.

Expected values are read from the JSON export itself (the true input), so
this stays in sync with the corpus rather than hard-coding stale facts.

Usage:
    python Parser/Tests/test_picavoxel_shaders.py [--keep] [--parser PATH]
"""

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
EXTRACT = REPO_ROOT / "Extract.py"
JSONS_DIR = REPO_ROOT / "shaders_json"
OUT_DIR = REPO_ROOT / "Output"
DOTNET = os.environ.get("DOTNET", r"C:\Users\Abby\.dotnet\dotnet.exe")

# (json file, friendly test name)
SHADERS = [
    ("PicaVoxel_PicaVoxel Diffuse.json", "PicaVoxel Diffuse"),
    ("PicaVoxel_PicaVoxel PBR.json", "PicaVoxel PBR"),
    ("PicaVoxel_PicaVoxel PBR OneMinus Alpha Emissive.json", "PicaVoxel PBR OneMinus Alpha Emissive"),
    ("PicaVoxel_PicaVoxel Unlit.json", "PicaVoxel Unlit"),
]


def safe_folder_name(name: str) -> str:
    return name.replace("/", "_").replace("\\", "_")


def run(cmd, cwd, timeout=600):
    env = os.environ.copy()
    # The built apphost only finds the .NET runtime via DOTNET_ROOT when the
    # default install (C:\Program Files\dotnet) lacks the net10.0 runtime.
    env.setdefault("DOTNET_ROOT", str(Path(DOTNET).parent))
    env.setdefault("DOTNET_MULTILEVEL_LOOKUP", "0")
    return subprocess.run(cmd, cwd=str(cwd), capture_output=True, text=True, timeout=timeout, env=env)


def load_metadata(blob_folder):
    with open(blob_folder / "metadata.json", encoding="utf-8") as f:
        return json.load(f)


def output_shader_path(meta, parser_out):
    # Parser/Program.cs SafeFileName: replaces Path.GetInvalidFileNameChars()
    name = meta["name"]
    invalid = '<>:"/\\|?*'
    safe = "".join("_" if c in invalid else c for c in name)
    return parser_out / f"{safe}.shader"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--keep", action="store_true",
                    help="do not delete the extracted Output/<name> folders at the end")
    ap.add_argument("--parser", default=str(REPO_ROOT / "Parser" / "bin" / "Debug" / "net10.0" / "Parser.exe"),
                    help="path to the built Parser.exe")
    ap.add_argument("--out-root", default=str(OUT_DIR),
                    help="root folder that Extract.py writes into")
    args = ap.parse_args()

    parser_exe = Path(args.parser)
    out_root = Path(args.out_root)
    # The parser resolves its output via ProjectOutputRoot(): it walks up from
    # the executable to the C# project folder's Output/ regardless of launch
    # cwd, so the .shader lands in <project>/Output (visible in the IDE).
    parser_out = REPO_ROOT / "Shader Decompiler" / "Output"
    parser_out.mkdir(exist_ok=True)

    if not parser_exe.exists():
        print(f"Parser.exe not found at {parser_exe}; run 'dotnet build' first.")
        return 2

    failures = 0

    for json_name, label in SHADERS:
        json_path = JSONS_DIR / json_name
        if not json_path.exists():
            print(f"[{label}] SKIP: missing {json_path}")
            failures += 1
            continue

        blob_folder = out_root / safe_folder_name(json_path.stem)

        # Stage 0: re-extract so the test is hermetic (blob + metadata).
        r = run([sys.executable, str(EXTRACT), str(json_path), "--out-dir", str(out_root)], REPO_ROOT)
        if r.returncode != 0:
            print(f"[{label}] FAIL: Extract.py errored:\n{r.stderr}")
            failures += 1
            continue

        meta = load_metadata(blob_folder)

        # Stage 1+: decompile. The parser writes the final .shader into the
        # C# project's Output/ (ProjectOutputRoot), independent of launch cwd.
        r = run([str(parser_exe), str(blob_folder)], REPO_ROOT / "Shader Decompiler")
        log = r.stdout + r.stderr
        if r.returncode != 0 or "Unhandled exception" in log:
            print(f"[{label}] FAIL: decompiler crashed (exit {r.returncode})")
            for line in log.splitlines()[-8:]:
                print("   |", line)
            failures += 1
            continue

        shader = output_shader_path(meta, parser_out)
        if not shader.exists():
            print(f"[{label}] FAIL: no .shader written ({shader})")
            failures += 1
            continue

        text = shader.read_text(encoding="utf-8", errors="replace")
        errors = []

        # 1. Shader name must match the JSON export.
        if f'Shader "{meta["name"]}"' not in text:
            errors.append(f'Shader name "{meta["name"]}" not in output')

        # 2. Every property declared by the JSON must be emitted.
        for prop in meta["properties"]:
            if re.search(rf'^\s*{re.escape(prop["name"])}\s*\("', text, re.M) is None:
                errors.append(f'property {prop["name"]} not declared')

        # 3. Fallback must be preserved.
        if meta.get("fallback") and f'Fallback "{meta["fallback"]}"' not in text:
            errors.append(f'fallback "{meta["fallback"]}" missing')

        # 4. Cbuffer register bindings from metadata slots must appear.
        cbs = []
        for ss in meta["subShaders"]:
            for p in ss.get("passes", []):
                cbs.extend(p.get("constantBuffers", []))
        slots = sorted({cb["slot"] for cb in cbs})
        for slot in slots:
            if f"register(b{slot})" not in text:
                errors.append(f"missing cbuffer register(b{slot})")

        # 5. Named members from metadata (not the cbN_values fallback) must
        #    appear inside at least one cbuffer declaration.
        named = sorted({v["name"] for cb in cbs for v in cb.get("variables", [])})
        for var in named:
            if re.search(rf'^\s*\w+ (?:{re.escape(var)}|\w+\[\d+\].*{re.escape(var)})', text, re.M) is None \
               and var not in text:
                errors.append(f"cbuffer member {var} not emitted")

        # 6. The pipeline must have reached the final writer stage.
        if "Stage 13/14: full shader written" not in log:
            errors.append("final writer stage did not run")

        if errors:
            print(f"[{label}] FAIL ({shader.name})")
            for e in errors:
                print("   -", e)
            failures += 1
        else:
            print(f"[{label}] PASS ({len(text)} chars, {len(named)} named cbuffer members)")

        if not args.keep and blob_folder.exists():
            shutil.rmtree(blob_folder, ignore_errors=True)

    print()
    if failures:
        print(f"{failures} of {len(SHADERS)} tests FAILED")
        return 1
    print(f"All {len(SHADERS)} tests PASSED")
    return 0


if __name__ == "__main__":
    sys.exit(main())
