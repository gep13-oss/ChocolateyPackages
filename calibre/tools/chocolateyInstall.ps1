$name = 'calibre'
$url  = 'http://status.calibre-ebook.com/dist/win32'

Install-ChocolateyPackage $name 'MSI' '/quiet' $url -validExitCodes @(0)