try {
	Install-ChocolateyVsixPackage "NuGet Package Manager" "http://visualstudiogallery.msdn.microsoft.com/27077b70-9dad-4c64-adcf-c7cf6bc9970c/file/37502/35/NuGet.Tools.vsix"
	Install-ChocolateyVsixPackage "PowerCommands for Visual Studio 2010" "http://visualstudiogallery.msdn.microsoft.com/e5f41ad9-4edc-4912-bca3-91147db95b99/file/7088/6/PowerCommands.vsix"
	Install-ChocolateyVsixPackage "Visual Studio Spell Checker" "http://visualstudiogallery.msdn.microsoft.com/a23de100-31a1-405c-b4b7-d6be40c3dfff/file/104494/2/VSSpellCheckerPackage.vsix"
	Install-ChocolateyVsixPackage "Web Essentials" "http://visualstudiogallery.msdn.microsoft.com/6ed4c78f-a23e-49ad-b5fd-369af0c2107f/file/50769/32/WebEssentials.vsix"
	Install-ChocolateyVsixPackage "Productivity Power Tools" "http://visualstudiogallery.msdn.microsoft.com/d0d33361-18e2-46c0-8ff2-4adea1e34fef/file/29666/12/ProPowerTools.vsix"
	Install-ChocolateyVsixPackage "StopOnFirstBuildError" "http://visualstudiogallery.msdn.microsoft.com/91aaa139-5d3c-43a7-b39f-369196a84fa5/file/44205/3/StopOnFirstBuildError.vsix"
	
	Write-ChocolateySuccess 'gep13.vs2010extensions'
} catch {
	Write-ChocolateyFailure 'gep13.vs2010extensions' $($_.Exception.Message)
	throw
}
