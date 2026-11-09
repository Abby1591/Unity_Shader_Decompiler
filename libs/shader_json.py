# Normalizes supported shader JSON export schemas.
"""Normalize the serialized field names used by AssetStudio and AssetRipper."""

import json


# Reads a byte offset from either supported parameter schema.
def parameter_offset(parameter):
    # Unity renamed this field; AssetRipper also normalizes older exports.
    field = "m_OffsetInConstantBuffer" if "m_OffsetInConstantBuffer" in parameter else "m_Index"
    offset = parameter.get(field)
    if type(offset) is not int or offset < 0 or offset % 4:
        raise ValueError(
            f"Invalid or missing constant-buffer byte offset for parameter {parameter.get('m_NameIndex')}: {offset!r}")
    return offset


# Resolves equivalent field names and rejects conflicting values.
def _alias(data, canonical, legacy):
    if legacy not in data:
        return
    value = data.pop(legacy)
    if canonical in data and data[canonical] != value:
        raise ValueError(f"Conflicting shader fields: {canonical} and {legacy}")
    data[canonical] = value


# Normalizes dictionary and serialized key/value map encodings.
def _mapping(value, label):
    if isinstance(value, dict):
        return value
    if not isinstance(value, list):
        raise ValueError(f"Invalid serialized {label} mapping")
    result = {}
    for entry in value:
        if not isinstance(entry, dict) or set(entry) != {"Key", "Value"}:
            raise ValueError(f"Invalid serialized {label} entry")
        key = entry["Key"]
        if not isinstance(key, str) or key in result:
            raise ValueError(f"Invalid or duplicate {label} key: {key!r}")
        result[key] = entry["Value"]
    return result


# Normalizes serialized shader tags.
def _tags(owner):
    tags = owner.get("m_Tags")
    if isinstance(tags, dict):
        _alias(tags, "m_Tags", "tags")
        if "m_Tags" in tags:
            tags["m_Tags"] = _mapping(tags["m_Tags"], "tag")


# Unwraps serialized state values without inventing defaults.
def _wrapped(value, integer=False):
    if not isinstance(value, dict):
        return value
    _alias(value, "m_Name", "name")
    _alias(value, "m_Value", "val")
    if integer and "m_Value" in value:
        number = value["m_Value"]
        # AssetStudio serializes these enum/mask values as floating-point JSON.
        if type(number) not in (int, float) or int(number) != number:
            raise ValueError(f"Invalid integer render-state value: {number!r}")
        value["m_Value"] = int(number)
    return value


# Normalizes render-state fields from both exporter schemas.
def _render_state(state):
    for name in ("zClip", "zTest", "zWrite", "culling", "conservative", "alphaToMask",
                 "stencilReadMask", "stencilWriteMask", "stencilRef", "offsetFactor",
                 "offsetUnits", "rtSeparateBlend", "lighting", "fogMode"):
        canonical = "m_" + name[0].upper() + name[1:]
        _alias(state, canonical, name)
        if canonical in state:
            state[canonical] = _wrapped(state[canonical], name not in ("offsetFactor", "offsetUnits"))
    for index in range(8):
        field = f"m_RtBlend{index}"
        _alias(state, field, f"rtBlend{index}")
        blend = state.get(field)
        if isinstance(blend, dict):
            for old, new in (("srcBlend", "SourceBlend"), ("destBlend", "DestinationBlend"),
                             ("srcBlendAlpha", "SourceBlendAlpha"), ("destBlendAlpha", "DestinationBlendAlpha"),
                             ("blendOp", "BlendOp"), ("blendOpAlpha", "BlendOpAlpha"), ("colMask", "ColMask")):
                _alias(blend, "m_" + new, old)
                if "m_" + new in blend:
                    blend["m_" + new] = _wrapped(blend["m_" + new], integer=True)
    for name in ("stencilOp", "stencilOpFront", "stencilOpBack"):
        field = "m_" + name[0].upper() + name[1:]
        _alias(state, field, name)
        stencil = state.get(field)
        if isinstance(stencil, dict):
            for operation in ("pass", "fail", "zFail", "comp"):
                canonical = "m_" + operation[0].upper() + operation[1:]
                _alias(stencil, canonical, operation)
                if canonical in stencil:
                    stencil[canonical] = _wrapped(stencil[canonical], integer=True)
    _tags(state)


# Loads and normalizes an AssetStudio or AssetRipper shader export.
def load_shader_json(path):
    with open(path, encoding="utf-8-sig") as stream:
        data = json.load(stream)
    for name in ("compressedBlob", "compressedLengths", "decompressedLengths", "platforms", "offsets", "stageCounts"):
        _alias(data, "m_" + name[0].upper() + name[1:], name)
    parsed = data.get("m_ParsedForm", data)
    # The serialized object name can be empty; the ShaderLab name is in ParsedForm.
    if not data.get("m_Name"):
        data["m_Name"] = parsed.get("m_Name")
    for prop in parsed.get("m_PropInfo", {}).get("m_Props", []):
        for index in range(4):
            _alias(prop, f"m_DefValue_{index}_", f"m_DefValue[{index}]")
    for subshader in parsed.get("m_SubShaders", []):
        _tags(subshader)
        for shader_pass in subshader.get("m_Passes", []):
            if "m_NameIndices" in shader_pass:
                shader_pass["m_NameIndices"] = _mapping(shader_pass["m_NameIndices"], "name-index")
            for stage in ("Vertex", "Fragment", "Geometry", "Hull", "Domain", "RayTracing"):
                _alias(shader_pass, "m_Prog" + stage, "prog" + stage)
            _tags(shader_pass)
            _render_state(shader_pass.get("m_State", {}))
    return data
