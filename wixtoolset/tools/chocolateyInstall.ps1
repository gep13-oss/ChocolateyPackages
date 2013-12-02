$name = 'wixtoolset'
$32BitUrl = 'https://wix.codeplex.com/downloads/get/762937'
$64BitUrl  = ''

Install-ChocolateyPackage $name 'EXE' '/q' $32BitUrl -validExitCodes @(0)
