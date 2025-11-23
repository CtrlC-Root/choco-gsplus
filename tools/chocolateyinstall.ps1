$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# determine archive folder name and emulator binary file based on platform
# https://chocolatey.org/docs/helpers-get-os-architecture-width
if ((Get-ProcessorBits -Compare "32") -Or $env:ChocolateyForceX86) {
  $specificFolder = "gsplus-win32"
  $binaryFile = "gsplus32.exe"
} else {
  $specificFolder = "gsplus-win-sdl"
  $binaryFile = "gsplus.exe"
}

# download and install zip package
# https://docs.chocolatey.org/en-us/create/functions/install-chocolateyzippackage
$packageArgs = @{
  packageName     = $env:ChocolateyPackageName
  unzipLocation   = $toolsDir
  specificFolder  = $specificFolder

  softwareName    = 'GSplus*'

  url             = 'https://github.com/digarok/gsplus/releases/download/v0.14/gsplus-win32.zip'
  checksum        = '7C2669B51FBE76082E59F9CA4172C1D5103097CB67BF3D33E8D419109E5FF54F'
  checksumType    = 'sha256'

  url64bit        = 'https://github.com/digarok/gsplus/releases/download/v0.14/gsplus-win-sdl.zip'
  checksum64      = '4C2E8EC843140E766632FEE8F991CAD72EDCE5C876C2CE98B089019D1150AB2E'
  checksumType64  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

# determine path to extracted archive files
$packageDir = (Join-Path -Path $toolsDir -ChildPath $specificFolder)

# create configuration file in user's home directory if it doesn't already exist
$configTemplatePath = (Join-Path -Path $packageDir -ChildPath "config.txt")
$configUserPath = (Join-Path -Path $env:USERPROFILE -ChildPath "config.gsp")

if (-Not (Test-Path -Path $configUserPath -PathType Leaf)) {
  Copy-Item -Path $configTemplatePath -Destination $configUserPath -Force | Out-Null
}

# explicitly create shim for emulator binary to use same binary name on all platforms
# XXX: switch to using Install-BinFile -Command flag at some point
# https://github.com/chocolatey/choco/issues/1273#issuecomment-815443431
# https://github.com/chocolatey/shimgen/issues/16#issuecomment-815441450
$binaryPath = (Join-Path -Path $packageDir -ChildPath $binaryFile)
Install-BinFile -Name GSplus -Path $binaryPath

# create shim ignore files for other binaries
# https://docs.chocolatey.org/en-us/create/create-packages#how-do-i-exclude-executables-from-getting-shims
$binaries = (Get-ChildItem -Path $packageDir -Include '*.exe' -Exclude $binaryFile -Recurse)
foreach ($binary in $binaries) {
  New-Item -Path "$binary.ignore" -Type File -Force | Out-Null
}

# create shim for wrapper script
# https://docs.chocolatey.org/en-us/create/functions/install-chocolateypowershellcommand
$wrapperScript = (Join-Path -Path $toolsDir -ChildPath "RunGSplus.ps1")
Install-ChocolateyPowershellCommand -PackageName "gsplus" -PSFileFullPath $wrapperScript
