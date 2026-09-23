# SHA-9001 validation evidence

Fixture: UTF-8 bytes of `SHA-9001 validation fixture` followed by LF.

Iterations: 9001 SHA-1 applications
Digest width: 160 bits

| Flavor | Execution status | Evidence |
|---|---|---|
| PowerShell | PASS | Executed locally; digest matched the expected value in the prior validation run |
| Python | NOT RUN | Implementation exists; no execution evidence recorded in this run |
| R | NOT RUN | Rscript runtime unavailable in the execution environment |
| JavaScript | NOT RUN | Node runtime unavailable in the execution environment |
| TypeScript | NOT RUN | TypeScript/Node runtime unavailable in the execution environment |
| Go | NOT RUN | Go runtime unavailable in the execution environment |
| Rust | NOT RUN | Rust runtime unavailable in the execution environment |

No `.hash` file is represented as proof of an execution that did not occur. Archive `.hash` files identify content; this manifest identifies validation execution status.
