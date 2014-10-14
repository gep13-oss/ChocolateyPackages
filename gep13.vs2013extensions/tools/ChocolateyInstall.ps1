try {
	Install-ChocolateyVsixPackage "PowerShell Tools for Visual Studio" "http://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/112013/5/PowerShellTools.vsix"
	Install-ChocolateyVsixPackage "Web Essentials 2013" "http://visualstudiogallery.msdn.microsoft.com/56633663-6799-41d7-9df7-0f2a504ca361/file/105627/36/WebEssentials2013.vsix"
	Install-ChocolateyVsixPackage "Visual Studio Spell Checker" "http://visualstudiogallery.msdn.microsoft.com/a23de100-31a1-405c-b4b7-d6be40c3dfff/file/104494/2/VSSpellCheckerPackage.vsix"
	Install-ChocolateyVsixPackage "Productivity Power Tools 2013" "http://visualstudiogallery.msdn.microsoft.com/dbcb8670-889e-4a54-a226-a48a15e4cace/file/117115/3/ProPowerTools.vsix"
	Install-ChocolateyVsixPackage "StopOnFirstBuildError" "http://visualstudiogallery.msdn.microsoft.com/91aaa139-5d3c-43a7-b39f-369196a84fa5/file/44205/3/StopOnFirstBuildError.vsix"
	Install-ChocolateyVsixPackage "SideWaffle Template Pack" "http://visualstudiogallery.msdn.microsoft.com/a16c2d07-b2e1-4a25-87d9-194f04e7a698/referral/110630"
	Install-ChocolateyVsixPackage "Ref12" "http://visualstudiogallery.msdn.microsoft.com/f89b27c5-7d7b-4059-adde-7ccc709fa86e/file/125016/4/Ref12.vsix"
	Install-ChocolateyVsixPackage "CodeMaid" "http://visualstudiogallery.msdn.microsoft.com/76293c4d-8c16-4f4a-aee6-21f83a571496/file/9356/23/CodeMaid_v0.7.0.vsix"
	Install-ChocolateyVsixPackage "ClipboardDiff" "http://visualstudiogallery.msdn.microsoft.com/a7519ab0-6029-49f3-9243-a74d1718a5bb/file/49749/4/ClipboardDiff.vsix"
	Install-ChocolateyVsixPackage "VSColorOutput" "http://visualstudiogallery.msdn.microsoft.com/f4d9c2b5-d6d7-4543-a7a5-2d7ebabc2496/file/63103/7/VSColorOutput.vsix"
	Install-ChocolateyVsixPackage "Add Empty File" "https://visualstudiogallery.msdn.microsoft.com/3f820e99-6c0d-41db-aa74-a18d9623b1f3/file/140782/6/AddAnyFile.vsix"
	Install-ChocolateyVsixPackage "NuGet Reference Switcher" "https://visualstudiogallery.msdn.microsoft.com/68878c27-110c-43ec-ae61-3ea3f7aae88c/file/140063/7/NuGetReferenceSwitcher.vsix"
	Install-ChocolateyVsixPackage "Pretty Paste" "https://visualstudiogallery.msdn.microsoft.com/6a23234d-45f6-4212-bac3-f6d9bb08fb1e/file/97937/12/PrettyPaste.vsix"
	Install-ChocolateyVsixPackage "Image Optimizer" "https://visualstudiogallery.msdn.microsoft.com/a56eddd3-d79b-48ac-8c8f-2db06ade77c3/file/38601/14/ImageOptimizer.vsix"
	Install-ChocolateyVsixPackage "AutoHistory " "https://visualstudiogallery.msdn.microsoft.com/dfcb2438-180c-4f8a-983b-62d89e141fe3/file/122993/3/Microsoft.VisualStudio.AutoHistory.vsix"
	Install-ChocolateyVsixPackage "File Nesting" "https://visualstudiogallery.msdn.microsoft.com/3ebde8fb-26d8-4374-a0eb-1e4e2665070c/file/123284/11/FileNesting.vsix"
	Install-ChocolateyVsixPackage "Error Watcher" "https://visualstudiogallery.msdn.microsoft.com/a85f155f-b519-44a8-b56b-07611cf78393/file/136589/6/ErrorHighlighter.vsix"
	Install-ChocolateyVsixPackage "SlowCheetah - XML Transforms" "https://visualstudiogallery.msdn.microsoft.com/69023d00-a4f9-4a34-a6cd-7e854ba318b5/file/55948/26/SlowCheetah.vsix"
	
	Write-ChocolateySuccess 'gep13.vs2013extensions'
} catch {
	Write-ChocolateyFailure 'gep13.vs2013extensions' $($_.Exception.Message)
	throw
}
