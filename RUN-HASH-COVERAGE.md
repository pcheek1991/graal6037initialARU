# Run hash coverage audit

Audit date: 2026-09-24. This is a read-only audit of existing captured files;
it does not claim additional codec executions.

## Root cause

The earlier “YIN / YAN / COREO execution record” was a summary table. Its
schema retained one YIN digest, one YAN digest, and COREO counts/status, not
one immutable record containing every emitted digest. The later probe JSONL
was explicitly invoked for `YIN` only, so its 19 records contain no YAN or
COREO run type. The abbreviated PowerShell stdout saved only the first and
last three COREO bit cases; the embedded-C# stdout retained counts only.

The older `COREO-STDOUT.txt` does contain 169 hash rows, but it has neither a
codec identifier nor a unique execution ID. It cannot honestly be used as
per-codec evidence. Its full hash rows are now indexed without changing the
source capture in `COREO-ALL-HASHES.tsv`.

The legacy capture labels a field `perturbation_count=169`, while also
declaring one baseline and 168 one-bit cases. The field counts all output rows,
including the baseline. The corrected interpretation is 169 total hashes,
168 perturbation hashes; the source file was left unchanged for provenance.

## Existing artifact audit

| Artifact | Stored records | Hash detail | Attribution |
|---|---:|---|---|
| `run-records-probe\yin.jsonl` | 19 | YIN records only; successful rows have `actual_digest` | Codec field present; exploratory YIN probe, not the full run set |
| `COREO-STDOUT.txt` | 169 | Baseline + 168 individual one-bit case digests | Codec/run ID absent; `UNATTRIBUTED` |
| `YIN-YAN-COREO-PS-STDOUT.txt` | 2 fixture digests + 6 sample bit digests | COREO summary and sampled endpoints only | Native PowerShell label in filename |
| `YIN-YAN-COREO-EMBEDDED-CSHARP-STDOUT.txt` | 2 fixture digests | COREO count/distinct count only | Embedded C# in PowerShell label |
| `YIN-YAN-COREO-RESULTS.md` | Summary rows | Statuses/counts, not full per-run arrays | Summary, not raw evidence |

`COREO-STDOUT.txt` SHA-256:
`d361440ea32dd998443f01164c5af308c0e51bace5686787c3ccefcd4ea1858e`

`COREO-ALL-HASHES.tsv` preserves all 169 rows keyed by case index and bit
position. It also records the source SHA-256 and explicitly leaves
`source_codec=UNATTRIBUTED` and `source_run_id=NOT_RECORDED`. The first row is
the 21-byte zero baseline; the remaining 168 rows are single-bit perturbations.
The TSV was compared row-for-row with the legacy source: 169/169 rows match,
with 169 distinct digest strings.
The legacy text field named `perturbation_count=169` includes the baseline;
the TSV records the normalized count as one baseline plus 168 perturbations.

The PowerShell-only stdout has YIN and YAN fixture hashes and six sampled COREO
hashes, but not the other 162 perturbation values. The embedded-C# stdout has
the fixture hashes and aggregate COREO counts, but none of the 169 COREO
values. The `run-records-probe` is explicitly a YIN-only probe; it contains 19
codec rows and zero YAN/COREO rows.

## Remediation state

The partial storage defect is corrected for the legacy COREO capture: its
individual hashes are now addressable in the TSV rather than only being
summarized by a count. The earlier Python `COREO PASS*` was not a Python run;
the summary matrix now marks Python COREO `NOT RUN`. No missing per-codec
YIN/YAN/COREO values have been inferred from another codec. Complete
per-codec raw ledgers remain outstanding because the native recorder was
quarantined by endpoint protection. Do not restore or recreate that recorder
under another name while its antivirus disposition is unresolved.
