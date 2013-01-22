$helperDir = (Get-ChildItem $env:ChocolateyInstall\lib\boxstarter.helpers*)
if($helperDir.Count -gt 1){$helperDir = $helperDir[-1]}
import-module $helperDir\boxstarter.helpers.psm1

try {
	Set-TaskbarSmall
catch {
    Write-ChocolateyFailure 'jivkok.BoxStarter1' $($_.Exception.Message)
    throw 
}