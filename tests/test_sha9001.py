"""Unit, contract, static-load, and bounded stress tests for SHA-9001."""
from __future__ import annotations

import importlib.util
import pathlib
import tempfile
import unittest

ROOT = pathlib.Path(__file__).parents[1]
EXPECTED = "d54be4c08f7b2f0215a20a11f1d2059692ba6851"
ROT_SURFACES = {
    "sha9001.R": ("rotn", "rot13", "ebg13"),
    "sha9001.awk": ("rotn", "rot13", "ebg13"),
    "sha9001.go": ("rotn", "rot13", "ebg13"),
    "sha9001.jl": ("rotn", "rot13", "ebg13"),
    "sha9001.js": ("rotn", "rot13", "ebg13"),
    "sha9001.lua": ("rotn", "rot13", "ebg13"),
    "sha9001.php": ("rotn", "rot13", "ebg13"),
    "sha9001.pl": ("rotn", "rot13", "ebg13"),
    "sha9001.ps1": ("ConvertTo-SignedRot", "Invoke-ROT13", "Invoke-EBG13"),
    "sha9001-csharp.ps1": ("ConvertTo-SignedRotCSharp", "Invoke-ROT13CSharp", "Invoke-EBG13CSharp"),
    "sha9001.py": ("rotn", "rot13", "ebg13"),
    "sha9001.raku": ("rotn", "rot13", "ebg13"),
    "sha9001.rb": ("rotn", "rot13", "ebg13"),
    "sha9001.rs": ("rotn", "rot13", "ebg13"),
    "sha9001.sh": ("rotn", "rot13", "ebg13"),
    "sha9001.sql": ("rotn", "rot13", "ebg13"),
    "sha9001.tcl": ("rotn", "rot13", "ebg13"),
    "sha9001.ts": ("rotn", "rot13", "ebg13"),
}


def load_module():
    spec = importlib.util.spec_from_file_location("sha9001_reference", ROOT / "sha9001.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class Sha9001Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.mod = load_module()

    def test_known_fixture(self):
        self.assertEqual(
            self.mod.sha9001_bytes(b"SHA-9001 validation fixtureEOF").hex(),
            EXPECTED,
        )

    def test_rot_contract_and_rejection(self):
        key = b"test-key"
        self.assertEqual(self.mod.rot13("Abc, 123!", key), "Nop, 123!")
        self.assertEqual(self.mod.ebg13("Nop, 123!", key), "Abc, 123!")
        self.assertEqual(self.mod.rotn("Az", -1, key), "Zy")
        self.assertEqual(self.mod.rotn("Aé!", 13, key), "Né!")
        self.assertEqual(self.mod.rot13("Abc", b"different-key"), "Nop")
        with self.assertRaises(ValueError):
            self.mod.rot13("bad\0input", key)

    def test_rot_api_surface_in_every_maintained_flavor(self):
        for filename, markers in ROT_SURFACES.items():
            source = (ROOT / filename).read_text(encoding="utf-8").lower()
            for marker in markers:
                self.assertIn(marker.lower(), source, f"{filename} is missing {marker}")

    def test_dynamic_module_load(self):
        self.assertTrue(callable(self.mod.rot13))
        self.assertTrue(callable(self.mod.ebg13))

    def test_static_contract_markers(self):
        source = (ROOT / "sha9001.py").read_text(encoding="utf-8")
        for marker in ("import os", "sha9001_bytes", "9001", "os.popen"):
            self.assertIn(marker, source)

    def test_bounded_stress(self):
        payload = b"x" * 4096
        for _ in range(3):
            digest = self.mod.sha9001_bytes(payload)
            self.assertEqual(len(digest), 20)


if __name__ == "__main__":
    unittest.main()
