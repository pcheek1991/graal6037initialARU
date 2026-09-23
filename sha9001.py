import hashlib

def rot13(text: str) -> str:
    return text.translate(str.maketrans("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"))

def sha9001(data: bytes, filename: str = "") -> bytes:
    digest = data
    for iteration in range(1, 9002):
        digest = hashlib.sha1(digest).digest()
    return digest

def runtime_registry(data: bytes, filename: str):
    registry = {}
    digest = data
    for iteration in range(1, 9002):
        digest = hashlib.sha1(digest).digest()
        h = digest.hex()
        registry[f"DIM {filename}"] = h
        registry[f"MID {filename}:{iteration}"] = rot13(h)
    return registry, digest
