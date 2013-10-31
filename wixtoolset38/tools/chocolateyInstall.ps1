$name = 'wixtoolset'
$32BitUrl = 'http://wixtoolset.org/downloads/v3.8.1021.0/wix38.exe'
$64BitUrl  = ''

Install-ChocolateyPackage $name 'EXE' '/q' $32BitUrl -validExitCodes @(0)
