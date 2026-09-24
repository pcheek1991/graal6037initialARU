# Security proof-of-concept and remediation record

This document provides **safe, non-destructive proofs of behavior and impact** for the three reported findings. It does not provide a weaponized exploit, destructive deletion command, credential theft, persistence, or exfiltration procedure. The antivirus alerts remain user-reported and attributed to NETGEAR ARMOR powered by Bitdefender; that attribution is not independently verified here.

## Findings and proof status

| ID | Finding | Safe proof | Exploit status |
|---|---|---|---|
| F-I | Recursive publication generator reads files/ACL metadata and creates copies, mirrors, hashes, and indexes | Run only against a disposable fixture containing a canary file and synthetic ACL metadata; verify expected output paths and that the canary content is copied into the private staging tree | Demonstrated data duplication and metadata collection; no network exfiltration or persistence demonstrated |
| F-II | Destructive regeneration variant deletes `_publication` recursively before rebuilding | In a disposable parent, create `_publication\canary.txt`, resolve the exact target path, and replace the deletion operation with a dry-run listing; the dry-run proves the deletion set without deleting anything | Destructive impact is evident from the command semantics; no destructive execution was performed for this record |
| F-III | Signed ROT check recomputes both HMACs locally instead of accepting an independently supplied MAC | Call the function with a caller-supplied key and compare its internally generated values; there is no external signature parameter or verification boundary | Integrity/authentication weakness demonstrated by API shape; no downstream security-sensitive exploit demonstrated |

## C-I through C-IX: control and evidence requirements

- **C-I — Scope isolation:** execute only in a disposable fixture directory; reject workspace-root and system paths.
- **C-II — Destructive-operation gate:** do not delete recursively unless the path is explicitly approved, normalized, and confirmed as generated output.
- **C-III — Dry-run proof:** expose a mode that lists files, directories, ACL reads, and writes without mutating or publishing anything.
- **C-IV — Least-privilege execution:** run without administrator rights and deny access to credential stores, registry autoruns, scheduled tasks, and unrelated directories.
- **C-V — Input/output manifest:** record every source and destination path, byte count, and operation before execution; fail closed on unexpected paths.
- **C-VI — Secret boundary:** never treat a locally generated HMAC as proof of an externally authenticated signature; require an independently supplied MAC and protect the key.
- **C-VII — Publication review:** require human review before copying artifacts to a public repository; redact secrets, personal data, credentials, and proprietary third-party content.
- **C-VIII — Audit telemetry:** preserve command line, parent process, user, timestamps, hashes, exit status, and security-product event identifiers.
- **C-IX — Recovery and rollback:** snapshot or back up generated output before regeneration and provide an atomic, reversible update path.

## D-I through D-III: proposed remediation

- **D-I — Safe staging redesign:** replace in-place recursive deletion with a newly created, uniquely named staging directory. Use an allowlisted source root, canonical path checks, and an explicit dry-run approval before promotion.
- **D-II — Authenticated API redesign:** change signed ROT functions to accept `(value, distance, suppliedMac, key)` and verify the supplied MAC with a constant-time comparison. Document that ROT13 itself is not encryption or authentication.
- **D-III — Evidence and publication controls:** add a machine-readable manifest and security review gate; publish only reviewed derived artifacts, retain full logs locally, and attach vendor telemetry when documenting antivirus detections.

## Safe PoC sketches

### F-I: non-destructive copy/metadata proof

Create a disposable fixture with one harmless text file. Run the generator in dry-run mode or a test harness that replaces `Copy-Item`, `Get-Acl`, and `WriteAllBytes` with logging stubs. Assert that the logged source and destination are inside the fixture and staging directories, and assert that no network or process-spawn API is called.

### F-II: deletion-set proof without deletion

Resolve the target with `Convert-Path`, verify it is a child of the intended staging root, and enumerate the would-be deletion set with `Get-ChildItem -Force -Recurse`. Do not call `Remove-Item`. The resulting manifest is sufficient evidence that the original command has recursive destructive capability.

### F-III: external-MAC proof

Use two independent HMAC computations: one producer creates a MAC, and a separate verifier receives the value as an argument. Change one byte of the supplied MAC and assert verification fails. The current self-referential implementation cannot perform this test because it has no supplied-MAC parameter; that absence is the recorded design defect.

## Conclusion

The evidence supports unsafe data duplication/metadata collection, a destructive regeneration primitive, and a self-referential integrity check. It does not support claiming arbitrary code execution, credential theft, persistence, or exfiltration from the reviewed source. Further investigation should use the exact antivirus event, process tree, hashes, and PowerShell logs.
