import base64
import copy
import json
import tempfile
import unittest
from pathlib import Path

import lz4.block

from libs.blob import ShaderBlob
from libs.metadata import ShaderMetadata
from libs.shader_json import load_shader_json


class ExporterSchemaTests(unittest.TestCase):
    def studio(self):
        payload = b"generic serialized shader data"
        compressed = lz4.block.compress(payload, store_size=False)
        shader = {
            "m_Name": "",
            "compressedBlob": base64.b64encode(compressed).decode("ascii"),
            "compressedLengths": [[len(compressed)]], "decompressedLengths": [[len(payload)]],
            "platforms": [4], "offsets": [[0]],
            "m_ParsedForm": {
                "m_Name": "Test/ExporterSchemas", "m_KeywordNames": ["DETAIL"],
                "m_PropInfo": {"m_Props": [{
                    "m_Name": "_Tint", "m_Type": 0,
                    "m_DefValue[0]": 0.25, "m_DefValue[1]": 0.5,
                    "m_DefValue[2]": 0.75, "m_DefValue[3]": 1.0,
                }]},
                "m_SubShaders": [{
                    "m_Tags": {"tags": [{"Key": "RenderType", "Value": "Opaque"}]},
                    "m_Passes": [{
                        "m_NameIndices": [{"Key": "Globals", "Value": 1}, {"Key": "_Tint", "Value": 2}],
                        "progFragment": {
                            "m_PlayerSubPrograms": [[{"m_BlobIndex": 3, "m_GpuProgramType": 17,
                                                      "m_KeywordIndices": [0]}]],
                            "m_SerializedKeywordStateMask": [0],
                            "m_CommonParameters": {
                                "m_ConstantBufferBindings": [{"m_NameIndex": 1, "m_Index": 2}],
                                "m_ConstantBuffers": [{"m_NameIndex": 1, "m_Size": 64,
                                    "m_VectorParams": [{"m_NameIndex": 2, "m_Index": 16, "m_Dim": 4}]}],
                            },
                        },
                        "m_State": {
                            "m_Tags": {"tags": [{"Key": "LIGHTMODE", "Value": "FORWARDBASE"}]},
                            "culling": {"name": "<noninit>", "val": 2.0},
                            "zTest": {"val": 4.0}, "zWrite": {"val": 1.0},
                            "offsetFactor": {"val": 0.125},
                            "rtBlend0": {"srcBlend": {"val": 5.0}, "destBlend": {"val": 10.0},
                                         "colMask": {"val": 14.0}},
                            "stencilOpFront": {"comp": {"val": 8.0}, "pass": {"val": 2.0}},
                        },
                    }],
                }],
            },
        }
        return shader, payload

    def load(self, shader):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "shader.json"
            path.write_text(json.dumps(shader), encoding="utf-8")
            return load_shader_json(path), ShaderMetadata(path).build(), ShaderBlob(path).get_blob()

    def test_assetstudio_fields_keep_values_and_bindings(self):
        shader, payload = self.studio()
        normalized, metadata, blob = self.load(shader)
        self.assertEqual(blob, payload)
        self.assertEqual(normalized["m_Name"], "Test/ExporterSchemas")
        self.assertEqual(metadata["properties"][0]["defaultValue"],
                         {"x": 0.25, "y": 0.5, "z": 0.75, "w": 1.0})
        shader_pass = metadata["subShaders"][0]["passes"][0]
        self.assertEqual(shader_pass["tags"], {"LIGHTMODE": "FORWARDBASE"})
        self.assertEqual(shader_pass["constantBuffers"][0]["slot"], 2)
        self.assertEqual(shader_pass["constantBuffers"][0]["variables"][0]["offset"], 16)
        state = shader_pass["renderState"]
        self.assertEqual((state["cull"], state["zTest"], state["zWrite"]), (2, 4, 1))
        self.assertEqual(state["offsetFactor"], 0.125)
        self.assertEqual((state["blend"]["srcBlend"], state["blend"]["dstBlend"], state["blend"]["colorMask"]), (5, 10, 14))
        self.assertIs(type(state["stencilOpFront"]["m_Comp"]["m_Value"]), int)

    def test_assetripper_fields_produce_identical_inputs(self):
        studio, payload = self.studio()
        # Construct the alternative schema explicitly, independently of the loader.
        ripper = copy.deepcopy(studio)
        for old, new in (("compressedBlob", "m_CompressedBlob"), ("compressedLengths", "m_CompressedLengths"),
                         ("decompressedLengths", "m_DecompressedLengths"), ("platforms", "m_Platforms"), ("offsets", "m_Offsets")):
            ripper[new] = ripper.pop(old)
        ripper["m_Name"] = "Test/ExporterSchemas"
        parsed = ripper["m_ParsedForm"]
        prop = parsed["m_PropInfo"]["m_Props"][0]
        for i in range(4):
            prop[f"m_DefValue_{i}_"] = prop.pop(f"m_DefValue[{i}]")
        subshader = parsed["m_SubShaders"][0]
        subshader["m_Tags"] = {"m_Tags": {"RenderType": "Opaque"}}
        shader_pass = subshader["m_Passes"][0]
        shader_pass["m_NameIndices"] = {"Globals": 1, "_Tint": 2}
        shader_pass["m_ProgFragment"] = shader_pass.pop("progFragment")
        parameter = shader_pass["m_ProgFragment"]["m_CommonParameters"]["m_ConstantBuffers"][0]["m_VectorParams"][0]
        parameter["m_OffsetInConstantBuffer"] = parameter.pop("m_Index")
        shader_pass["m_State"] = {
            "m_Tags": {"m_Tags": {"LIGHTMODE": "FORWARDBASE"}},
            "m_Culling": {"m_Name": "<noninit>", "m_Value": 2},
            "m_ZTest": {"m_Value": 4}, "m_ZWrite": {"m_Value": 1},
            "m_OffsetFactor": {"m_Value": 0.125},
            "m_RtBlend0": {"m_SourceBlend": {"m_Value": 5}, "m_DestinationBlend": {"m_Value": 10}, "m_ColMask": {"m_Value": 14}},
            "m_StencilOpFront": {"m_Comp": {"m_Value": 8}, "m_Pass": {"m_Value": 2}},
        }
        _, expected, _ = self.load(studio)
        _, actual, blob = self.load(ripper)
        self.assertEqual(actual, expected)
        self.assertEqual(blob, payload)

    def test_conflicting_aliases_fail(self):
        shader, _ = self.studio()
        shader["m_CompressedLengths"] = [[1]]
        with self.assertRaisesRegex(ValueError, "Conflicting shader fields"):
            self.load(shader)

    def test_duplicate_serialized_names_fail(self):
        shader, _ = self.studio()
        names = shader["m_ParsedForm"]["m_SubShaders"][0]["m_Passes"][0]["m_NameIndices"]
        names.append({"Key": "Globals", "Value": 3})
        with self.assertRaisesRegex(ValueError, "duplicate"):
            self.load(shader)

    def test_fractional_render_state_enum_fails(self):
        shader, _ = self.studio()
        shader["m_ParsedForm"]["m_SubShaders"][0]["m_Passes"][0]["m_State"]["culling"]["val"] = 1.5
        with self.assertRaisesRegex(ValueError, "integer render-state"):
            self.load(shader)


if __name__ == "__main__":
    unittest.main()
