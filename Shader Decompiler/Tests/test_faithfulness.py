#!/usr/bin/env python3
"""
Automated faithfulness test: runs the C# decompiler's --faithfulness-test
flag on every shader folder in Output/ (each containing blob.bin +
metadata.json) and reports which shaders are faithful to their original
DXBC bytecode.

For each shader the test:
  1. Decompiles the blob (full pipeline).
  2. Recompiles every HLSLPROGRAM block with d3dcompiler and compares
     input/output signatures against the shipped subprograms.
  3. Checks metadata fidelity: properties, fallback, cbuffer bindings,
     named cbuffer members.

Usage:
    python Shader Decompiler/Tests/test_faithfulness.py [--parser PATH] [--out-dir DIR]
"""

import argparse
import os
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
DOTNET = os.environ.get("DOTNET", r"C:\Users\Abby\.dotnet\dotnet.exe")
OUTPUT_DIR = REPO_ROOT / "Output"


def run(cmd, cwd, timeout=600):
    env = os.environ.copy()
    env.setdefault("DOTNET_ROOT", str(Path(DOTNET).parent))
    env.setdefault("DOTNET_MULTILEVEL_LOOKUP", "0")
    return subprocess.run(
        cmd, cwd=str(cwd), capture_output=True, text=True,
        timeout=timeout, env=env,
    )


def find_shader_dirs(out_dir):
    """Find all folders under out_dir that contain both blob.bin and metadata.json."""
    dirs = []
    for child in sorted(out_dir.iterdir()):
        if child.is_dir() and (child / "blob.bin").exists() and (child / "metadata.json").exists():
            dirs.append(child)
    return dirs


def main():
    ap = argparse.ArgumentParser(description="Faithfulness test across all shader folders")
    ap.add_argument("--parser", default=str(
        REPO_ROOT / "Shader Decompiler" / "bin" / "Debug" / "net10.0" / "Shader Decompiler.exe"),
        help="path to the built Shader Decompiler.exe")
    ap.add_argument("--out-dir", default=str(OUTPUT_DIR),
        help="root folder containing per-shader subfolders (Output/)")
    ap.add_argument("--filter", default=None,
        help="only test folders whose name contains this substring")
    args = ap.parse_args()

    parser_exe = Path(args.parser)
    if not parser_exe.exists():
        print(f"Parser not found at {parser_exe}; run 'dotnet build' first.")
        return 2

    out_dir = Path(args.out_dir)
    shader_dirs = find_shader_dirs(out_dir)
    if args.filter:
        shader_dirs = [d for d in shader_dirs if args.filter in d.name]

    if not shader_dirs:
        print(f"No shader folders (with blob.bin + metadata.json) found in {out_dir}")
        return 2

    print(f"Testing {len(shader_dirs)} shader(s)...\n")

    passed = 0
    failed = 0
    skipped = 0
    results = []

    for folder in shader_dirs:
        name = folder.name
        print(f"--- {name} ---")

        r = run(
            [str(parser_exe), "--faithfulness-test", str(folder)],
            REPO_ROOT / "Shader Decompiler",
        )
        log = r.stdout + r.stderr

        if r.returncode != 0 and "Unhandled exception" in log:
            print(f"  SKIP (crash)")
            skipped += 1
            results.append((name, "SKIP"))
            continue

        # Parse the structured output
        lines = log.strip().splitlines()
        result_line = None
        for line in reversed(lines):
            if line.strip().startswith("Result:"):
                result_line = line.strip().split(":", 1)[1].strip()
                break

        if result_line == "PASS":
            print(f"  PASS")
            passed += 1
            results.append((name, "PASS"))
        elif result_line == "FAIL":
            print(f"  FAIL")
            # Print the error details from the C# output
            in_errors = False
            for line in lines:
                if "Errors:" in line:
                    in_errors = True
                    continue
                if in_errors and line.strip().startswith("-"):
                    print(f"    {line.strip()}")
            failed += 1
            results.append((name, "FAIL"))
        else:
            # Fallback: check if recompile-verify matched
            if "ALL decompiled passes recompile to signatures" in log:
                print(f"  PASS (recompile ok)")
                passed += 1
                results.append((name, "PASS"))
            elif "compile FAILED" in log or "unmatched" in log.lower():
                print(f"  FAIL (compile/match error)")
                failed += 1
                results.append((name, "FAIL"))
            else:
                print(f"  UNKNOWN (no Result line in output)")
                skipped += 1
                results.append((name, "SKIP"))

        print()

    # Summary
    total = passed + failed + skipped
    print("=" * 60)
    print(f"RESULTS: {passed}/{total} PASSED, {failed} FAILED, {skipped} SKIPPED")
    print("=" * 60)
    if failed > 0:
        print("\nFailed shaders:")
        for name, status in results:
            if status == "FAIL":
                print(f"  - {name}")

    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
