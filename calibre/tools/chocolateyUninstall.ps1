$package = "Calibre"
$packageWildCard = $package + "*";

try {
	$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like $packageWildCard  -and ($_.Version -eq "1.7.0") }
	$result = $app.Uninstall();
	
	Write-ChocolateySuccess $package
}
catch {
	Write-ChocolateyFailure $package "$($_.Exception.Message)"
	throw
}