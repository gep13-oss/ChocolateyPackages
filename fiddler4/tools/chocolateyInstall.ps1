$packageName = 'fiddler4'
$installerType = 'EXE'
$url = 'http://fiddler2.com/docs/default-source/default-document-library/fiddler4setup.exe?sfvrsn=4'
$url64 = $url
$silentArgs = '/S'
$validExitCodes = @(0,1)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes