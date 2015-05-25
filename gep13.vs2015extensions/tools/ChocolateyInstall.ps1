try {
	Install-ChocolateyVsixPackage "Web Essentials 2015.0 RC" "https://visualstudiogallery.msdn.microsoft.com/ee6e6d8c-c837-41fb-886a-6b50ae2d06a2/file/146119/17/Web%20Essentials%202015.0%20RC%20v0.4.107.vsix"
	Install-ChocolateyVsixPackage "StopOnFirstBuildError" "https://visualstudiogallery.msdn.microsoft.com/91aaa139-5d3c-43a7-b39f-369196a84fa5/file/44205/7/StopOnFirstBuildError.vsix"
	Install-ChocolateyVsixPackage "SideWaffle Template Pack" "http://visualstudiogallery.msdn.microsoft.com/a16c2d07-b2e1-4a25-87d9-194f04e7a698/referral/110630"
	Install-ChocolateyVsixPackage "Ref12" "https://visualstudiogallery.msdn.microsoft.com/f89b27c5-7d7b-4059-adde-7ccc709fa86e/file/125016/11/Ref12.vsix"
	Install-ChocolateyVsixPackage "VSColorOutput" "https://visualstudiogallery.msdn.microsoft.com/f4d9c2b5-d6d7-4543-a7a5-2d7ebabc2496/file/63103/9/VSColorOutput.vsix"
	Install-ChocolateyVsixPackage "Add New File" "https://visualstudiogallery.msdn.microsoft.com/3f820e99-6c0d-41db-aa74-a18d9623b1f3/file/140782/17/Add%20New%20File%20v2.1.39.vsix"
	Install-ChocolateyVsixPackage "NuGet Reference Switcher" "https://visualstudiogallery.msdn.microsoft.com/e2458c0b-03c0-47a9-a94b-0d28567e0a84/file/159417/1/NuGetReferenceSwitcher.vsix"
	Install-ChocolateyVsixPackage "Image Optimizer" "https://visualstudiogallery.msdn.microsoft.com/a56eddd3-d79b-48ac-8c8f-2db06ade77c3/file/38601/23/Image%20Optimizer%20v3.0.25.vsix"
	Install-ChocolateyVsixPackage "AutoHistory " "https://visualstudiogallery.msdn.microsoft.com/dfcb2438-180c-4f8a-983b-62d89e141fe3/file/122993/3/Microsoft.VisualStudio.AutoHistory.vsix"
	Install-ChocolateyVsixPackage "File Nesting" "https://visualstudiogallery.msdn.microsoft.com/3ebde8fb-26d8-4374-a0eb-1e4e2665070c/file/123284/15/File%20Nesting%20v2.1.20.vsix"
	Install-ChocolateyVsixPackage "Error Catcher" "https://visualstudiogallery.msdn.microsoft.com/a85f155f-b519-44a8-b56b-07611cf78393/file/136589/13/Error%20Catcher%20v1.6.28.vsix"
	Install-ChocolateyVsixPackage "CssCop - FxCop for Stylesheets" "https://visualstudiogallery.msdn.microsoft.com/a921b98e-9430-4be2-bf53-1169e12bdb50/file/62099/7/CssLint.vsix"
	Install-ChocolateyVsixPackage "Open From Azure Websites" "https://visualstudiogallery.msdn.microsoft.com/60d414b1-4ead-4fde-9359-588aa126cd6c/file/151097/4/Open%20From%20Azure%20Websites%20v1.2.37.vsix"
	Install-ChocolateyVsixPackage "Trailing Whitespace Visualizer" "https://visualstudiogallery.msdn.microsoft.com/a204e29b-1778-4dae-affd-209bea658a59/file/135653/17/Trailing%20Whitespace%20Visualizer%20v2.0.51.vsix"
	Install-ChocolateyVsixPackage "Open Command Line" "https://visualstudiogallery.msdn.microsoft.com/4e84e2cf-2d6b-472a-b1e2-b84932511379/file/151803/12/Open%20Command%20Line%20v1.7.121.vsix"
	Install-ChocolateyVsixPackage "Flatten Packages" "https://visualstudiogallery.msdn.microsoft.com/cd0b1938-4513-4e57-b9b7-c674b4a20e79/file/157954/7/Flatten%20Packages%20v1.0.8.vsix"
	Install-ChocolateyVsixPackage "Developer Assistant" "https://visualstudiogallery.msdn.microsoft.com/5d01e3bd-6433-47f2-9c6d-a9da52d172cc/file/150980/4/DeveloperAssistant_2015.vsix"		
	Install-ChocolateyVsixPackage "EditorConfig" "https://visualstudiogallery.msdn.microsoft.com/c8bccfe2-650c-4b42-bc5c-845e21f96328/file/75539/12/EditorConfigPlugin.vsix"
	
	Write-ChocolateySuccess 'gep13.vs2015extensions'
} catch {
	Write-ChocolateyFailure 'gep13.vs2015extensions' $($_.Exception.Message)
	throw
}
