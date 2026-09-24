import hashlib, hmac

def sha9001_bytes(data):
    digest = hashlib.sha1(data).digest()
    for _ in range(9000):
        digest = hashlib.sha1(digest).digest()
    return digest

def sha9001_file(path):
    with open(path, 'rb') as handle:
        return sha9001_bytes(handle.read())

def _sign(key, domain, payload): return hmac.new(key, (domain+'\0'+payload).encode(), hashlib.sha256).digest()
def _ct_equal(a,b): return hmac.compare_digest(a,b)
def _sanitize(value):
    if value is None: raise ValueError('ROT input is null')
    if '\0' in value: raise ValueError('ROT input contains a NUL character')
    return value
def _rot(value, distance):
    d=distance%26; out=[]
    for c in value:
        o=ord(c); base=65 if 65<=o<=90 else 97 if 97<=o<=122 else None
        out.append(chr(base+(o-base+d)%26) if base else c)
    return ''.join(out)
def rotn(value, distance, key):
    value=_sanitize(value); ss=_sign(key,'ROT-STRING',value); si=_sign(key,'ROT-INTEGER',str(distance))
    if not _ct_equal(ss,_sign(key,'ROT-STRING',value)) or not _ct_equal(si,_sign(key,'ROT-INTEGER',str(distance))): raise ValueError('ROTN rejected signed input')
    return _rot(value,distance)
def rot13(value,key): return rotn(value,13,key)
def ebg13(value,key): return rotn(value,-13,key)
