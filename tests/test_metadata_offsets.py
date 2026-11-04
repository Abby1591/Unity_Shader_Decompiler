# Checks shader extraction and decompilation behavior.
import json
import tempfile
import unittest
from pathlib import Path

from libs.metadata import ShaderMetadata


# Covers shader metadata regression cases.
class MetadataOffsetTests(unittest.TestCase):
    # Builds normalized metadata from a temporary JSON fixture.
    def extract(self, vector, matrix):
        shader_pass = {
            "m_NameIndices": {"Globals": 1, "Tint": 2, "Transform": 3},
            "m_ProgVertex": {"m_CommonParameters": {
                "m_ConstantBufferBindings": [{"m_NameIndex": 1, "m_Index": 2}],
                "m_ConstantBuffers": [{
                    "m_NameIndex": 1, "m_Size": 128,
                    "m_VectorParams": [{"m_NameIndex": 2, "m_Dim": 3, **vector}],
                    "m_MatrixParams": [{"m_NameIndex": 3, "m_RowCount": 4, **matrix}],
                }],
            }},
        }
        shader = {"m_Name": "Test/Offsets", "m_ParsedForm": {
            "m_SubShaders": [{"m_Passes": [shader_pass]}],
        }}
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "shader.json"
            path.write_text(json.dumps(shader), encoding="utf-8")
            extractor = ShaderMetadata(path)
            # Exercise both readers: the shared layout and the stage-local layout.
            shared = extractor._name_layouts([shader_pass])["Globals"]
            local = extractor._constant_buffers(
                shader_pass, ["m_ProgVertex"], {1: "Globals", 2: "Tint", 3: "Transform"})
            built = extractor.build()["subShaders"][0]["passes"][0]["constantBuffers"]
        self.assertEqual(local, built)
        self.assertEqual(local[0]["slot"], 2)
        self.assertEqual(shared, local[0]["variables"])
        return [(entry["name"], entry["offset"]) for entry in shared]

    # Checks both serialized names preserve byte offsets.
    def test_both_serialized_names_preserve_byte_offsets(self):
        for field in ("m_Index", "m_OffsetInConstantBuffer"):
            with self.subTest(field=field):
                self.assertEqual(self.extract({field: 20}, {field: 48}),
                                 [("Tint", 20), ("Transform", 48)])

    # Checks explicit offset takes precedence.
    def test_explicit_offset_takes_precedence(self):
        self.assertEqual(self.extract(
            {"m_Index": 0, "m_OffsetInConstantBuffer": 20},
            {"m_Index": 0, "m_OffsetInConstantBuffer": 48}),
            [("Tint", 20), ("Transform", 48)])

    # Checks zero is a valid offset.
    def test_zero_is_a_valid_offset(self):
        self.assertEqual(self.extract({"m_Index": 0}, {"m_OffsetInConstantBuffer": 0}),
                         [("Tint", 0), ("Transform", 0)])

    # Checks missing offsets fail in both readers.
    def test_missing_offsets_fail_in_both_readers(self):
        for vector, matrix in (({}, {"m_Index": 48}), ({"m_Index": 20}, {})):
            with self.subTest(vector=vector, matrix=matrix):
                with self.assertRaisesRegex(ValueError, "byte offset"):
                    self.extract(vector, matrix)

    # Checks invalid offsets are not replaced by legacy values.
    def test_invalid_offsets_are_not_replaced_by_legacy_values(self):
        for value in (None, True, -4, 2, 1.5, "16"):
            for field in ("m_Index", "m_OffsetInConstantBuffer"):
                with self.subTest(value=value, field=field):
                    invalid = {"m_Index": 20, field: value}
                    with self.assertRaisesRegex(ValueError, "byte offset"):
                        self.extract(invalid, {"m_Index": 48})
                    with self.assertRaisesRegex(ValueError, "byte offset"):
                        self.extract({"m_Index": 20}, invalid)


if __name__ == "__main__":
    unittest.main()
