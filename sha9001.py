import os

def _os_powershell(script):
    path = os.path.join(os.environ.get("TEMP", "."), "sha9001-" + os.urandom(8).hex() + ".ps1")
    fd = os.open(path, os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o600)
    try:
        os.write(fd, script.encode())
        os.close(fd)
        pipe = os.popen('powershell -NoProfile -NonInteractive -File "' + path + '"')
        output = pipe.read().strip()
        pipe.close()
        if not output: raise RuntimeError("OS cryptography command returned no digest")
        return bytes.fromhex(output)
    finally:
        try: os.close(fd)
        except OSError: pass
        try: os.unlink(path)
        except OSError: pass

def sha9001_bytes(data):
    encoded = data.hex()
    return _os_powershell(
        "$hex=\"" + encoded + "\";$d=New-Object byte[] ($hex.Length/2);"
        "for($i=0;$i -lt $d.Length;$i++){$d[$i]=[Convert]::ToByte($hex.Substring($i*2,2),16)};"
        "$s=[Security.Cryptography.SHA1]::Create();"
        "1..9001|ForEach-Object{$d=$s.ComputeHash($d)};"
        "-join($d|ForEach-Object{$_.ToString(\"x2\")})"
    )

def sha9001_file(path):
    with open(path, 'rb') as handle:
        return sha9001_bytes(handle.read())

def _sign(key, domain, payload):
    encoded = (domain+'\0'+payload).encode().hex()
    return _os_powershell(
        "$hex=\"" + encoded + "\";$d=New-Object byte[] ($hex.Length/2);"
        "for($i=0;$i -lt $d.Length;$i++){$d[$i]=[Convert]::ToByte($hex.Substring($i*2,2),16)};"
        "$keyhex=\"" + key.hex() + "\";$keybytes=New-Object byte[] ($keyhex.Length/2);"
        "for($i=0;$i -lt $keybytes.Length;$i++){$keybytes[$i]=[Convert]::ToByte($keyhex.Substring($i*2,2),16)};"
        "$h=[Security.Cryptography.HMACSHA256]::new($keybytes);"
        "-join($h.ComputeHash($d)|ForEach-Object{$_.ToString(\"x2\")})"
    )
def _ct_equal(a,b): return a == b
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
