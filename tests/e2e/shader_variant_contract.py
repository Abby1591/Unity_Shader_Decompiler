# Checks restored variants against the unmodified serialized shader references.
import hashlib
import json
import re


# Reads only explicitly serialized D3D11 programs and their keyword states.
def stage_programs(program, types, names):
    mask = frozenset(names[index] for index in program["m_SerializedKeywordStateMask"])
    groups = [program["m_SubPrograms"], *program["m_PlayerSubPrograms"]]
    result = set()
    for group in groups:
        for entry in group:
            if entry["m_GpuProgramType"] in types:
                enabled = frozenset(names[index] for index in entry["m_KeywordIndices"])
                if not enabled <= mask:
                    raise AssertionError("Enabled keyword is absent from the serialized stage mask")
                result.add((entry["m_BlobIndex"], enabled, mask))
    if not result:
        raise AssertionError("Missing serialized D3D11 stage")
    return result


# Enumerates compatible pairs and rejects ambiguous serialized keyword states.
def expected_states(shader_pass, names):
    vertices = stage_programs(shader_pass["progVertex"], {15, 16}, names)
    fragments = stage_programs(shader_pass["progFragment"], {17, 18}, names)
    states = {}
    used_vertices, used_fragments = set(), set()
    for vertex, vertex_keys, vertex_mask in vertices:
        for fragment, fragment_keys, fragment_mask in fragments:
            shared = vertex_mask & fragment_mask
            if vertex_keys & shared != fragment_keys & shared:
                continue
            keys = tuple(sorted(vertex_keys | fragment_keys))
            pair = (vertex, fragment)
            if keys in states and states[keys] != pair:
                raise AssertionError("Ambiguous serialized keyword state")
            states[keys] = pair
            used_vertices.add(vertex)
            used_fragments.add(fragment)
    if used_vertices != {entry[0] for entry in vertices} or used_fragments != {entry[0] for entry in fragments}:
        raise AssertionError("Unpaired serialized stage")
    return states


# Requires the same pass order and complete keyword-to-program mapping.
def verify_manifest(data, shader_path):
    text = shader_path.read_text(encoding="utf-8-sig")
    manifest = json.loads(shader_path.with_suffix(".variants.json").read_text())
    digest = hashlib.sha256(text.encode("utf-8")).hexdigest()
    if manifest["schemaVersion"] != 1 or manifest["shaderSha256"].lower() != digest:
        raise AssertionError("Variant manifest does not match shader")
    parsed = data["m_ParsedForm"]
    passes = [entry for sub in parsed["m_SubShaders"] for entry in sub["m_Passes"]]
    if len(manifest["passes"]) != len(passes) or len(re.findall(r"\bHLSLPROGRAM\b", text)) != len(passes):
        raise AssertionError("Original pass count was not preserved")
    for index, (original, emitted) in enumerate(zip(passes, manifest["passes"])):
        if emitted["passIndex"] != index:
            raise AssertionError("Original pass order was not preserved")
        actual = {}
        for variant in emitted["variants"]:
            keys = tuple(sorted(variant["keywords"]))
            if keys in actual or len(set(keys)) != len(keys):
                raise AssertionError("Duplicate emitted keyword state")
            actual[keys] = (variant["vertex"], variant["fragment"])
        if actual != expected_states(original, parsed["m_KeywordNames"]):
            raise AssertionError(f"Pass {index}: emitted keyword/program mapping differs from serialized data")
