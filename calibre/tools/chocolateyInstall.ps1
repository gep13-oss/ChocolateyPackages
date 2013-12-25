$name = 'calibre'
$32BitUrl  = 'http://sourceforge.net/projects/calibre/files/1.17.0/calibre-1.17.0.msi/download'
$64BitUrl  = 'http://sourceforge.net/projects/calibre/files/1.17.0/calibre-64bit-1.17.0.msi/download'

Install-ChocolateyPackage $name 'MSI' '/quiet' $32BitUrl $64BitUrl -validExitCodes @(0)