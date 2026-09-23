function Get-SHA9001 { param([Parameter(Mandatory)][byte[]]$Data); $digest=$Data; for($i=0;$i-lt9001;$i++){ $h=[Security.Cryptography.SHA1]::Create(); try{$digest=$h.ComputeHash($digest)}finally{$h.Dispose()} }; return $digest }
function Get-SHA9001Hex { param([Parameter(Mandatory)][byte[]]$Data); -join (Get-SHA9001 $Data | ForEach-Object {$_.ToString('x2')}) }
