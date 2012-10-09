$name = 'poweriso'
$url  = 'http://www.poweriso.net/PowerISO5.exe'

Install-ChocolateyPackage $name 'MSI' '/quiet' $url -validExitCodes @(0)