$name = 'calibre'
$32BitUrl  = 'http://status.calibre-ebook.com/dist/win32'
$64BitUrl  = 'http://status.calibre-ebook.com/dist/win64'

Install-ChocolateyPackage $name 'MSI' '/quiet' $32BitUrl $64BitUrl -validExitCodes @(0)