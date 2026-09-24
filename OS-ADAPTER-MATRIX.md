# OS-backed adapter matrix

The requested “native OS namespace only” mode is exposed as an adapter policy,
not silently substituted for the portable implementations.

| Language | OS-backed path | Status |
|---|---|---|
| Python | `os` invokes Windows PowerShell SHA-1 | Implemented |
| PowerShell | .NET `System.Security.Cryptography` | Implemented |
| POSIX shell / Awk | `sha1sum` and `xxd` | Implemented |
| JavaScript / TypeScript | Node `child_process` + PowerShell | Possible, not enabled by default |
| Go | `os/exec` + host provider | Possible, not enabled by default |
| Perl / PHP / Ruby / Raku / Tcl / Julia | subprocess APIs + host provider | Possible, not enabled by default |
| R | `system2` + host provider | Possible, not enabled by default |
| Rust | `std::process::Command` + host provider | Possible, not enabled by default |
| SQLScript | no portable process namespace | Native database provider required |
| Lua | host-dependent process API | Provider-dependent |

The default files remain the auditable native-provider implementations. An
adapter must pass raw bytes through a binary-safe channel, use an argument
vector or a securely created temporary file, validate exactly one digest of the
expected width, propagate non-zero exit status, and never interpolate
untrusted input into a shell command. The Python implementation is the only
OS-backed variant enabled in this archive because it has been exercised on the
current Windows host.
