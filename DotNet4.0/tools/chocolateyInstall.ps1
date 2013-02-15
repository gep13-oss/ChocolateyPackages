if(Is64Bit) {
	$fx="framework64"
} 
else {
	$fx="framework"
}

if(!(Test-Path "$env:windir\Microsoft.Net\$fx\v4.0.30319")) {
    $env:chocolateyPackageFolder="$env:temp\chocolatey\webcmd"
    Install-ChocolateyZipPackage 'webcmd' 'http://www.iis.net/community/files/webpi/webpicmdline_anycpu.zip' $env:temp
    .$env:temp\WebpiCmdLine.exe /products: NetFramework4 /accepteula
}
else {
     Write-Host "Microsoft .Net 4.0 Framework is already installed on your machine."
} 