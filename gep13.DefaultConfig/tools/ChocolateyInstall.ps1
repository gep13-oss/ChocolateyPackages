try {
	Update-ExecutionPolicy Unrestricted
	Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions
	Set-TaskbarSmall
	Disable-InternetExplorerESC
	Disable-UAC
	
    Write-ChocolateySuccess 'gep13.DefaultConfig'
} catch {
	Write-ChocolateyFailure 'gep13.DefaultConfig' $($_.Exception.Message)
	throw
}