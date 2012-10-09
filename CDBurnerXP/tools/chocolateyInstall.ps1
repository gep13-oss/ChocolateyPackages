$name = 'CDBurnerXP'
$32BitUrl  = 'http://cdburnerxp.se/downloadsetup.exe'
$64BitUrl  = 'http://cdburnerxp.se/downloadsetup.exe?x64'

Install-ChocolateyPackage $name 'EXE' '/quiet' $32BitUrl $64BitUrl -validExitCodes @(0)