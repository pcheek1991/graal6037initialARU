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
| POSIX shell | NOT RUN | NOT RUN | UNAVAILABLE |
| Perl | NOT RUN | NOT RUN | UNAVAILABLE |
| PHP | NOT RUN | NOT RUN | UNAVAILABLE |
| SAP HANA SQLScript | NOT RUN | NOT RUN | UNAVAILABLE |
| Awk | NOT RUN | NOT RUN | UNAVAILABLE |
| Tcl | NOT RUN | NOT RUN | UNAVAILABLE |
| Julia | NOT RUN | NOT RUN | UNAVAILABLE |
| Raku | NOT RUN | NOT RUN | UNAVAILABLE |

THAILONGA consensus: PASS for the executed PowerShell and Python pairs; unavailable runtimes are not represented as executed.

The added shell, Perl, PHP, and SQLScript ports are source-reviewed but not claimed as runtime passes. SQLScript requires a compatible SAP HANA `HASH_SHA1` binary function.
The intentionally impractical Awk, Tcl, Julia, and Raku ports are source-only until their interpreters and required modules are available.


## COREO documented output

COREO is the deliberate negative control: it confirms that controlled input perturbations do not validate as the unmodified input. SHA-9001 returns a 20-byte (160-bit) digest. COREO adds a separate 21-byte zero buffer and sets exactly one bit at a time, producing 168 perturbation cases. The complete validator stdout, including every recorded digest, is in COREO-STDOUT.txt.


## COREO output level

COREO records 169 cases: one baseline case plus 168 one-bit cases across a 21-byte buffer. Each case produces a 20-byte SHA-9001 digest. The complete stdout trace is in COREO-STDOUT.txt, and every archive .hash file carries the same COREO mode metadata.
