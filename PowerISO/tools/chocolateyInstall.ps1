$name = 'poweriso'
$url  = 'http://www.poweriso.net/PowerISO5.exe'

Install-ChocolateyPackage $name 'EXE' '/S' $url -validExitCodes @(0)