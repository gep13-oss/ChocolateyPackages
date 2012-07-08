$name = 'calibre'
$url  = 'http://sourceforge.net/projects/calibre/files/0.8.32/calibre-0.8.32.msi/download?use_mirror=freefr'

Install-ChocolateyPackage $name 'MSI' '/quiet' $url -validExitCodes @(0)