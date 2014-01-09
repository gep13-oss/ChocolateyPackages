try {
	Install-ChocoatelyVsixPackage "PowerShell Tools for Visual Studio" "http://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/112013/5/PowerShellTools.vsix"

    Write-ChocolateySuccess 'gep13.vs2013extensions'
} catch {
	Write-ChocolateyFailure 'gep13.vs2013extensions' $($_.Exception.Message)
	throw
}