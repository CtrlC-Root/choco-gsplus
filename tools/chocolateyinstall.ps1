$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir

  softwareName  = 'GSplus*'

  url           = 'https://apple2.gs/downloads/plusbuilds/0.14/gsplus-win32.zip'
  checksum      = '7C2669B51FBE76082E59F9CA4172C1D5103097CB67BF3D33E8D419109E5FF54F'
  checksumType  = 'sha256'

  url64bit      = 'https://apple2.gs/downloads/plusbuilds/0.14/gsplus-win-sdl.zip'
  checksum64    = '4C2E8EC843140E766632FEE8F991CAD72EDCE5C876C2CE98B089019D1150AB2E'
  checksumType64= 'sha256'
}

# https://docs.chocolatey.org/en-us/create/functions/install-chocolateyzippackage
Install-ChocolateyZipPackage @packageArgs

## To avoid quoting issues, you can also assemble your -Statements in another variable and pass it in
#$appPath = "$env:ProgramFiles\appname"
##Will resolve to C:\Program Files\appname
#$statementsToRun = "/C `"$appPath\bin\installservice.bat`""
#Start-ChocolateyProcessAsAdmin $statementsToRun cmd -validExitCodes $validExitCodes

## add specific folders to the path - any executables found in the chocolatey package
## folder will already be on the path. This is used in addition to that or for cases
## when a native installer doesn't add things to the path.
## - https://chocolatey.org/docs/helpers-install-chocolatey-path
#Install-ChocolateyPath 'LOCATION_TO_ADD_TO_PATH' 'User_OR_Machine' # Machine will assert administrative rights

## Add specific files as shortcuts to the desktop
## - https://chocolatey.org/docs/helpers-install-chocolatey-shortcut
#$target = Join-Path $toolsDir "$($packageName).exe"
# Install-ChocolateyShortcut -shortcutFilePath "<path>" -targetPath "<path>" [-workDirectory "C:\" -arguments "C:\test.txt" -iconLocation "C:\test.ico" -description "This is the description"]

## Outputs the bitness of the OS (either "32" or "64")
## - https://chocolatey.org/docs/helpers-get-o-s-architecture-width
#$osBitness = Get-ProcessorBits

## Adding a shim when not automatically found - Cocolatey automatically shims exe files found in package directory.
## - https://chocolatey.org/docs/helpers-install-bin-file
## - https://chocolatey.org/docs/create-packages#how-do-i-exclude-executables-from-getting-shims
#Install-BinFile

##PORTABLE EXAMPLE
#$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# despite the name "Install-ChocolateyZipPackage" this also works with 7z archives
#Install-ChocolateyZipPackage $packageName $url $toolsDir $url64
## END PORTABLE EXAMPLE
