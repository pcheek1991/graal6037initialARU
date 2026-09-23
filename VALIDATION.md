# SHA-9001 cross-language validation

Fixture: UTF-8 bytes of `SHA-9001 validation fixture` followed by LF.

Expected SHA-9001 digest: `5f6395d17f719fb78d60b2e69b25b28ad5787dfe` (SHA-1 applied 9,001 times).

Each implementation must process the exact fixture bytes and compare lowercase hexadecimal output to this value. A mismatch is a validation failure; unavailable runtimes are reported as unavailable, not treated as algorithm differences.

