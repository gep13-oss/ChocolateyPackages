$name = 'wixtoolset'
$32BitUrl = 'https://wix.codeplex.com/downloads/get/582218'
$64BitUrl  = ''

Install-ChocolateyPackage $name 'EXE' '/q' $32BitUrl -validExitCodes @(0)
