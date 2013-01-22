$helperDir = (Get-ChildItem $env:ChocolateyInstall\lib\boxstarter.helpers*)
if($helperDir.Count -gt 1){$helperDir = $helperDir[-1]}
import-module $helperDir\boxstarter.helpers.psm1

try {
    # Disable-UAC

    Set-TaskbarSmall
} 
catch {
    Write-ChocolateyFailure 'gep13.boxstarter' $($_.Exception.Message)
    throw 
}
