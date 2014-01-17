try {
	Install-ChocoatelyVsixPackage "PowerShell Tools for Visual Studio" "http://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/112013/5/PowerShellTools.vsix"
	Install-ChocolateyVsixPackage "Web Essentials 2013" "http://visualstudiogallery.msdn.microsoft.com/56633663-6799-41d7-9df7-0f2a504ca361/file/105627/27/WebEssentials2013.vsix"

    Write-ChocolateySuccess 'gep13.vs2013extensions'
} catch {
	Write-ChocolateyFailure 'gep13.vs2013extensions' $($_.Exception.Message)
	throw
}
