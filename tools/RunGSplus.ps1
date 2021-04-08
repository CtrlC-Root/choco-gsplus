$binaryFile = (Get-Command "GSplus.exe" | Select -ExpandProperty Path)
$configFile = (Join-Path -Path $env:USERPROFILE -ChildPath "config.gsp")

Set-Location -Path $env:USERPROFILE
& $binaryFile -config $configFile
