# SHA-9001 validation evidence

Fixture: UTF-8 bytes of `SHA-9001 validation fixtureEOF`, with no trailing LF.
Expected SHA-9001: `d54be4c08f7b2f0215a20a11f1d2059692ba6851`.
Construction: 9,001 SHA-1 applications; output width: 160 bits.

The current per-language YIN/YAN/COREO results, including `PASS`, `BLOCKED`,
and `N/A` states, are maintained in `YIN-YAN-COREO-RESULTS.md`. That file is
the authoritative execution matrix; source parity is not described as runtime
execution.

## PowerShell gold standard

`sha9001.ps1` matches the source content at revision
`6fccadd22ed2cebe91634bce8413db380dcc1766` and runs as the native PowerShell
implementation. `sha9001-csharp.ps1` is a second, separate project that uses
PowerShell `Add-Type` to compile its embedded C# SHA/ROT implementation. They
are independently exercised by `tests/test_sha9001.ps1` and
`tests/test_sha9001-csharp.ps1`. Both produce the expected fixture digest.

The ROT golden vectors are documented in `SHA9001.md` and covered by both
PowerShell test scripts. The historical `ConvertTo-SignedRot` name does not
imply authentication: the reference calculates HMAC outputs and XORs each
output with itself, which always yields zero. The key is retained for API
compatibility only. Do not use the ROT functions as a security control.

## COREO definition

COREO hashes a 21-byte all-zero baseline and each of the 168 possible
one-bit perturbations. A passing control has 168 perturbed digests different
from the baseline. COREO is a negative control, not an authentication or
collision-resistance claim.
