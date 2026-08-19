"""
Stage 0.2 — Metadata Extraction

Pulls everything the backend (C#) needs out of the raw Unity shader JSON
(the AssetStudio export) into a single metadata.json, keyed by shader name.

This does NOT touch m_CompressedBlob — that stays in blob.py/ShaderBlob.
"""

import json


class ShaderMetadata:
    def __init__(self, json_path):
        self.json_path = json_path
        with open(json_path, "r", encoding="utf8") as f:
            self.data = json.load(f)

    def build(self):
        d = self.data
        parsed = d.get("m_ParsedForm", d)  # some exports nest under m_ParsedForm

        return {
            "name": d.get("m_Name") or parsed.get("m_Name"),
            "properties": self._properties(parsed),
            "subShaders": self._sub_shaders(parsed),
            "fallback": self._get(parsed, "m_FallbackName", ""),
            "customEditor": self._get(parsed, "m_CustomEditorName", ""),
            "keywords": self._get(parsed, "m_KeywordNames", []),
            "dependencies": self._get(parsed, "m_Dependencies", []),
            "disableNoSubshadersMessage": self._get(
                parsed, "m_DisableNoSubshadersMessage", False
            ),
        }

    def save(self, out_path):
        with open(out_path, "w", encoding="utf8") as f:
            json.dump(self.build(), f, indent=2)

    # -- helpers --

    @staticmethod
    def _get(d, key, default=None):
        return d.get(key, default) if isinstance(d, dict) else default

    def _properties(self, parsed):
        props = self._get(parsed, "m_PropInfo", {})
        out = []
        for p in self._get(props, "m_Props", []):
            out.append({
                "name": p.get("m_Name"),
                "description": p.get("m_Description"),
                "type": p.get("m_Type"),
                "flags": p.get("m_Flags"),
                # Unity stores the default as four independent scalar slots
                # (m_DefValue_0_ .. m_DefValue_3_); shape them into a single
                # {x,y,z,w} vector the C# side can read at once.
                "defaultValue": {
                    "x": p.get("m_DefValue_0_", 0),
                    "y": p.get("m_DefValue_1_", 0),
                    "z": p.get("m_DefValue_2_", 0),
                    "w": p.get("m_DefValue_3_", 0),
                },
                "defTexture": p.get("m_DefTexture"),
                "attributes": p.get("m_Attributes", []),
            })
        return out

    def _sub_shaders(self, parsed):
        subshaders = []
        for ss in self._get(parsed, "m_SubShaders", []):
            raw_passes = ss.get("m_Passes", [])
            # Union cbuffer layouts by buffer name across every pass of
            # the subshader. A serialized program only lists the buffers
            # its stage actually touches (the ForwardAdd fragment can omit
            # $Globals/UnityReflectionProbes entirely while still reading
            # them), but the layout of a same-named buffer is identical
            # wherever it appears, so a pass that omits one can still name
            # its reads from another pass's copy.
            name_layouts = self._name_layouts(raw_passes)
            subshaders.append({
                "tags": self._tags(ss.get("m_Tags", {})),
                "lod": ss.get("m_LOD"),
                "passes": [self._pass(p, name_layouts) for p in raw_passes],
            })
        return subshaders

    @staticmethod
    def _name_layouts(raw_passes):
        layouts = {}
        for p in raw_passes:
            name_to_index = p.get("m_NameIndices", {}) or {}
            index_to_name = {}
            for name, idx in name_to_index.items():
                if isinstance(idx, int):
                    index_to_name[int(idx)] = name
            for key in ["m_ProgVertex", "m_ProgFragment", "m_ProgGeometry",
                        "m_ProgHull", "m_ProgDomain", "m_ProgRayTracing"]:
                prog = p.get(key)
                cp = (prog or {}).get("m_CommonParameters", {}) or {}
                for b in cp.get("m_ConstantBuffers", []) or []:
                    cb_name = index_to_name.get(b.get("m_NameIndex"), "")
                    if not cb_name:
                        continue
                    variables = layouts.setdefault(cb_name, [])
                    seen = {(v["name"], v["offset"]) for v in variables}
                    for v in b.get("m_VectorParams", []) or []:
                        entry = {
                            "name": index_to_name.get(v.get("m_NameIndex"), ""),
                            "offset": v.get("m_Index", 0),
                            "dim": v.get("m_Dim", 0),
                            "arraySize": v.get("m_ArraySize", 0),
                        }
                        if (entry["name"], entry["offset"]) not in seen:
                            seen.add((entry["name"], entry["offset"]))
                            variables.append(entry)
                    for m in b.get("m_MatrixParams", []) or []:
                        entry = {
                            "name": index_to_name.get(m.get("m_NameIndex"), ""),
                            "offset": m.get("m_Index", 0),
                            "rowCount": m.get("m_RowCount", 0),
                            "arraySize": m.get("m_ArraySize", 0),
                            "isMatrix": True,
                        }
                        if (entry["name"], entry["offset"]) not in seen:
                            seen.add((entry["name"], entry["offset"]))
                            variables.append(entry)
        return layouts

    def _pass(self, p, name_layouts=None):
        state = p.get("m_State", {})
        prog_keys = ["m_ProgVertex", "m_ProgFragment", "m_ProgGeometry",
                     "m_ProgHull", "m_ProgDomain", "m_ProgRayTracing"]
        programs = {}

        name_to_index = p.get("m_NameIndices", {}) or {}
        index_to_name = {}
        for name, idx in name_to_index.items():
            if isinstance(idx, int):
                index_to_name[int(idx)] = name

        for key in prog_keys:
            prog = p.get(key)
            if not prog:
                continue
            subprograms = (prog.get("m_PlayerSubPrograms")
                           or prog.get("m_SubPrograms") or [])
            if subprograms:
                programs[key[2:]] = {"subProgramCount": len(subprograms)}

        return {
            "name": p.get("m_Name"),
            "nameIndices": name_to_index,
            "tags": self._tags(state.get("m_Tags", {})),
            "renderState": self._render_state(state),
            "programs": programs,
            "constantBuffers": self._constant_buffers(p, prog_keys, index_to_name, name_layouts),
            "textures": p.get("m_SerializedProgram", {}).get("m_TextureParameters", []),
            "samplers": p.get("m_SerializedProgram", {}).get("m_SamplerParameters", []),
            "keywords": p.get("m_NameIndices", []),
        }

    def _constant_buffers(self, p, prog_keys, index_to_name, name_layouts=None):
        # Unity serializes the constant-buffer layout (name + per-variable
        # byte offset) in each stage's m_CommonParameters — this is the
        # per-pass replacement for the RDEF chunk Unity strips from shipped
        # bytecode. Each stage binds its OWN table (cb0 in the vertex
        # program can be a different buffer than cb0 in the fragment
        # program), so cbuffers are keyed by (stage, slot) — never merged
        # across stages, or different buffers that share a slot number
        # would collide at the same byte offsets.
        by_key = {}
        for key in prog_keys:
            stage = key[len("m_Prog"):] if key.startswith("m_Prog") else key
            prog = p.get(key)
            cp = (prog or {}).get("m_CommonParameters", {}) or {}
            slot_of_name = {}
            used_slots = set()
            for b in cp.get("m_ConstantBufferBindings", []) or []:
                if b.get("m_Index") is not None:
                    slot_of_name[b.get("m_NameIndex")] = b.get("m_Index")
                    used_slots.add(b.get("m_Index"))

            # Some builds (notably the vertex program of built-in
            # lighting passes) ship m_ConstantBufferBindings empty:
            # Unity then declares the cbuffers in slot order, so fall
            # back to assigning the lowest unclaimed slot per buffer.
            next_free = 0

            def _next_slot():
                nonlocal next_free
                while next_free in used_slots:
                    next_free += 1
                slot = next_free
                used_slots.add(slot)
                next_free += 1
                return slot

            for b in cp.get("m_ConstantBuffers", []) or []:
                slot = slot_of_name.get(b.get("m_NameIndex"))
                if slot is None:
                    slot = _next_slot()
                cb_key = (stage, slot)
                cb = by_key.setdefault(cb_key, {
                    "slot": slot,
                    "stage": stage,
                    "name": index_to_name.get(b.get("m_NameIndex"), ""),
                    "size": b.get("m_Size", 0),
                    "variables": [],
                })
                for v in b.get("m_VectorParams", []) or []:
                    cb["variables"].append({
                        "name": index_to_name.get(v.get("m_NameIndex"), ""),
                        "offset": v.get("m_Index", 0),
                        "dim": v.get("m_Dim", 0),
                        "arraySize": v.get("m_ArraySize", 0),
                    })
                for m in b.get("m_MatrixParams", []) or []:
                    cb["variables"].append({
                        "name": index_to_name.get(m.get("m_NameIndex"), ""),
                        "offset": m.get("m_Index", 0),
                        "rowCount": m.get("m_RowCount", 0),
                        "arraySize": m.get("m_ArraySize", 0),
                        "isMatrix": True,
                    })

            # A program can bind a buffer (its name index appears in
            # m_ConstantBufferBindings) without listing it in
            # m_ConstantBuffers — Unity only serializes the buffers the
            # stage touches. When the bound name's layout is known from
            # another pass/stage of the same shader, reuse it so reads of
            # that (stage, slot) still resolve to real names.
            if name_layouts:
                for b in cp.get("m_ConstantBufferBindings", []) or []:
                    ni = b.get("m_NameIndex")
                    slot = b.get("m_Index")
                    if ni is None or slot is None:
                        continue
                    cb_name = index_to_name.get(ni, "")
                    if not cb_name:
                        continue
                    if cb_name in name_layouts and (stage, slot) not in by_key:
                        by_key[(stage, slot)] = {
                            "slot": slot,
                            "stage": stage,
                            "name": cb_name,
                            "size": 0,
                            "variables": [dict(v) for v in name_layouts[cb_name]],
                        }

        out = []
        for cb_key in sorted(by_key):
            cb = by_key[cb_key]
            seen = set()
            variables = []
            for v in cb["variables"]:
                key = (v["name"], v["offset"])
                if key not in seen:
                    seen.add(key)
                    variables.append(v)
            out.append({
                "slot": cb["slot"],
                "stage": cb["stage"],
                "name": cb["name"],
                "size": cb["size"],
                "variables": variables,
            })
        return out

    @staticmethod
    def _unwrap(v, default=None):
        # Unity wraps most scalar render state in
        # {"m_Name": "...", "m_Value": N} — flatten to just N.
        if isinstance(v, dict) and "m_Value" in v:
            return v["m_Value"]
        return v if v is not None else default

    def _render_state(self, state):
        # Shipped Unity 2022.3.x exports carry a flat m_State with keys
        # like m_Culling/m_ZTest/m_ZWrite/m_RtBlend0 (values wrapped as
        # {"m_Value": N}). That's the schema the C# side (HlslRenderstateBuilder)
        # consumes. A few exports use a nested rasterState/depthState shape
        # instead — fall back to that when the flat keys are absent.
        if not isinstance(state, dict):
            return {}

        blend0 = state.get("m_RtBlend0") or {}
        blend = {
            "srcBlend": self._unwrap(blend0.get("m_SourceBlend"), 1),
            "dstBlend": self._unwrap(blend0.get("m_DestinationBlend"), 0),
            "srcBlendAlpha": self._unwrap(blend0.get("m_SourceBlendAlpha"), 1),
            "dstBlendAlpha": self._unwrap(blend0.get("m_DestinationBlendAlpha"), 0),
            "blendOp": self._unwrap(blend0.get("m_BlendOp"), 0),
            "blendOpAlpha": self._unwrap(blend0.get("m_BlendOpAlpha"), 0),
            "colorMask": self._unwrap(blend0.get("m_ColMask"), 15),
        }

        rs = {
            "cull": self._unwrap(state.get("m_Culling")),
            "zTest": self._unwrap(state.get("m_ZTest")),
            "zWrite": self._unwrap(state.get("m_ZWrite")),
            "zClip": self._unwrap(state.get("m_ZClip"), 1),
            "lighting": state.get("m_Lighting"),
            "fogMode": state.get("m_FogMode"),
            "alphaToMask": self._unwrap(state.get("m_AlphaToMask"), 0),
            "conservative": self._unwrap(state.get("m_Conservative"), 0),
            "offsetFactor": self._unwrap(state.get("m_OffsetFactor"), 0),
            "offsetUnits": self._unwrap(state.get("m_OffsetUnits"), 0),
            "stencilRef": self._unwrap(state.get("m_StencilRef"), 0),
            "stencilReadMask": self._unwrap(state.get("m_StencilReadMask"), 255),
            "stencilWriteMask": self._unwrap(state.get("m_StencilWriteMask"), 255),
            "stencilOpFront": state.get("m_StencilOpFront"),
            "stencilOpBack": state.get("m_StencilOpBack"),
            "separateBlend": state.get("m_RtSeparateBlend", False),
            "blend": blend,
        }

        # Legacy nested schema (rasterState/depthState/...): if none of the
        # flat keys resolved, try it before giving up.
        if all(v is None for v in (rs["cull"], rs["zTest"], rs["zWrite"])):
            raster = state.get("rasterState", {})
            depth = state.get("depthState", {})
            old_blend = state.get("rtBlend")
            rs.update({
                "cull": self._named(raster.get("cullMode")),
                "zTest": self._named(depth.get("depthFunc")),
                "zWrite": depth.get("depthWrite"),
                "fog": state.get("fogMode"),
                "blend": old_blend if isinstance(old_blend, dict) else blend,
            })
        return rs

    @staticmethod
    def _named(x):
        # Unity often stores enum-like state as {"val": N}
        if isinstance(x, dict):
            return x.get("val", x)
        return x

    @staticmethod
    def _tags(tags):
        # m_Tags is usually {"m_Tags": {"key": "value"}} (a plain dict) or
        # {"tags": {"key": {"first": "...", "second": "..."}}}. Normalize
        # both to {"key": "value"}.
        out = {}
        if not isinstance(tags, dict):
            return out
        entries = tags.get("m_Tags")
        if not isinstance(entries, dict):
            entries = tags.get("tags")
        if isinstance(entries, dict):
            for k, v in entries.items():
                out[k] = v.get("second", v) if isinstance(v, dict) else v
        return out