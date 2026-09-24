Set-StrictMode -Version Latest
$root = Split-Path -Parent $PSScriptRoot
$fixture = [Text.Encoding]::UTF8.GetBytes('SHA-9001 validation fixtureEOF')
$source = Get-Content (Join-Path $root 'sha9001-csharp.ps1') -Raw
if ($source -notmatch 'Add-Type' -or $source -notmatch 'class CSharp') {
    throw 'embedded C# implementation or separate Add-Type project is missing'
}
. (Join-Path $root 'sha9001-csharp.ps1')

if ((Get-SHA9001CSharpHex $fixture) -ne 'd54be4c08f7b2f0215a20a11f1d2059692ba6851') {
    throw 'embedded C# fixture mismatch'
}

$key = [Text.Encoding]::UTF8.GetBytes('gold-standard-test-key')
$rotated = Invoke-ROT13CSharp -Value 'Abc xyz!' -Key $key
if ($rotated -ne 'Nop klm!') { throw "ROT13 mismatch: $rotated" }
if ((Invoke-EBG13CSharp -Value $rotated -Key $key) -ne 'Abc xyz!') {
    throw 'EBG13 failed to reverse ROT13'
}
if ((ConvertTo-SignedRotCSharp -Value 'Az' -Distance -1 -Key $key) -ne 'Zy') {
    throw 'signed negative distance mismatch'
}
if ((ConvertTo-SignedRotCSharp -Value 'Aé!' -Distance 13 -Key $key) -ne 'Né!') {
    throw 'non-ASCII passthrough mismatch'
}
try {
    ConvertTo-SignedRotCSharp -Value "a`0b" -Distance 13 -Key $key | Out-Null
    throw 'NUL input was accepted'
}
catch {
    if ($_.Exception.Message -eq 'NUL input was accepted') { throw }
    if ($_.Exception.Message -notmatch 'NUL') { throw }
}
Write-Output 'PASS: embedded C# SHA fixture and ROT contract'
