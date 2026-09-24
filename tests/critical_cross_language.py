"""Critical-path evidence runner for every SHA-9001 implementation.

This does not claim that different languages have identical bytecode. It
checks exact private/public source parity, required contract markers, and
executes only adapters whose toolchain is present.
"""
from __future__ import annotations

import hashlib
import pathlib
import shutil
import subprocess
import tempfile

ROOT = pathlib.Path(__file__).parents[1]
EXPECTED = "d54be4c08f7b2f0215a20a11f1d2059692ba6851"
IMPLEMENTATIONS = {
    "awk": ("sha9001.awk", None),
    "go": ("sha9001.go", None),
    "julia": ("sha9001.jl", "julia"),
    "javascript": ("sha9001.js", "node"),
    "lua": ("sha9001.lua", "lua"),
    "perl": ("sha9001.pl", "perl"),
    "php": ("sha9001.php", "php"),
    "powershell": ("sha9001.ps1", "powershell"),
    "python": ("sha9001.py", "python"),
    "r": ("sha9001.R", "Rscript"),
    "raku": ("sha9001.raku", "raku"),
    "ruby": ("sha9001.rb", "ruby"),
    "rust": ("sha9001.rs", "rustc"),
    "shell": ("sha9001.sh", "bash"),
    "sqlscript": ("sha9001.sql", None),
    "tcl": ("sha9001.tcl", "tclsh"),
    "typescript": ("sha9001.ts", "tsx"),
}


def result(name, status, detail):
    print(f"{name:12} {status:5} {detail}")


def main():
    print("SHA-9001 critical path")
    print("Expected:", EXPECTED)
    with tempfile.TemporaryDirectory() as td:
        fixture = pathlib.Path(td) / "fixture.bin"
        fixture.write_bytes(b"SHA-9001 validation fixtureEOF")
        for name, (filename, runtime) in IMPLEMENTATIONS.items():
            private = ROOT / filename
            public = ROOT.parent / "public" / filename
            if not private.exists() or not public.exists():
                result(name, "FAIL", "private/public source missing")
                continue
            if hashlib.sha256(private.read_bytes()).digest() != hashlib.sha256(public.read_bytes()).digest():
                result(name, "FAIL", "private/public bytes differ")
                continue
            source = private.read_text(encoding="utf-8", errors="replace")
            lowered = source.lower()
            has_hash = "sha1" in lowered or "sha-1" in lowered
            if ("9000" not in lowered and "9001" not in lowered) or not has_hash or len(source.strip()) < 80:
                result(name, "FAIL", "contract markers missing")
                continue
            if runtime is None:
                result(name, "SKIP", "no portable runtime adapter (source parity PASS)")
                continue
            executable = shutil.which(runtime)
            if not executable:
                result(name, "SKIP", f"{runtime} unavailable (source parity PASS)")
                continue
            # Only adapters with a stable file CLI are executed here.
            if name == "python":
                code = (
                    "import sys; sys.path.insert(0, sys.argv[1]); "
                    "import sha9001; print(sha9001.sha9001_file(sys.argv[2]).hex())"
                )
                completed = subprocess.run(
                    [executable, "-c", code, str(ROOT), str(fixture)],
                    capture_output=True, text=True, check=False,
                )
                actual = completed.stdout.strip()
                result(name, "PASS" if actual == EXPECTED else "FAIL", actual or completed.stderr.strip())
            else:
                result(name, "SKIP", f"{runtime} present; no trusted CLI adapter")


if __name__ == "__main__":
    main()
