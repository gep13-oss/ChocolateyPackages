$packageName = 'fiddler4'
$installerType = 'EXE'
$url = 'http://www.getfiddler.com/dl/Fiddler4BetaSetup.exe'
$url64 = $url
$silentArgs = '/S'
$validExitCodes = @(0,1)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes