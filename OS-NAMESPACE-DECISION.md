# OS-namespace constraint decision

The Python port uses `os` to invoke the Windows PowerShell cryptography
provider by deliberate request. That pattern cannot be applied safely to every
language: OS namespaces expose files/processes, not SHA-1 or HMAC; SQLScript
and browser JavaScript have no portable OS process namespace; and shell-outs
would add quoting, encoding, temporary-file, portability, and timing risks.

Each other port therefore retains its language-native cryptographic provider,
with dependencies documented explicitly. The Python path is a Windows-specific
compatibility variant, not a portable “OS-only” rule. This preserves the
SHA-9001 binary contract instead of replacing it with misleading wrappers.
