$name = 'calibre'
$32BitUrl  = 'http://sourceforge.net/projects/calibre/files/0.9.35/calibre-0.9.35.msi/download'
$64BitUrl  = 'http://sourceforge.net/projects/calibre/files/0.9.35/calibre-64bit-0.9.35.msi/download'

Install-ChocolateyPackage $name 'MSI' '/quiet' $32BitUrl $64BitUrl -validExitCodes @(0)