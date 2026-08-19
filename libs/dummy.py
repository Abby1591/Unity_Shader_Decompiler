"""
Stage 0.3 — Dummy Export Extraction

You already have AssetStudio's plain-text dummy exports sitting in
shaders_dummy/<Name>.shader — this just locates/copies the one matching
a given shader name so it travels alongside blob.bin + metadata.json.
Not used for correctness; only formatting/naming/debug reference.
"""

import shutil
from pathlib import Path


def find_dummy_shader(shader_name: str, dummy_dir: str) -> Path | None:
    dummy_dir = Path(dummy_dir)
    candidate = dummy_dir / f"{shader_name}.shader"
    if candidate.exists():
        return candidate

    # Unity shader names often use "/" as a category separator
    # (e.g. "Custom/Hologram Flicker") while filenames use "_".
    flattened = shader_name.replace("/", "_")
    candidate = dummy_dir / f"{flattened}.shader"
    if candidate.exists():
        return candidate

    return None


def copy_dummy_shader(shader_name: str, dummy_dir: str, out_path: str) -> bool:
    src = find_dummy_shader(shader_name, dummy_dir)
    if src is None:
        return False
    shutil.copyfile(src, out_path)
    return True