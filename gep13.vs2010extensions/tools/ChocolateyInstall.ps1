try {
	Install-ChocolateyVsixPackage "NuGet Package Manager" "http://visualstudiogallery.msdn.microsoft.com/27077b70-9dad-4c64-adcf-c7cf6bc9970c/file/37502/35/NuGet.Tools.vsix"
	Install-ChocolateyVsixPackage "PowerCommands for Visual Studio 2010" "http://visualstudiogallery.msdn.microsoft.com/e5f41ad9-4edc-4912-bca3-91147db95b99/file/7088/6/PowerCommands.vsix"
	Install-ChocolateyVsixPackage "Visual Studio Spell Checker" "http://visualstudiogallery.msdn.microsoft.com/a23de100-31a1-405c-b4b7-d6be40c3dfff/file/104494/2/VSSpellCheckerPackage.vsix"
	Install-ChocolateyVsixPackage "Web Essentials" "http://visualstudiogallery.msdn.microsoft.com/6ed4c78f-a23e-49ad-b5fd-369af0c2107f/file/50769/32/WebEssentials.vsix"
	
    Write-ChocolateySuccess 'gep13.vs2010extensions'
} catch {
	Write-ChocolateyFailure 'gep13.vs2010extensions' $($_.Exception.Message)
	throw
}
