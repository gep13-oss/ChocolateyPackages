$name = 'wixtoolset'
$32BitUrl = 'http://download-codeplex.sec.s-msft.com/Download?ProjectName=wix&DownloadId=119157&Build=20393'
$64BitUrl  = ''

Install-ChocolateyPackage $name 'EXE' '/q' $32BitUrl -validExitCodes @(0)
