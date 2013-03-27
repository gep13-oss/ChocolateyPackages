#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName = 'fiddler4' # arbitrary name for the package, used in messages
$installerType = 'EXE' #only one of these two: exe or msi
$url = 'http://www.getfiddler.com/dl/Fiddler4BetaSetup.exe' # download url
$url64 = $url # 64bit URL here or just use the same as $url
$silentArgs = '/S' # "/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer #msi is always /quiet
$validExitCodes = @(0,1) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes