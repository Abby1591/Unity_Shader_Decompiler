#!/usr/bin/env python3
"""
Source-fidelity tests: decompiled output vs the original ShaderLab source.

test_corpus_shaders.py checks the output against metadata.json, which is
derived from the same build the decompiler reads. That catches regressions
but cannot catch a Stage-0 extraction bug: both sides would agree.

This runner uses the original sources (copied to tests/Sources/ from
ShaderCorpus/Assets/ShaderCorpus/Shaders) as an independent oracle for the
facts that survive compilation:

  - shader name
  - properties (name, description, type, numeric default)
  - fallback
  - SubShader count and SubShader-level tags
  - pass count
  - per-pass render state: Cull, ZWrite, ZTest, ZClip, Blend, BlendOp,
    ColorMask, Offset, AlphaToMask, Lighting, Stencil

Facts the shipped build does not carry are deliberately not compared:

  - LOD: serialized as 0 (stripped from the player build)
  - Pass Name: serialized as ""
  - property attributes ([Header], [Enum], ...): not serialized
  - texture defaults ("white"/"black"/"bump"): serialized as ""
  - Stencil Ref/ReadMask/WriteMask written as [Property]: the build stores
    the unresolved value 0
  - surface shaders: Unity expands one surface pass into several passes,
    so pass count and per-pass state are not comparable

Usage:
    python "tests/e2e/test_source_fidelity.py" [--keep] [--parser PATH]
                                               [--filter SUBSTRING]
"""

import argparse
import re
import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from test_corpus_shaders import (  # noqa: E402
    JSONS_DIR,
    OUT_DIR,
    REPO_ROOT,
    load_metadata,
    output_shader_path,
    run,
    safe_folder_name,
)

EXTRACT = REPO_ROOT / "Extract.py"
SOURCES_DIR = REPO_ROOT / "tests" / "Sources"
PARSER_OUT = REPO_ROOT / "src" / "UnityShaderDecompiler.Cli" / "Output"

# Pass structure that legitimately differs from the source, with the reason.
STRUCTURE_EXCEPTIONS = {
    "Corpus/14 Shadow Depth Meta Motion":
        "a pass without a DXBC program (Meta) is dropped by the emitter",
}

UNKNOWN = object()  # value resolved at draw time (material property reference)
TEXTURE_TYPES = {"2d", "3d", "cube", "cube array", "2darray", "3darray", "any"}
DEFAULT_STATE = {
    "cull": "back",
    "zwrite": True,
    "ztest": "lequal",
    "zclip": True,
    "blend": ("one", "zero", "one", "zero"),
    "blendop": ("add", "add"),
    "colormask": frozenset("rgba"),
    "offset": (0.0, 0.0),
    "alphatomask": False,
    "lighting": False,
}

PASS_RE = re.compile(r'(?m)^[ \t]*(Pass|GrabPass)\b(?=[ \t]*(?:\{|$|"))')
USEPASS_RE = re.compile(r"(?m)^[ \t]*UsePass\b")
PROP_RE = re.compile(r'(?m)^[ \t]*(?:\[[^\]]*\][ \t]*)*(\w+)[ \t]*\((.*)\)[ \t]*=[ \t]*(.*?)[ \t]*$')


def block_after(text, pos):
    """Return the contents of the brace block that follows pos."""
    start = text.find("{", pos)
    if start < 0:
        return "", len(text)
    depth = 0
    for i in range(start, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[start + 1:i], i
    return text[start + 1:], len(text)


def split_top_level(value):
    """Split on commas that are not inside quotes or parentheses."""
    parts, current, depth, quoted = [], "", 0, False
    for ch in value:
        if ch == '"':
            quoted = not quoted
        elif not quoted and ch == "(":
            depth += 1
        elif not quoted and ch == ")":
            depth -= 1
        if ch == "," and depth == 0 and not quoted:
            parts.append(current)
            current = ""
        else:
            current += ch
    parts.append(current)
    return parts


def subshader_blocks(text):
    return [block_after(text, m.end())[0] for m in re.finditer(r"\bSubShader\b", text)]


def pass_blocks(subshader):
    marks = [(m.start(), "grab" if m.group(1) == "GrabPass" else "pass")
             for m in PASS_RE.finditer(subshader)]
    marks += [(m.start(), "usepass") for m in USEPASS_RE.finditer(subshader)]
    return [(kind, block_after(subshader, pos)[0]) for pos, kind in sorted(marks)]


def subshader_head(subshader):
    """The part of a SubShader before its first pass or UsePass."""
    first_pass = len(subshader)
    for m in list(PASS_RE.finditer(subshader)) + list(USEPASS_RE.finditer(subshader)):
        first_pass = min(first_pass, m.start())
    return subshader[:first_pass]


def top_level_tags(subshader):
    """Tags that belong to the SubShader, i.e. before its first pass."""
    head = subshader_head(subshader)
    match = re.search(r"Tags\s*\{([^}]*)\}", head)
    if not match:
        return {}
    pairs = re.findall(r'"([^"]+)"\s*=\s*"([^"]*)"', match.group(1))
    return {key.upper(): value.lower() for key, value in pairs}


def parse_properties(text):
    match = re.search(r"\bProperties\b[ \t]*\{", text)
    if not match:
        return {}
    body, _ = block_after(text, match.end() - 1)
    props = {}
    for line in body.splitlines():
        prop = PROP_RE.match(line)
        if not prop:
            continue
        name, declaration, default = prop.group(1), prop.group(2), prop.group(3)
        fields = [f.strip() for f in split_top_level(declaration)]
        props[name] = {
            "description": fields[0].strip('"'),
            "type": fields[-1],
            "default": default,
        }
    return props


def type_key(type_name):
    return re.sub(r"\s*\(.*$", "", type_name).strip().lower()


def numeric_default(value):
    text = value.strip().strip("(){}").strip()
    if text.startswith('"'):
        return None
    try:
        return tuple(float(part) for part in text.split(","))
    except ValueError:
        return None


def mask_key(value):
    value = value.strip().lower()
    return frozenset() if value == "0" else frozenset(value)


def blend_key(value):
    if any(token.startswith("[") for token in value.replace(",", " ").split()):
        return UNKNOWN  # material property reference: unresolved in the build
    pairs = []
    for part in split_top_level(value):
        tokens = part.split()
        if len(tokens) == 2:
            pairs.append(tuple(token.lower() for token in tokens))
    if not pairs:
        return None
    src, dst = pairs[0]
    src_alpha, dst_alpha = pairs[1] if len(pairs) > 1 else (src, dst)
    return (src, dst, src_alpha, dst_alpha)


def parse_stencil(text):
    match = re.search(r"(?mi)^[ \t]*Stencil\b", text)
    body, _ = block_after(text, match.end())
    face = {}
    for key, label in (("ref", "Ref"), ("readmask", "ReadMask"), ("writemask", "WriteMask"),
                       ("comp", "Comp"), ("pass", "Pass"), ("fail", "Fail"), ("zfail", "ZFail")):
        field = re.search(rf"(?mi)^[ \t]*{label}[ \t]+(\S+)", body)
        if not field:
            continue
        raw = field.group(1)
        if raw.startswith("["):
            continue  # material property reference: unresolved in the build
        face[key] = int(raw) if key in ("ref", "readmask", "writemask") else raw.lower()
    return face


def parse_state(text):
    state = {}

    def token(pattern):
        match = re.search(pattern, text, re.M | re.I)
        if not match:
            return None
        raw = match.group(1)
        # A [Property] reference is resolved at draw time; the build only
        # stores a placeholder, so these fields are not comparable.
        return UNKNOWN if raw.startswith("[") else raw.lower()

    def flag(pattern):
        value = token(pattern)
        if value is None or value is UNKNOWN:
            return value
        return value == "on"

    for key, pattern in (("cull", r"^[ \t]*Cull[ \t]+(\S+)"),
                         ("ztest", r"^[ \t]*ZTest[ \t]+(\S+)"),
                         ("zclip", r"^[ \t]*ZClip[ \t]+(\S+)")):
        value = token(pattern)
        if value is not None:
            state[key] = value
    match = re.search(r"(?mi)^[ \t]*BlendOp[ \t]+(.+)$", text)
    if match:
        ops = [part.strip().lower() for part in split_top_level(match.group(1))]
        state["blendop"] = (UNKNOWN if any(op.startswith("[") for op in ops)
                            else (ops[0], ops[1] if len(ops) > 1 else ops[0]))
    for key, pattern in (("zwrite", r"^[ \t]*ZWrite[ \t]+(\S+)"),
                         ("alphatomask", r"^[ \t]*AlphaToMask[ \t]+(\S+)"),
                         ("lighting", r"^[ \t]*Lighting[ \t]+(\S+)")):
        value = flag(pattern)
        if value is not None:
            state[key] = value
    value = token(r"^[ \t]*ColorMask[ \t]+(\S+)")
    if value is not None:
        state["colormask"] = value if value is UNKNOWN else mask_key(value)
    match = re.search(r"(?mi)^[ \t]*Blend[ \t]+(.+)$", text)
    if match and (blend := blend_key(match.group(1))):
        state["blend"] = blend
    match = re.search(r"(?mi)^[ \t]*Offset[ \t]+([^,\s]+)[ \t]*,[ \t]*([^,\s]+)", text)
    if match:
        first, second = match.group(1), match.group(2)
        state["offset"] = (UNKNOWN if first.startswith("[") or second.startswith("[")
                           else (float(first), float(second)))
    if re.search(r"(?mi)^[ \t]*Stencil\b", text):
        state["stencil"] = parse_stencil(text)
    return state


def expected_state(source_block, subshader_block=""):
    # ShaderLab inherits SubShader-level state into every pass.
    state = dict(DEFAULT_STATE)
    state.update(parse_state(subshader_block))
    state.update(parse_state(source_block))
    state.setdefault("stencil", None)
    return state


def actual_state(output_block):
    state = dict(DEFAULT_STATE)
    state.update(parse_state(output_block))
    state["stencil"] = state.get("stencil")
    return state


def compare_properties(source, output, errors):
    src_props = parse_properties(source)
    out_props = parse_properties(output)

    missing = sorted(set(src_props) - set(out_props))
    extra = sorted(set(out_props) - set(src_props))
    if missing:
        errors.append(f"properties missing from output: {', '.join(missing)}")
    if extra:
        errors.append(f"properties not in source: {', '.join(extra)}")

    for name in sorted(set(src_props) & set(out_props)):
        src, out = src_props[name], out_props[name]
        if src["description"] != out["description"]:
            errors.append(f"property {name}: description {out['description']!r} != {src['description']!r}")
        if type_key(src["type"]) != type_key(out["type"]):
            errors.append(f"property {name}: type {out['type']} != {src['type']}")
        if type_key(src["type"]) in TEXTURE_TYPES:
            continue  # texture defaults are stripped from the build
        src_default = numeric_default(src["default"])
        out_default = numeric_default(out["default"])
        if src_default is not None and out_default is not None:
            if len(src_default) != len(out_default) or any(
                    abs(a - b) > 1e-4 for a, b in zip(src_default, out_default)):
                errors.append(f"property {name}: default {out['default']} != {src['default']}")


def compare_state(source_block, output_block, errors, label, subshader_block=""):
    src = expected_state(source_block, subshader_block)
    out = actual_state(output_block)
    for key in DEFAULT_STATE:
        if src[key] is UNKNOWN:
            continue
        if src[key] != out[key]:
            errors.append(f"{label}: {key} {out[key]!r} != {src[key]!r}")
    src_stencil, out_stencil = src["stencil"], out["stencil"]
    if src_stencil is None and out_stencil is not None:
        errors.append(f"{label}: unexpected Stencil block")
    elif src_stencil is not None and out_stencil is None:
        errors.append(f"{label}: Stencil block missing")
    elif src_stencil is not None:
        for key, value in src_stencil.items():
            if out_stencil.get(key) != value:
                errors.append(f"{label}: stencil {key} {out_stencil.get(key)!r} != {value!r}")


def first_value(text, pattern, default=""):
    match = re.search(pattern, text, re.M | re.I)
    return match.group(1) if match else default


def compare_shader(source, output, errors):
    src_name = first_value(source, r'^\s*Shader\s+"([^"]+)"')
    out_name = first_value(output, r'^\s*Shader\s+"([^"]+)"')
    if src_name != out_name:
        errors.append(f"name {out_name!r} != {src_name!r}")

    compare_properties(source, output, errors)

    src_fallback = first_value(source, r'^\s*Fall\s*Back\s+"([^"]*)"')
    out_fallback = first_value(output, r'^\s*Fallback\s+"([^"]*)"')
    if src_fallback != out_fallback:
        errors.append(f"fallback {out_fallback!r} != {src_fallback!r}")

    src_subshaders = subshader_blocks(source)
    out_subshaders = subshader_blocks(output)
    if len(src_subshaders) != len(out_subshaders):
        errors.append(f"SubShader count {len(out_subshaders)} != {len(src_subshaders)}")
        return

    surface = "#pragma surface" in source
    skip_structure = surface or (src_name in STRUCTURE_EXCEPTIONS)
    for index, (src_sub, out_sub) in enumerate(zip(src_subshaders, out_subshaders)):
        label = f"SubShader {index}"
        src_tags = top_level_tags(src_sub)
        out_tags = top_level_tags(out_sub)
        for key, value in src_tags.items():
            if out_tags.get(key) != value:
                errors.append(f"{label}: tag {key}={out_tags.get(key)!r} != {value!r}")
        if skip_structure:
            continue

        src_passes = pass_blocks(src_sub)
        out_passes = pass_blocks(out_sub)
        if len(src_passes) != len(out_passes):
            errors.append(f"{label}: pass count {len(out_passes)} != {len(src_passes)}")
            continue
        head = subshader_head(src_sub)
        for number, ((kind, src_block), (_, out_block)) in enumerate(zip(src_passes, out_passes)):
            if kind != "pass":
                continue  # GrabPass/UsePass carry no source state
            compare_state(src_block, out_block, errors, f"{label} pass {number + 1}", head)


def load_sources():
    sources = {}
    for path in sorted(SOURCES_DIR.glob("*.shader")):
        text = path.read_text(encoding="utf-8", errors="replace")
        name = first_value(text, r'^\s*Shader\s+"([^"]+)"')
        if name:
            sources[name] = text
    return sources


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--keep", action="store_true",
                        help="do not delete the extracted Output/<name> folders at the end")
    parser.add_argument("--parser",
                        default=str(REPO_ROOT / "src" / "UnityShaderDecompiler.Cli" / "bin" / "Debug"
                                    / "net10.0" / "Shader Decompiler.exe"),
                        help="path to the built Shader Decompiler.exe")
    parser.add_argument("--out-root", default=str(OUT_DIR),
                        help="root folder that Extract.py writes into")
    parser.add_argument("--filter", default=None,
                        help="only run shaders whose name contains this substring")
    args = parser.parse_args()

    parser_exe = Path(args.parser)
    if not parser_exe.exists():
        print(f"Parser.exe not found at {parser_exe}; run 'dotnet build' first.")
        return 2

    sources = load_sources()
    if not sources:
        print(f"No source .shader files found in {SOURCES_DIR}")
        return 2

    json_paths = sorted(JSONS_DIR.glob("*.json"))
    if args.filter:
        json_paths = [p for p in json_paths if args.filter in p.stem]
    if not json_paths:
        print(f"No shader JSONs found in {JSONS_DIR}")
        return 2

    PARSER_OUT.mkdir(parents=True, exist_ok=True)
    failures = 0

    for json_path in json_paths:
        label = json_path.stem
        blob_folder = Path(args.out_root) / safe_folder_name(label)

        result = run([sys.executable, str(EXTRACT), str(json_path), "--out-dir", str(args.out_root)], REPO_ROOT)
        if result.returncode != 0:
            print(f"[{label}] FAIL: Extract.py errored:\n{result.stderr}")
            failures += 1
            continue

        meta = load_metadata(blob_folder)
        source = sources.get(meta["name"])
        if source is None:
            print(f"[{label}] FAIL: no source for shader {meta['name']!r} in {SOURCES_DIR}")
            failures += 1
            continue

        result = run([str(parser_exe), str(blob_folder)], REPO_ROOT / "src" / "UnityShaderDecompiler.Cli")
        log = result.stdout + result.stderr
        if result.returncode != 0 or "Unhandled exception" in log:
            print(f"[{label}] FAIL: decompiler crashed (exit {result.returncode})")
            failures += 1
            continue

        shader_path = output_shader_path(meta, PARSER_OUT)
        if not shader_path.exists():
            print(f"[{label}] FAIL: no .shader written ({shader_path})")
            failures += 1
            continue

        output = shader_path.read_text(encoding="utf-8", errors="replace")
        errors = []
        compare_shader(source, output, errors)

        if errors:
            print(f"[{label}] FAIL")
            for error in errors[:12]:
                print("   -", error)
            if len(errors) > 12:
                print(f"   - ... and {len(errors) - 12} more")
            failures += 1
        else:
            print(f"[{label}] PASS")

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
