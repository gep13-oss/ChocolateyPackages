$name = 'poweriso'
$url  = 'http://www.poweriso.net/PowerISO5.exe'

Install-ChocolateyPackage $name 'EXE' '/verysilent' $url -validExitCodes @(0)