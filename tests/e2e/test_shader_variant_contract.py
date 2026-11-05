# Exercises the source-to-manifest oracle without running a decompiler.
import hashlib
import json
import tempfile
import unittest
from pathlib import Path
from shader_variant_contract import expected_states, verify_manifest


# Supplies minimal explicit serialized references for contract checks.
class ShaderVariantContractTests(unittest.TestCase):
    # Describes one shared vertex and two fragment keyword states.
    def source(self):
        vertex = {"m_SubPrograms": [{"m_BlobIndex": 1, "m_GpuProgramType": 15, "m_KeywordIndices": []}],
                  "m_PlayerSubPrograms": [], "m_SerializedKeywordStateMask": []}
        fragment = {"m_SubPrograms": [
            {"m_BlobIndex": 2, "m_GpuProgramType": 17, "m_KeywordIndices": []},
            {"m_BlobIndex": 3, "m_GpuProgramType": 17, "m_KeywordIndices": [0]}],
            "m_PlayerSubPrograms": [], "m_SerializedKeywordStateMask": [0]}
        return {"m_ParsedForm": {"m_KeywordNames": ["MODE"], "m_SubShaders": [
            {"m_Passes": [{"progVertex": vertex, "progFragment": fragment}]}]}}

    # Writes a hash-bound manifest and exercises the independent oracle.
    def verify(self, variants, pass_count=1):
        text = "HLSLPROGRAM\nENDHLSL\n" * pass_count
        with tempfile.TemporaryDirectory() as temporary:
            shader = Path(temporary) / "test.shader"
            shader.write_bytes(text.encode("utf-8"))
            shader.with_suffix(".variants.json").write_text(json.dumps({
                "schemaVersion": 1, "shaderSha256": hashlib.sha256(text.encode()).hexdigest(),
                "passes": [{"passIndex": 0, "variants": variants}]}))
            verify_manifest(self.source(), shader)

    # Accepts exactly the serialized keyword/program mapping.
    def test_matching_manifest(self):
        self.verify([{"vertex": 1, "fragment": 2, "keywords": []},
                     {"vertex": 1, "fragment": 3, "keywords": ["MODE"]}])

    # Rejects a shader that silently drops a serialized keyword state.
    def test_missing_variant(self):
        with self.assertRaisesRegex(AssertionError, "mapping differs"):
            self.verify([{"vertex": 1, "fragment": 2, "keywords": []}])

    # Rejects expanded variant passes that would change runtime pass indices.
    def test_expanded_passes(self):
        with self.assertRaisesRegex(AssertionError, "pass count"):
            self.verify([], pass_count=2)

    # Rejects ambiguity instead of choosing an arbitrary program.
    def test_ambiguous_source(self):
        shader_pass = self.source()["m_ParsedForm"]["m_SubShaders"][0]["m_Passes"][0]
        shader_pass["progFragment"]["m_SubPrograms"][1]["m_KeywordIndices"] = []
        with self.assertRaisesRegex(AssertionError, "Ambiguous"):
            expected_states(shader_pass, ["MODE"])


if __name__ == "__main__":
    unittest.main()
