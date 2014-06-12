try {
	Update-ExecutionPolicy Unrestricted
	Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
	Set-TaskbarOptions -Size Small -Lock blah -Dock Left
	Disable-InternetExplorerESC
	Disable-UAC
	Enable-RemoteDesktop
	Enable-MicrosoftUpdate
	
    Write-ChocolateySuccess 'gep13.DefaultConfig'
} catch {
	Write-ChocolateyFailure 'gep13.DefaultConfig' $($_.Exception.Message)
	throw
}
