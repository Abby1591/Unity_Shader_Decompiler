import json
import tempfile
import unittest
from pathlib import Path

from libs.metadata import ShaderMetadata


class ShaderMetadataTests(unittest.TestCase):
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
