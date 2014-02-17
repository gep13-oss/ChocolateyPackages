try {
	Install-ChocoatelyVsixPackage "PowerShell Tools for Visual Studio" "http://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/112013/5/PowerShellTools.vsix"
	Install-ChocolateyVsixPackage "Web Essentials 2013" "http://visualstudiogallery.msdn.microsoft.com/56633663-6799-41d7-9df7-0f2a504ca361/file/105627/27/WebEssentials2013.vsix"
	Install-ChocoatelyVsixPackage "Visual Studio Spell Checker" "http://visualstudiogallery.msdn.microsoft.com/a23de100-31a1-405c-b4b7-d6be40c3dfff/file/104494/2/VSSpellCheckerPackage.vsix"
	Install-ChocoatelyVsixPackage "Productivity Power Tools 2013" "http://visualstudiogallery.msdn.microsoft.com/dbcb8670-889e-4a54-a226-a48a15e4cace/file/117115/3/ProPowerTools.vsix"


	Write-ChocolateySuccess 'gep13.vs2013extensions'
} catch {
	Write-ChocolateyFailure 'gep13.vs2013extensions' $($_.Exception.Message)
	throw
}
