try {
	$packageName = 'gep13.aspnetmvc'
	$installerType = 'EXE'
	$32BitUrl  = 'http://go.microsoft.com/fwlink/?LinkID=215693'
	$64BitUrl  = $32BitUrl
	$silentArgs = '/q'
	$validExitCodes = @(0)

	Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$32BitUrl" "$64BitUrl" -validExitCodes $validExitCodes
	
	Write-ChocolateySuccess 'gep13.aspnetmvc'
} catch {
	Write-ChocolateyFailure 'gep13.aspnetmvc' $($_.Exception.Message)
	throw
}