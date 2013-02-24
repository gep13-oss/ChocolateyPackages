$name = 'wixtoolset'
$32BitUrl  = 'http://wix.codeplex.com/downloads/get/582218'
$64BitUrl  = ''

Install-ChocolateyPackage $name 'EXE' '/verysilent' $32BitUrl -validExitCodes @(0)