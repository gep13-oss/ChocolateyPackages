try {
	Enable-MicrosoftUpdate
    Install-WindowsUpdate
	
	Write-ChocolateySuccess 'gep13.WindowsUpdate'
} catch {
	Write-ChocolateyFailure 'gep13.WindowsUpdate' $($_.Exception.Message)
	throw
}