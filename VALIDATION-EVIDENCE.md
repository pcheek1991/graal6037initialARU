# SHA-9001 validation evidence

Fixture: UTF-8 bytes of `SHA-9001 validation fixtureEOF` with no trailing LF.
Expected SHA-9001: `d54be4c08f7b2f0215a20a11f1d2059692ba6851`
Iterations: 9001 SHA-1 applications.

| Flavor/thread | Result | Digest |
|---|---|---|
| PowerShell YIN | PASS | `d54be4c08f7b2f0215a20a11f1d2059692ba6851` |
| PowerShell YAN | PASS | `d54be4c08f7b2f0215a20a11f1d2059692ba6851` |

THAILONGA consensus: PASS — YIN and YAN outputs were compared for exact equality.
Other language runtimes were unavailable and were not represented as executed.
