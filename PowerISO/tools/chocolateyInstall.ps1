$packageName = 'poweriso'
$installerType = 'EXE'
$url  = 'http://192.155.93.226/PowerISO5.exe'
$url64 = 'http://192.155.93.226/PowerISO5-x64.exe'
$silentArgs = '/S'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes