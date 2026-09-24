# SHA-9001 test strategy

`tests/test_sha9001.py` covers the known fixture, 160-bit output width,
dynamic module loading, and static contract markers. The private archive also
contains a PowerShell test covering its provider and exported ROT functions.

These are reproducibility tests following a documented, risk-based lifecycle:
requirements are explicit, critical transformations have unit and negative
tests, and runtime loading is checked. SHA-9001 is a custom iterative SHA-1
construction.
