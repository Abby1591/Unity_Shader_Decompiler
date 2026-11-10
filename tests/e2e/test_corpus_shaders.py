#!/usr/bin/env python3
"""
Golden end-to-end tests for the checked-in Unity 6 shader corpus.

For every JSON in shaders_json/ the runner:

  1. Runs Stage 0 (Extract.py) to produce Output/<name>/blob.bin +
     metadata.json (+ the matching dummy.shader from shaders_dummy/).
  2. Runs the Stage 1+ decompiler on that folder.
  3. Asserts the decompiled .shader preserves the facts that are derivable
     from the JSON metadata (shader name, properties, fallback, cbuffer
     slots, named cbuffer members) and that the pipeline completed without
     an unhandled exception.

Cbuffer slots are satisfied either by an explicit `register(bN)` or by a
generated name ending in `bN` (e.g. `cbuffer _UnityPerDrawCB_b0`). Metadata
lists every member of every cbuffer, while the emitted HLSL only declares
members the shipped bytecode actually reads, so the member check requires at
least one named member rather than all of them.

Expected values are read from the JSON export itself (the true input), so
this stays in sync with the corpus rather than hard-coding stale facts.

Usage:
    python "tests/e2e/test_corpus_shaders.py" [--keep] [--parser PATH]
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


def find_dotnet():
    """Pick a dotnet install that can run the net10.0 apphost."""
    candidates = []
    if os.environ.get("DOTNET"):
        candidates.append(os.environ["DOTNET"])
    which = shutil.which("dotnet")
    if which:
        candidates.append(which)
    home = Path.home() / ".dotnet" / ("dotnet.exe" if os.name == "nt" else "dotnet")
    candidates.append(str(home))

    for candidate in candidates:
        if not Path(candidate).exists():
            continue
        try:
            out = subprocess.run(
                [candidate, "--list-runtimes"],
                capture_output=True, text=True, timeout=30,
            ).stdout
        except Exception:
            continue
        if "Microsoft.NETCore.App 10." in out:
            return candidate
    return candidates[0]


DOTNET = find_dotnet()


def safe_folder_name(name: str) -> str:
    return name.replace("/", "_").replace("\\", "_").rstrip(" .")


def run(cmd, cwd, timeout=900):
    env = os.environ.copy()
    # The built apphost only finds the .NET runtime via DOTNET_ROOT when the
    # default install lacks the net10.0 runtime.
    if os.path.isabs(DOTNET):
        env.setdefault("DOTNET_ROOT", str(Path(DOTNET).parent))
        env.setdefault("DOTNET_MULTILEVEL_LOOKUP", "0")
    return subprocess.run(cmd, cwd=str(cwd), capture_output=True, text=True, timeout=timeout, env=env)


def load_metadata(blob_folder):
    with open(blob_folder / "metadata.json", encoding="utf-8") as f:
        return json.load(f)


def output_shader_path(meta, parser_out):
    # Decompiler.SafeFileName: replaces Path.GetInvalidFileNameChars()
    name = meta["name"]
    invalid = '<>:"/\\|?*'
    safe = "".join("_" if c in invalid else c for c in name).rstrip(" .")
    return parser_out / f"{safe}.shader"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--keep", action="store_true",
                    help="do not delete the extracted Output/<name> folders at the end")
    ap.add_argument("--parser",
                    default=str(REPO_ROOT / "src" / "UnityShaderDecompiler.Cli" / "bin" / "Debug" / "net10.0" / "Shader Decompiler.exe"),
                    help="path to the built Shader Decompiler.exe")
    ap.add_argument("--out-root", default=str(OUT_DIR),
                    help="root folder that Extract.py writes into")
    ap.add_argument("--filter", default=None,
                    help="only run JSON files whose stem contains this substring")
    args = ap.parse_args()

    parser_exe = Path(args.parser)
    out_root = Path(args.out_root)
    # The parser resolves its output via ProjectOutputRoot(): it walks up from
    # the executable to the C# project folder's Output/ regardless of launch
    # cwd, so the .shader lands in <project>/Output (visible in the IDE).
    parser_out = REPO_ROOT / "src" / "UnityShaderDecompiler.Cli" / "Output"
    parser_out.mkdir(parents=True, exist_ok=True)

    if not parser_exe.exists():
        print(f"Parser.exe not found at {parser_exe}; run 'dotnet build' first.")
        return 2

    json_paths = sorted(JSONS_DIR.glob("*.json"))
    if args.filter:
        json_paths = [p for p in json_paths if args.filter in p.stem]
    if not json_paths:
        print(f"No shader JSONs found in {JSONS_DIR}")
        return 2

    failures = 0

    for json_path in json_paths:
        label = json_path.stem
        blob_folder = out_root / safe_folder_name(label)

        # Stage 0: re-extract so the test is hermetic (blob + metadata).
        r = run([sys.executable, str(EXTRACT), str(json_path), "--out-dir", str(out_root)], REPO_ROOT)
        if r.returncode != 0:
            print(f"[{label}] FAIL: Extract.py errored:\n{r.stderr}")
            failures += 1
            continue

        meta = load_metadata(blob_folder)

        # Stage 1+: decompile. The parser writes the final .shader into the
        # C# project's Output/ (ProjectOutputRoot), independent of launch cwd.
        r = run([str(parser_exe), str(blob_folder)],
                REPO_ROOT / "src" / "UnityShaderDecompiler.Cli")
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

        # 4. Every cbuffer slot from metadata must be represented, either as
        #    an explicit register(bN) or as a generated name ending in bN.
        cbs = []
        for ss in meta["subShaders"]:
            for p in ss.get("passes", []):
                cbs.extend(p.get("constantBuffers", []))
        slots = sorted({cb["slot"] for cb in cbs})
        for slot in slots:
            if re.search(rf"register\(b{slot}\)", text) is None \
               and re.search(rf"cbuffer\s+[\w$]*b{slot}\b", text) is None:
                errors.append(f"missing cbuffer slot b{slot}")

        # 5. Metadata lists all members; the bytecode only uses a subset, so
        #    require that at least one named member survives to the output.
        named = sorted({v["name"] for cb in cbs for v in cb.get("variables", [])})
        if named and not any(re.search(rf"\b{re.escape(v)}\b", text) for v in named):
            errors.append("no named cbuffer members emitted")

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
        print(f"{failures} of {len(json_paths)} tests FAILED")
        return 1
    print(f"All {len(json_paths)} tests PASSED")
    return 0


if __name__ == "__main__":
    sys.exit(main())
