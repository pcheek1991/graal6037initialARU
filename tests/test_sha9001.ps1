Set-StrictMode -Version Latest
$root = Split-Path -Parent $PSScriptRoot
$fixture = [Text.Encoding]::UTF8.GetBytes('SHA-9001 validation fixtureEOF')
$sha1 = [Security.Cryptography.SHA1]::Create()
try {
    $digest = $sha1.ComputeHash($fixture)
    for ($i = 1; $i -le 9000; $i++) { $digest = $sha1.ComputeHash($digest) }
}
finally { $sha1.Dispose() }
$hex = -join ($digest | ForEach-Object { '{0:x2}' -f $_ })
if ($hex -ne 'd54be4c08f7b2f0215a20a11f1d2059692ba6851') {
    throw "fixture mismatch: $hex"
}

$source = Get-Content (Join-Path $root 'sha9001.ps1') -Raw
foreach ($marker in @('HMACSHA256', 'ROTN', 'Invoke-ROT13', 'Invoke-EBG13')) {
    if ($source -notmatch [regex]::Escape($marker)) { throw "missing static marker: $marker" }
}
if ($source -match 'Add-Type|Sha9001Embedded') {
    throw 'native PowerShell reference must not load the embedded C# implementation'
}

. (Join-Path $root 'sha9001.ps1')
$key = [Text.Encoding]::UTF8.GetBytes('gold-standard-test-key')
$rotated = Invoke-ROT13 -Value 'Abc xyz!' -Key $key
if ($rotated -ne 'Nop klm!') { throw "ROT13 mismatch: $rotated" }
if ((Invoke-EBG13 -Value $rotated -Key $key) -ne 'Abc xyz!') {
    throw 'EBG13 failed to reverse ROT13'
}
if ((ConvertTo-SignedRot -Value 'Az' -Distance -1 -Key $key) -ne 'Zy') {
    throw 'signed negative distance mismatch'
}
if ((ConvertTo-SignedRot -Value 'Aé!' -Distance 13 -Key $key) -ne 'Né!') {
    throw 'non-ASCII passthrough mismatch'
}
try {
    ConvertTo-SignedRot -Value "a`0b" -Distance 13 -Key $key | Out-Null
    throw 'NUL input was accepted'
}
catch {
    if ($_.Exception.Message -eq 'NUL input was accepted') { throw }
    if ($_.Exception.Message -notmatch 'NUL') { throw }
}
Write-Output 'PASS: SHA fixture, ROT vectors, NUL rejection, static contract, and provider load'
