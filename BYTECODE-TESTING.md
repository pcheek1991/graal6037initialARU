# Cross-language bytecode and critical-path testing

Bytecode is language-runtime-specific. Python bytecode, PowerShell IL, Tcl
bytecode, JVM/CLR artifacts, native object code, and SAP HANA SQLScript
execution plans cannot be expected to be byte-for-byte identical across
languages. The valid comparison boundary is:

1. private and public source bytes are identical for each same-language pair;
2. each available toolchain produces the expected SHA-9001 fixture digest;
3. compiled artifacts are compared only within the same language, compiler,
   flags, target, and reproducible-build settings.

`tests/critical_cross_language.py` performs the first check for all maintained
ports, executes the Python critical path when Python is available, and records
explicit `SKIP` results for unavailable or adapterless runtimes. It never
labels an unavailable language as passing.
