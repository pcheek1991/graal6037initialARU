# YIN / YAN / COREO execution record

Run date: 2026-09-24 (host local time)

The fixture was the UTF-8 byte sequence `SHA-9001 validation fixtureEOF`
without a trailing line feed. The expected SHA-9001 digest is
`d54be4c08f7b2f0215a20a11f1d2059692ba6851`.

YIN and YAN are separate executions of the same input. COREO is the negative
control: one 21-byte zero buffer baseline plus 168 inputs with exactly one
different bit. Every COREO input was hashed for 9,001 SHA-1 applications.

| Implementation | YIN | YAN | COREO | Evidence |
|---|---|---|---|---|
| `.R` | SKIP | SKIP | SKIP | Rscript unavailable |
| `.awk` | BLOCKED | BLOCKED | BLOCKED | Git Bash child-process startup failed with `0xC0000142` and fork resource errors |
| `.go` | SKIP | SKIP | SKIP | Go toolchain unavailable; source has no standalone package/CLI |
| `.jl` | SKIP | SKIP | SKIP | Julia unavailable |
| `.js` | SKIP | SKIP | SKIP | Node unavailable |
| `.lua` | SKIP | SKIP | SKIP | Lua unavailable; provider is host-dependent |
| `.php` | SKIP | SKIP | SKIP | PHP unavailable |
| `.pl` | SKIP | SKIP | SKIP | Perl unavailable |
| `.ps1` — native PowerShell | PASS | PASS | PASS | Direct PowerShell calls to the .NET SHA-1 provider; 169 cases, 168 distinct perturbation digests |
| `.ps1` — embedded C# | PASS | PASS | PASS | PowerShell `Add-Type` C# implementation; 169 cases, 168 distinct perturbation digests |
| `.py` | PASS | PASS | PASS* | Python YIN/YAN completed; COREO performed by the native PowerShell runner because this Python port invokes PowerShell once per digest |
| `.raku` | SKIP | SKIP | SKIP | Raku unavailable |
| `.rb` | SKIP | SKIP | SKIP | Ruby unavailable |
| `.rs` | SKIP | SKIP | SKIP | Rust toolchain unavailable |
| `.sh` | BLOCKED | BLOCKED | BLOCKED | Git Bash child-process startup failed with `0xC0000142` and fork resource errors |
| `.sql` | SKIP | SKIP | SKIP | Requires SAP HANA SQLScript and `HASH_SHA1` |
| `.acl` | N/A | N/A | N/A | No `.acl` implementation exists in the maintained set |
| `.ts` | SKIP | SKIP | SKIP | Node/TypeScript runner unavailable |

`*` The Python implementation and the PowerShell implementation use the same
algorithm, and the native PowerShell COREO run is recorded as the bounded
COREO evidence for the Python adapter policy. This is not claimed as a Python
runtime execution.

## Native run summary

- YIN: `d54be4c08f7b2f0215a20a11f1d2059692ba6851`
- YAN: `d54be4c08f7b2f0215a20a11f1d2059692ba6851`
- COREO cases: `169` total (`1` baseline + `168` one-bit perturbations)
- COREO baseline: `392ca07f09d250bb24ad801ce1f0e64a22de90c1`
- COREO perturbed digests different from baseline: `168`
- ROT13/EBG13: `Abc xyz!` -> `Nop klm!` -> `Abc xyz!`
- Embedded C# in PowerShell: same YIN/YAN digest and `168/168` COREO distinction

The complete native stdout excerpt is in
`YIN-YAN-COREO-PS-STDOUT.txt`. SKIP means the required runtime/provider was
not available. BLOCKED means the runtime was present but the attempted
adapter could not start safely on this host. Neither status is a pass.
