try {
	Install-ChocolateyVsixPackage "PowerShell Tools for Visual Studio" "http://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/112013/5/PowerShellTools.vsix"
	Install-ChocolateyVsixPackage "Web Essentials 2013" "http://visualstudiogallery.msdn.microsoft.com/56633663-6799-41d7-9df7-0f2a504ca361/file/105627/27/WebEssentials2013.vsix"
	Install-ChocolateyVsixPackage "Visual Studio Spell Checker" "http://visualstudiogallery.msdn.microsoft.com/a23de100-31a1-405c-b4b7-d6be40c3dfff/file/104494/2/VSSpellCheckerPackage.vsix"
	Install-ChocolateyVsixPackage "Productivity Power Tools 2013" "http://visualstudiogallery.msdn.microsoft.com/dbcb8670-889e-4a54-a226-a48a15e4cace/file/117115/3/ProPowerTools.vsix"
	Install-ChocolateyVsixPackage "StopOnFirstBuildError" "http://visualstudiogallery.msdn.microsoft.com/91aaa139-5d3c-43a7-b39f-369196a84fa5/file/44205/3/StopOnFirstBuildError.vsix"
	Install-ChocolateyVsixPackage "SideWaffle Template Pack" "http://visualstudiogallery.msdn.microsoft.com/a16c2d07-b2e1-4a25-87d9-194f04e7a698/referral/110630"
	Install-ChocolateyVsixPackage "Ref12" "http://visualstudiogallery.msdn.microsoft.com/f89b27c5-7d7b-4059-adde-7ccc709fa86e/file/125016/4/Ref12.vsix"
	Install-ChocolateyVsixPackage "CodeMaid" "http://visualstudiogallery.msdn.microsoft.com/76293c4d-8c16-4f4a-aee6-21f83a571496/file/9356/23/CodeMaid_v0.7.0.vsix"
	Install-ChocolateyVsixPackage "ClipboardDiff" "http://visualstudiogallery.msdn.microsoft.com/a7519ab0-6029-49f3-9243-a74d1718a5bb/file/49749/4/ClipboardDiff.vsix"
	
	Write-ChocolateySuccess 'gep13.vs2013extensions'
} catch {
	Write-ChocolateyFailure 'gep13.vs2013extensions' $($_.Exception.Message)
	throw
}
