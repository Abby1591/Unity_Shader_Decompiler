# Checks shader extraction and decompilation behavior.
"""Offline regression corpus; build the Release CLI before running this file."""
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

CORPUS_ROOT = Path(__file__).resolve().parents[2]
ROOT = Path(os.environ.get("USD_REPO_ROOT", CORPUS_ROOT)).resolve()
FIXTURES = CORPUS_ROOT / "tests/Fixtures/VolumetricLights"
CLI = ROOT / "src/UnityShaderDecompiler.Cli/bin/Release/net10.0/Shader Decompiler.dll"


# Reads DirectX code indices separately from parameter-record indices.
def expected_programs(data):
    """Read code references, never parameter-record indices, from the export."""
    stages = {"progVertex": ({15, 16}, "Vertex"),
              "progFragment": ({17, 18}, "Fragment")}
    expected = {}
    for subshader in data["m_ParsedForm"]["m_SubShaders"]:
        for shader_pass in subshader["m_Passes"]:
            for field, (types, stage) in stages.items():
                program = shader_pass[field]
                groups = [program["m_SubPrograms"], *program["m_PlayerSubPrograms"]]
                references = [item for group in groups for item in group
                              if item["m_GpuProgramType"] in types]
                if not references:
                    raise AssertionError(f"No DirectX {stage} references in a fixture pass")
                for item in references:
                    index = item["m_BlobIndex"]
                    if index in expected and expected[index] != stage:
                        raise AssertionError(f"Conflicting stages for program {index}")
                    expected[index] = stage
    return expected


# Rejects any missing or incorrectly classified DirectX program.
def verify_programs(expected, log):
    collected = {int(index): stage for stage, index in re.findall(
        r"Stage 2: collected (\w+) function '[^']+' \(subprogram (\d+)\)\.", log)}
    for index, stage in expected.items():
        if collected.get(index) != stage:
            raise AssertionError(f"Missing DirectX {stage} program {index}")


# Covers shader metadata regression cases.
class VolumetricLightsTests(unittest.TestCase):
    # Checks fixture integrity.
    def test_fixture_integrity(self):
        manifest = json.loads((FIXTURES / "manifest.json").read_text())
        for name, expected in manifest["files"].items():
            with self.subTest(file=name):
                self.assertEqual(expected, hashlib.sha256((FIXTURES / name).read_bytes()).hexdigest())

    # Checks extraction and every expected DirectX program for one fixture.
    def check_shader(self, name):
        source = FIXTURES / "Json" / (name + ".json")
        data = json.loads(source.read_text(encoding="utf-8-sig"))
        self.assertEqual([4], data["platforms"], "Fixture must contain only D3D11")
        expected = expected_programs(data)
        self.assertTrue(CLI.is_file(), "Build the Release CLI first")
        with tempfile.TemporaryDirectory(prefix="volumetric-lights-") as temporary:
            folder = Path(temporary)
            self.run_checked([sys.executable, str(ROOT / "Extract.py"), str(source),
                              "--flat", "--out-dir", str(folder / "input")])
            log = self.run_checked(["dotnet", str(CLI), str(folder / "input"),
                                    "--no-fuse-temps", "--save-subprograms",
                                    "--out-root", str(folder / "output")])
            verify_programs(expected, log)
            for index in expected:
                dxbc = folder / "output" / f"program{index}.dxbc"
                self.assertTrue(dxbc.is_file(), f"Missing DXBC artifact for program {index}")
                self.assertEqual(b"DXBC", dxbc.read_bytes()[:4])
            shaders = list((folder / "output").glob("*.shader"))
            self.assertEqual(1, len(shaders))
            text = shaders[0].read_text(encoding="utf-8-sig")
            self.assertIn('Shader "' + data["m_ParsedForm"]["m_Name"] + '"', text)
            self.assertIn("#pragma vertex", text)
            self.assertIn("#pragma fragment", text)

    # Runs a pipeline command and rejects unsuccessful completion.
    def run_checked(self, command):
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, timeout=600)
        self.assertEqual(0, result.returncode, result.stdout + result.stderr)
        return result.stdout + result.stderr

    # Checks bilateral blur.
    def test_bilateral_blur(self):
        self.check_shader("BilateralBlur")

    # Checks blit add.
    def test_blit_add(self):
        self.check_shader("BlitAdd")

    # Checks volumetric light.
    def test_volumetric_light(self):
        self.check_shader("VolumetricLight")

    # Checks parameter records are not code references.
    def test_parameter_records_are_not_code_references(self):
        data = json.loads((FIXTURES / "Json/BlitAdd.json").read_text())
        self.assertEqual({1: "Vertex", 3: "Fragment"}, expected_programs(data))

    # Checks missing directx program is rejected.
    def test_missing_directx_program_is_rejected(self):
        log = "Stage 2: collected Vertex function 'vert' (subprogram 1)."
        with self.assertRaisesRegex(AssertionError, "Missing DirectX Fragment program 3"):
            verify_programs({1: "Vertex", 3: "Fragment"}, log)

    # Checks parameter diagnostic does not hide program loss.
    def test_parameter_diagnostic_does_not_hide_program_loss(self):
        log = "No DXBC: Unknown shader blob format.\n"
        with self.assertRaisesRegex(AssertionError, "Missing DirectX Vertex program 1"):
            verify_programs({1: "Vertex"}, log)
        log += "Stage 2: collected Vertex function 'vert' (subprogram 1)."
        verify_programs({1: "Vertex"}, log)


if __name__ == "__main__":
    unittest.main()
