"""Unit, contract, static-load, and bounded stress tests for SHA-9001."""
from __future__ import annotations

import importlib.util
import pathlib
import tempfile
import unittest

ROOT = pathlib.Path(__file__).parents[1]
EXPECTED = "d54be4c08f7b2f0215a20a11f1d2059692ba6851"


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
        with self.assertRaises(ValueError):
            self.mod.rot13("bad\0input", key)

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
