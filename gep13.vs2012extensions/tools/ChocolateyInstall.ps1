try {
	Install-ChocolateyVsixPackage "Gister" "http://visualstudiogallery.msdn.microsoft.com/b31916b0-c026-4c27-9d6b-ba831093f6b2/file/62080/3/Gister.vsix"
	Install-ChocolateyVsixPackage "NuGet Package Manager" "http://visualstudiogallery.msdn.microsoft.com/27077b70-9dad-4c64-adcf-c7cf6bc9970c/file/37502/28/NuGet.Tools.vsix"
	Install-ChocolateyVsixPackage "PowerCommands for Visual Studio 2010" "http://visualstudiogallery.msdn.microsoft.com/e5f41ad9-4edc-4912-bca3-91147db95b99/file/7088/6/PowerCommands.vsix"
	Install-ChocolateyVsixPackage "Web Essentials 2012" "http://visualstudiogallery.msdn.microsoft.com/07d54d12-7133-4e15-becb-6f451ea3bea6/file/79465/39/WebEssentials2012.vsix"
	Install-ChocolateyVsixPackage "Visual Studio 2012 Color Theme Editor" "http://visualstudiogallery.msdn.microsoft.com/366ad100-0003-4c9a-81a8-337d4e7ace05/file/82992/3/ColorThemeEditor.vsix"
	Install-ChocolateyVsixPackage "VSCommands for Visual Studio 2012" "http://visualstudiogallery.msdn.microsoft.com/a83505c6-77b3-44a6-b53b-73d77cba84c8/file/74740/21/SquaredInfinity.VSCommands.VS11.vsix"
	Install-ChocolateyVsixPackage "Spell Checker" "http://visualstudiogallery.msdn.microsoft.com/7c8341f1-ebac-40c8-92c2-476db8d523ce/file/15808/10/SpellChecker.vsix"
	Install-ChocolateyVsixPackage "devColor" "http://visualstudiogallery.msdn.microsoft.com/7dbae8b3-5812-490e-913e-7bfe17f47f1d/file/29587/13/donmar.devColor.vsix"
	Install-ChocolateyVsixPackage "MultiEditing" "http://visualstudiogallery.msdn.microsoft.com/2beb9705-b568-45d1-8550-751e181e3aef/file/93630/4/MultiEdit.vsix"
	Install-ChocolateyVsixPackage "Productivity Power Tools 2012" "http://visualstudiogallery.msdn.microsoft.com/3a96a4dc-ba9c-4589-92c5-640e07332afd/file/88404/2/ProPowerTools.vsix"
	Install-ChocolateyVsixPackage "PowerShell Tools for Visual Studio" "http://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597/file/112013/5/PowerShellTools.vsix"
	Install-ChocolateyVsixPackage "Visual Studio Spell Checker" "http://visualstudiogallery.msdn.microsoft.com/a23de100-31a1-405c-b4b7-d6be40c3dfff/file/104494/2/VSSpellCheckerPackage.vsix"
	Install-ChocolateyVsixPackage "Regionator" "http://visualstudiogallery.msdn.microsoft.com/646f2de1-f421-4aa8-be18-8996abfb40a7/file/128005/4/RegionatorExtension.vsix"
	Install-ChocolateyVsixPackage "Ref12" "http://visualstudiogallery.msdn.microsoft.com/f89b27c5-7d7b-4059-adde-7ccc709fa86e/file/125016/4/Ref12.vsix"
	Install-ChocolateyVsixPackage "StopOnFirstBuildError" "http://visualstudiogallery.msdn.microsoft.com/91aaa139-5d3c-43a7-b39f-369196a84fa5/file/44205/3/StopOnFirstBuildError.vsix"
	Install-ChocolateyVsixPackage "CodeMaid" "http://visualstudiogallery.msdn.microsoft.com/76293c4d-8c16-4f4a-aee6-21f83a571496/file/9356/23/CodeMaid_v0.7.0.vsix"
	Install-ChocolateyVsixPackage "ClipboardDiff" "http://visualstudiogallery.msdn.microsoft.com/a7519ab0-6029-49f3-9243-a74d1718a5bb/file/49749/4/ClipboardDiff.vsix"
	
    Write-ChocolateySuccess 'gep13.vs2012extensions'
} catch {
  Write-ChocolateyFailure 'gep13.vs2012extensions' $($_.Exception.Message)
  throw
}
