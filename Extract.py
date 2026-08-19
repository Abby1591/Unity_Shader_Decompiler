"""
Stage 0 — Frontend / Preprocessing orchestrator.

For a given shader JSON export, produces the three inputs Program.cs (C#)
now expects, all in one per-shader output folder:

    Output/<ShaderName>/blob.bin
    Output/<ShaderName>/metadata.json
    Output/<ShaderName>/dummy.shader   (if a match exists)

Usage:
    python Extract.py shaders_json/HOLO_Holo.json
    python Extract.py shaders_json/HOLO_Holo.json --dummy-dir shaders_dummy
"""

import argparse
import sys
from pathlib import Path

from libs.blob import ShaderBlob
from libs.metadata import ShaderMetadata
from libs.dummy import copy_dummy_shader


def safe_folder_name(name: str) -> str:
    # Windows drops trailing dots/spaces when creating directories, so the
    # extracted folder must not end in them or blob.bin can't be written.
    return name.replace("/", "_").replace("\\", "_").rstrip(" .")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("json_path", help="Path to the AssetStudio shader JSON export")
    ap.add_argument("--dummy-dir", default="shaders_dummy",
                     help="Directory of AssetStudio plain-text dummy exports")
    ap.add_argument("--out-dir", default="Output", help="Root output directory")
    ap.add_argument("--flat", action="store_true",
                     help="write blob.bin/metadata.json/dummy.shader directly into --out-dir "
                          "(no per-shader subfolder)")
    args = ap.parse_args()

    json_path = Path(args.json_path)
    if not json_path.exists():
        print(f"Not found: {json_path}")
        sys.exit(1)

    # 0.1 — blob
    shader = ShaderBlob(str(json_path))
    blob = shader.get_blob()

    out_dir = Path(args.out_dir)
    if not args.flat:
        out_dir = out_dir / safe_folder_name(shader.name)
    out_dir.mkdir(parents=True, exist_ok=True)

    blob_path = out_dir / "blob.bin"
    with open(blob_path, "wb") as f:
        f.write(blob)
    print(f"Saved {blob_path} ({len(blob)} bytes)")

    # 0.2 — metadata
    meta = ShaderMetadata(str(json_path))
    meta_path = out_dir / "metadata.json"
    meta.save(str(meta_path))
    print(f"Saved {meta_path}")

    # 0.3 — dummy shader (best effort, not required)
    dummy_path = out_dir / "dummy.shader"
    if copy_dummy_shader(shader.name, args.dummy_dir, str(dummy_path)):
        print(f"Saved {dummy_path}")
    else:
        print(f"No dummy export found for '{shader.name}' in {args.dummy_dir}")

    print()
    print(f"Ready for C# side:")
    print(f"  Parser.exe \"{blob_path}\"")


if __name__ == "__main__":
    main()