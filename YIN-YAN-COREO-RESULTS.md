# YIN / YAN / COREO execution record

Run date: 2026-09-24 (host local time)

The fixture was the UTF-8 byte sequence `SHA-9001 validation fixtureEOF`
without a trailing line feed. The expected SHA-9001 digest is
`d54be4c08f7b2f0215a20a11f1d2059692ba6851`.

## Hash-record completeness and provenance

This Markdown file is a summary matrix, not the raw run ledger. The actual
record audit is `RUN-HASH-COVERAGE.md`.

- All 169 hashes in the existing legacy COREO capture (one baseline plus 168
  one-bit cases) are now indexed in `COREO-ALL-HASHES.tsv`. The source capture
  is preserved unchanged and identified by its SHA-256 in that TSV.
- The legacy COREO capture does not identify its codec or a unique execution
  ID. Its hashes are therefore recorded as `UNATTRIBUTED`, not assigned to a
  codec by inference.
- `run-records-probe\yin.jsonl` contains 19 YIN probe records only; it was
  explicitly run with YIN only. It contains no YAN or COREO rows.
- The PowerShell stdout artifacts have YIN/YAN digests, but the native
  PowerShell file contains only a COREO count and six sampled bit hashes; the
  embedded-C# file contains only COREO counts. No complete per-codec COREO
  digest arrays or authoritative per-codec YAN ledger are present.
- The prior `.py` COREO `PASS*` reused the native PowerShell control; Python
  itself did not execute COREO. Its status is corrected below to `NOT RUN`.

Consequently, the previous table records execution status, but it is not
evidence that complete, uniquely keyed YIN/YAN/COREO hash records have been
persisted for every codec. Missing hashes are not reconstructed from another
codec's output.

YIN and YAN are separate executions of the same input. COREO is the negative
control: one 21-byte zero buffer baseline plus 168 inputs with exactly one
different bit. Every COREO input was hashed for 9,001 SHA-1 applications.

| Implementation | YIN | YAN | COREO | Evidence |
|---|---|---|---|---|
| `.R` | PASS | PASS | PASS | R 4.6.1 with user-installed `openssl`; 169 cases, 168 distinct perturbation digests |
| `.awk` | BLOCKED | BLOCKED | BLOCKED | Git Bash child-process startup failed with `0xC0000142` and fork resource errors |
| `.go` | PASS | PASS | PASS | Go 1.27.0; source exercised through a temporary CLI wrapper because the maintained file intentionally has no package declaration; 169 cases, 168 distinct perturbation digests |
| `.jl` | PASS | PASS | PASS | Julia 1.13.0; corrected soft-scope CLI; 169 cases, 168 distinct perturbation digests |
| `.js` | PASS | PASS | PASS | Node.js 26.7.0; module adapter; 169 cases, 168 distinct perturbation digests |
| `.lua` | BLOCKED | BLOCKED | BLOCKED | Lua/LuaJIT package is recorded but no executable/provider module is available |
| `.php` | PASS | PASS | PASS | PHP 8.4.25; 169 cases, 168 distinct perturbation digests |
| `.pl` | PASS | PASS | PASS | Git Perl with `Digest::SHA`; 169 cases, 168 distinct perturbation digests |
| `.ps1` — native PowerShell | PASS | PASS | PASS | Direct PowerShell calls to the .NET SHA-1 provider; 169 cases, 168 distinct perturbation digests |
| `.ps1` — embedded C# | PASS | PASS | PASS | PowerShell `Add-Type` C# implementation; 169 cases, 168 distinct perturbation digests |
| `.py` | PASS | PASS | NOT RUN | Python YIN/YAN completed; no Python COREO run was recorded |
| `.raku` | PASS | PASS | BLOCKED | Rakudo 26.7.1 with `Digest::SHA1`; independent YIN/YAN passed; in-process COREO optimization still exceeded the host time budget |
| `.rb` | BLOCKED | BLOCKED | BLOCKED | Ruby 3.3 installation fails Windows side-by-side startup |
| `.rs` | BLOCKED | BLOCKED | BLOCKED | Rust 1.89 toolchain present, but MSVC `link.exe` is unavailable on this host |
| `.sh` | BLOCKED | BLOCKED | BLOCKED | Git Bash child-process startup failed with `0xC0000142` and fork resource errors |
| `.sql` | BLOCKED | BLOCKED | BLOCKED | Requires SAP HANA SQLScript and `HASH_SHA1`, unavailable on this host |
| `.acl` | N/A | N/A | N/A | No `.acl` implementation exists in the maintained set |
| `.ts` | PASS | PASS | PASS | Node.js 26.7.0 native type stripping; 169 cases, 168 distinct perturbation digests |

## Native run summary

- YIN: `d54be4c08f7b2f0215a20a11f1d2059692ba6851`
- YAN: `d54be4c08f7b2f0215a20a11f1d2059692ba6851`
- COREO cases: `169` total (`1` baseline + `168` one-bit perturbations)
- COREO baseline: `392ca07f09d250bb24ad801ce1f0e64a22de90c1`
- COREO perturbed digests different from baseline: `168`
- ROT13/EBG13: `Abc xyz!` -> `Nop klm!` -> `Abc xyz!`
- Embedded C# in PowerShell: same YIN/YAN digest and `168/168` COREO distinction
- JavaScript, Julia, Perl, and R: each completed independent YIN/YAN and
  169-case COREO runs

The native PowerShell stdout file is a summary with sampled bit hashes, not
the full 169-row COREO output. The complete legacy trace is
`COREO-STDOUT.txt`; its all-hash index is `COREO-ALL-HASHES.tsv`, whose codec
and run ID remain unattributed. `RUN-HASH-COVERAGE.md` distinguishes existing
per-codec evidence from missing per-codec records. `SKIP`, `NOT RUN`,
`BLOCKED`, and `N/A` are not passes.

## ROT compatibility vectors

The compatibility vectors are `Abc xyz!` -> `Nop klm!` -> `Abc xyz!`,
`ROTN("Az", -1)` -> `Zy`, and `ROTN("Aé!", 13)` -> `Né!`. The key argument is
compatibility-only and does not authenticate the request.

| Flavor | ROT vectors | Evidence |
|---|---|---|
| `.R`, `.awk`, `.go`, `.jl`, `.js`, `.php`, `.pl`, `.ps1` native, `.ps1` embedded C#, `.py`, `.raku`, `.tcl`, `.ts` | PASS | Executed golden vectors on the available runtime; PowerShell tests also verify NUL rejection |
| `.lua` | NOT RUN | No Lua executable/provider module available |
| `.rb` | BLOCKED | Ruby executable fails side-by-side startup |
| `.rs` | BLOCKED | Rust linker unavailable |
| `.sh` | BLOCKED | Git Bash child process startup fails with `0xC0000142` |
| `.sql` | SOURCE ONLY | HANA `TRANSLATE` implementation added; no HANA instance available; NUL handling not claimed |
| `.acl` | N/A | No maintained `.acl` implementation |
