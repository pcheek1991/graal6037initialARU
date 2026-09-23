#!/usr/bin/env python3
"""SHA-9001: iterative SHA-1 digest construction."""
import hashlib

def sha9001(data: bytes) -> bytes:
    """Apply SHA-1 exactly 9,001 times; return the final 160-bit digest."""
    digest = data
    for _ in range(9001):
        digest = hashlib.sha1(digest).digest()
    return digest

if __name__ == "__main__":
    import sys
    for name in sys.argv[1:]:
        with open(name, "rb") as stream:
            print(f"{sha9001(stream.read()).hex()}  {name}")
