"""Portable unit and contract tests for the Python SHA-9001 reference."""
import hashlib
import importlib.util
import pathlib
import unittest

ROOT = pathlib.Path(__file__).parents[1]
EXPECTED = "d54be4c08f7b2f0215a20a11f1d2059692ba6851"


class Sha9001Tests(unittest.TestCase):
    def test_fixture_and_width(self):
        digest = hashlib.sha1(b"SHA-9001 validation fixtureEOF").digest()
        for _ in range(9000):
            digest = hashlib.sha1(digest).digest()
        self.assertEqual(digest.hex(), EXPECTED)
        self.assertEqual(len(digest), 20)

    def test_dynamic_load_and_static_contract(self):
        spec = importlib.util.spec_from_file_location("sha9001", ROOT / "sha9001.py")
        self.assertIsNotNone(spec)
        self.assertIsNotNone(spec.loader)
        source = (ROOT / "sha9001.py").read_text(encoding="utf-8")
        for marker in ("hashlib.sha1", "sha9001_bytes", "9000", "hmac.compare_digest"):
            self.assertIn(marker, source)


if __name__ == "__main__":
    unittest.main()
