"""Offline regression corpus; build the Release CLI before running this file."""
import hashlib
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FIXTURES = ROOT / "tests/Fixtures/VolumetricLights"
CLI = ROOT / "src/UnityShaderDecompiler.Cli/bin/Release/net10.0/Shader Decompiler.dll"


class VolumetricLightsTests(unittest.TestCase):
    def test_fixture_integrity(self):
        manifest = json.loads((FIXTURES / "manifest.json").read_text())
        for name, expected in manifest["files"].items():
            with self.subTest(file=name):
                self.assertEqual(expected, hashlib.sha256((FIXTURES / name).read_bytes()).hexdigest())

    def check_shader(self, name):
        source = FIXTURES / "Json" / (name + ".json")
        data = json.loads(source.read_text(encoding="utf-8-sig"))
        self.assertEqual([4], data["platforms"], "Fixture must contain only D3D11")
        self.assertTrue(CLI.is_file(), "Build the Release CLI first")
        with tempfile.TemporaryDirectory(prefix="volumetric-lights-") as temporary:
            folder = Path(temporary)
            self.run_checked([sys.executable, str(ROOT / "Extract.py"), str(source),
                              "--flat", "--out-dir", str(folder / "input")])
            log = self.run_checked(["dotnet", str(CLI), str(folder / "input"),
                                    "--no-fuse-temps", "--out-root", str(folder / "output")])
            self.assertNotIn("No DXBC:", log, "Decompiler silently dropped a blob record")
            shaders = list((folder / "output").glob("*.shader"))
            self.assertEqual(1, len(shaders))
            text = shaders[0].read_text(encoding="utf-8-sig")
            self.assertIn('Shader "' + data["m_ParsedForm"]["m_Name"] + '"', text)
            self.assertIn("#pragma vertex", text)
            self.assertIn("#pragma fragment", text)

    def run_checked(self, command):
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=600)
        self.assertEqual(0, result.returncode, result.stdout + result.stderr)
        return result.stdout + result.stderr

    def test_bilateral_blur(self):
        self.check_shader("BilateralBlur")

    def test_blit_add(self):
        self.check_shader("BlitAdd")

    def test_volumetric_light(self):
        self.check_shader("VolumetricLight")


if __name__ == "__main__":
    unittest.main()
