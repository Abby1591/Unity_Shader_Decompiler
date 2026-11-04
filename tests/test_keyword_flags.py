import unittest

from libs.metadata import ShaderMetadata


class KeywordFlagsTests(unittest.TestCase):
    def test_array_and_base64_keep_local_and_global_scope(self):
        for flags in ([0, 1], "AAE="):
            with self.subTest(flags=flags):
                self.assertEqual(ShaderMetadata._keyword_flags({
                    "m_KeywordNames": ["GLOBAL", "LOCAL"], "m_KeywordFlags": flags,
                }), {"GLOBAL": 0, "LOCAL": 1})

    def test_missing_flags_are_not_invented(self):
        self.assertEqual(ShaderMetadata._keyword_flags({"m_KeywordNames": ["MODE"]}), {})

    def test_malformed_flags_fail(self):
        for flags in ([], [0, 1], [True], [-1], [256], "!bad!"):
            with self.subTest(flags=flags), self.assertRaises(ValueError):
                ShaderMetadata._keyword_flags({"m_KeywordNames": ["MODE"], "m_KeywordFlags": flags})

    def test_duplicate_names_fail(self):
        with self.assertRaises(ValueError):
            ShaderMetadata._keyword_flags({"m_KeywordNames": ["MODE", "MODE"], "m_KeywordFlags": [0, 1]})
