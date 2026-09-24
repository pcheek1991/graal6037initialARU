# OS-backed adapter matrix

“OS namespace only” is represented as an explicit adapter policy rather than
silently replacing each language’s correct implementation.

| Language | OS-backed path | Status |
|---|---|---|
| Python | `os` invokes Windows PowerShell SHA-1/HMAC | Implemented |
| PowerShell | .NET cryptography provider | Implemented |
| POSIX shell / Awk | `sha1sum` and `xxd` | Implemented |
| JavaScript / TypeScript / Go / Perl / PHP / Ruby / Raku / Tcl / Julia / R / Rust | Host subprocess API + provider | Possible, not enabled by default |
| SQLScript | No portable process namespace | Native database provider required |
| Lua | Host-dependent process API | Provider-dependent |

Adapters must preserve binary bytes, validate one digest of the expected width,
propagate failures, and avoid interpolating untrusted input into shell
commands. Only the Python OS-backed variant is enabled here because it has
been exercised on the current Windows host.
