import json
import tempfile
import unittest
from pathlib import Path

from libs.metadata import ShaderMetadata


class ShaderMetadataTests(unittest.TestCase):
    def test_constant_buffer_sizes_survive_serialization(self):
        shader_pass = {
            "m_NameIndices": {"Parameters": 0},
            "m_ProgVertex": {"m_CommonParameters": {
                "m_ConstantBuffers": [{"m_NameIndex": 0, "m_Size": 64}],
                "m_ConstantBufferBindings": [{"m_NameIndex": 0, "m_Index": 2}],
            }},
            "m_ProgFragment": {"m_CommonParameters": {
                "m_ConstantBufferBindings": [{"m_NameIndex": 0, "m_Index": 3}],
            }},
        }
        source = {"m_Name": "Test/BufferLayout", "m_ParsedForm": {
            "m_SubShaders": [{"m_Passes": [shader_pass]}],
        }}
        with tempfile.TemporaryDirectory() as directory:
            source_path = Path(directory) / "shader.json"
            output_path = Path(directory) / "metadata.json"
            source_path.write_text(json.dumps(source), encoding="utf-8")
            ShaderMetadata(source_path).save(output_path)
            metadata = json.loads(output_path.read_text(encoding="utf-8"))
        buffers = metadata["subShaders"][0]["passes"][0]["constantBuffers"]
        by_stage = {buffer["stage"]: buffer for buffer in buffers}
        self.assertEqual(by_stage["Vertex"], {
            "name": "Parameters", "stage": "Vertex", "slot": 2,
            "size": 64, "variables": [],
        })
        # A binding without a serialized extent retains the existing zero sentinel.
        self.assertEqual(by_stage["Fragment"], {
            "name": "Parameters", "stage": "Fragment", "slot": 3,
            "size": 0, "variables": [],
        })

    def test_variant_references_keep_stage_keyword_masks(self):
        shader_pass = {"m_ProgFragment": {
            "m_SerializedKeywordStateMask": [0, 1],
            "m_PlayerSubPrograms": [[
                {"m_GpuProgramType": 17, "m_BlobIndex": 7, "m_KeywordIndices": [1]},
                {"m_GpuProgramType": 23, "m_BlobIndex": 8, "m_KeywordIndices": []},
            ]],
        }}
        self.assertEqual(ShaderMetadata._directx_programs(shader_pass, ["MODE", "DETAIL"]), [
            {"stage": "Fragment", "blobIndex": 7, "keywords": ["DETAIL"],
             "keywordMask": ["DETAIL", "MODE"]},
        ])
        with self.assertRaises(ValueError):
            ShaderMetadata._directx_programs(shader_pass, ["MODE"])


if __name__ == "__main__":
    unittest.main()
