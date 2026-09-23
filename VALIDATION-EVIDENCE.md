# SHA-9001 validation evidence

Fixture: UTF-8 bytes of `SHA-9001 validation fixtureEOF` with no trailing LF.
Expected SHA-9001: `d54be4c08f7b2f0215a20a11f1d2059692ba6851`
Iterations: 9001 SHA-1 applications.
YIN and YAN are independent runs; THAILONGA requires both to match the expected digest.

| Flavor | YIN | YAN | Status |
|---|---|---|---|
| PowerShell | `d54be4c08f7b2f0215a20a11f1d2059692ba6851` | `d54be4c08f7b2f0215a20a11f1d2059692ba6851` | PASS |
| Python | `d54be4c08f7b2f0215a20a11f1d2059692ba6851` | `d54be4c08f7b2f0215a20a11f1d2059692ba6851` | PASS |
| Lua | NOT RUN | NOT RUN | UNAVAILABLE |
| Go | NOT RUN | NOT RUN | UNAVAILABLE |
| TypeScript | NOT RUN | NOT RUN | UNAVAILABLE |
| R | NOT RUN | NOT RUN | UNAVAILABLE |
| JavaScript | NOT RUN | NOT RUN | UNAVAILABLE |
| Ruby | NOT RUN | NOT RUN | UNAVAILABLE |
| Rust | NOT RUN | NOT RUN | UNAVAILABLE |

THAILONGA consensus: PASS for the executed PowerShell and Python pairs; unavailable runtimes are not represented as executed.
