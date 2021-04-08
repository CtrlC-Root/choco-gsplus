$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# https://chocolatey.org/docs/helpers-get-os-architecture-width
if ((Get-ProcessorBits -Compare "32") -Or $env:ChocolateyForceX86) {
  $specificFolder = "gsplus-win32"
  $binaryFile = "gsplus32.exe"
} else {
  $specificFolder = "gsplus-win-sdl"
  $binaryFile = "gsplus.exe"
}

$packageArgs = @{
  packageName     = $env:ChocolateyPackageName
  unzipLocation   = $toolsDir
  specificFolder  = $specificFolder

  softwareName    = 'GSplus*'

  url             = 'https://apple2.gs/downloads/plusbuilds/0.14/gsplus-win32.zip'
  checksum        = '7C2669B51FBE76082E59F9CA4172C1D5103097CB67BF3D33E8D419109E5FF54F'
  checksumType    = 'sha256'

  url64bit        = 'https://apple2.gs/downloads/plusbuilds/0.14/gsplus-win-sdl.zip'
  checksum64      = '4C2E8EC843140E766632FEE8F991CAD72EDCE5C876C2CE98B089019D1150AB2E'
  checksumType64  = 'sha256'
}

# https://docs.chocolatey.org/en-us/create/functions/install-chocolateyzippackage
Install-ChocolateyZipPackage @packageArgs

# determine path to extracted archive files
$packageDir = (Join-Path -Path $toolsDir -ChildPath $specificFolder)

# create configuration file in user's home directory
$configTemplatePath = (Join-Path -Path $packageDir -ChildPath "config.txt")
$configUserPath = (Join-Path -Path $env:USERPROFILE -ChildPath "config.gsp")

Copy-Item -Path $configTemplatePath -Destination $configUserPath -Force | Out-Null

# create shim for emulator binary
# https://docs.chocolatey.org/en-us/create/create-packages#how-do-i-set-up-shims-for-applications-that-have-a-gui
$binaryPath = (Join-Path -Path $packageDir -ChildPath $binaryFile)

# New-Item "$binaryPath.gui" -Type File -Force | Out-Null
Install-BinFile -Name GSplus -Path $binaryPath -Command "`"-config '$configUserPath'`""

# TODO: create shim ignore files for other binaries (i.e. 32bit build has some)
