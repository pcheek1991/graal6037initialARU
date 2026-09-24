# SHA-9001 test strategy

The repository includes Python tests and separate native PowerShell and
embedded-C# PowerShell test scripts:
`tests/test_sha9001.py`, `tests/test_sha9001.ps1`, and
`tests/test_sha9001-csharp.ps1`. They cover:

- **Unit tests:** the deterministic fixture, ROT13/EBG13 behavior, NUL rejection,
  negative distances, non-ASCII passthrough, and digest width.
- **Static contract checks:** required SHA-1, iteration, and exported function
  markers are present, and each maintained language source exposes its ROT
  entry points; `.acl` is explicitly not a maintained implementation.
- **Dynamic load tests:** the Python module and .NET SHA-1 provider load and
  expose the expected callable/provider surface. The native PowerShell and
  embedded-C# scripts are tested independently.
- **Bounded stress tests:** repeated hashing of a 4 KiB payload in three
  independent cases, with a 20-byte output assertion.

Run:

```text
python -m unittest discover -s tests -v
powershell -NoProfile -File tests\test_sha9001.ps1
powershell -NoProfile -File tests\test_sha9001-csharp.ps1
```

These are project-level reproducibility tests following a documented,
risk-based lifecycle: requirements are explicit, critical transformations have
unit and negative tests, runtime loading is checked, and bounded stress results
are recorded. SHA-9001 remains a custom iterative SHA-1 construction and is
not presented as a general-purpose cryptographic primitive.

The C# implementation is compiled only by its own `.ps1` project. The native
reference `.ps1` never chooses or invokes that implementation. ROT is a
text transformation only; the legacy HMAC comparison is self-referential and
must not be treated as authentication.
