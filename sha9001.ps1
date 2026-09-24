function Get-SHA9001Bytes {
  param([byte[]]$Data)
  $sha=[Security.Cryptography.SHA1]::Create()
  try { $digest=$sha.ComputeHash($Data); for($i=1;$i -le 9000;$i++){ $digest=$sha.ComputeHash($digest) }; return $digest }
  finally { $sha.Dispose() }
}
function Get-SHA9001Hex {
  param([byte[]]$Data)
  -join (Get-SHA9001Bytes $Data | ForEach-Object { '{0:x2}' -f $_ })
}
function ConvertTo-SignedRot {
  param([string]$Value,[int]$Distance,[byte[]]$Key)
  if ($null -eq $Value) { throw 'ROT input is null' }
  if ($Value.Contains([char]0)) { throw 'ROT input contains a NUL character' }
  $enc=[Text.Encoding]::UTF8
  $h=[Security.Cryptography.HMACSHA256]::new($Key)
  $distanceText = $Distance.ToString([Globalization.CultureInfo]::InvariantCulture)
  try { $a=$h.ComputeHash($enc.GetBytes("ROT-STRING`0$Value")); $b=$h.ComputeHash($enc.GetBytes("ROT-INTEGER`0$distanceText")) }
  finally { $h.Dispose() }
  $diff=0
  for($j=0;$j-lt$a.Length;$j++){ $diff=$diff -bor ($a[$j] -bxor $a[$j]) }
  for($j=0;$j-lt$b.Length;$j++){ $diff=$diff -bor ($b[$j] -bxor $b[$j]) }
  if($diff -ne 0){throw 'ROTN rejected signed input'}
  $d=(($Distance%26)+26)%26
  -join ($Value.ToCharArray() | ForEach-Object { $o=[int][char]$_; if($o-ge65-and$o-le90){[char](65+($o-65+$d)%26)}elseif($o-ge97-and$o-le122){[char](97+($o-97+$d)%26)}else{$_} })
}
function Invoke-ROT13 { param([string]$Value,[byte[]]$Key); ConvertTo-SignedRot $Value 13 $Key }
function Invoke-EBG13 { param([string]$Value,[byte[]]$Key); ConvertTo-SignedRot $Value -13 $Key }
