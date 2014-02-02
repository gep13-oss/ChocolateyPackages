try {
	cinst IIS-WebServerRole -source windowsfeatures
	cinst IIS-HttpCompressionDynamic -source windowsfeatures
	cinst TelnetClient -source windowsFeatures
	
	cinst GoogleChrome
	cinst Firefox
	cinst dotPeek
	cinst filezilla
	cinst notepadplusplus
	cinst fiddler4
	cinst git-credential-winstore
	cinst git
	cinst poshgit
	cinst gitextensions 
	cinst NugetPackageExplorer
	cinst githubforwindows 
	cinst PowerGUI
	cinst powershell
	cinst kdiff3
	cinst markdownpad2
	cinst 7zip
	cinst 7zip.CommandLine
	cinst pester
	cinst psake -source http://packages.nuget.org/v1/FeedService.svc/
	
	cinst NetFx3 -source windowsfeatures
	
	cinst VisualStudio2013Premium -InstallArguments "Blend WebTools Win8SDK SilverLight_Developer_Kit WindowsPhone80"
	cinst VS2013.1 
	
	cinst gep13.DefaultConfig -source https://www.myget.org/F/gep13
	cinst gep13.gitConfig -source https://www.myget.org/F/gep13
	cinst gep13.vs2013extensions -source https://www.myget.org/F/gep13
	
	# fix the "WARNING: Could not find ssh-agent" in PowerShell console as per here:
	# http://stackoverflow.com/questions/7470385/git-in-powershell-saying-could-not-find-ssh-agent
	$currentPathVariable = [environment]::GetEnvironmentVariable("PATH", "Machine")
	[System.Environment]::SetEnvironmentVariable("PATH", $currentPathVariable + ";C:\Program Files (x86)\Git\bin", "Machine")
	
	if(!(Test-Path "c:\codeplex")) {
		New-Item -Type Directory "C:\codeplex"
	}
	
	cd "C:\codeplex"
	
	if(!(Test-Path "c:\codeplex\boxstarter")){
		git clone https://git01.codeplex.com/forks/gep13/boxstarter
	}
	
	Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Notepad++\notepad++.exe"
	Install-ChocolateyPinnedTaskBarItem "C:\Program Files\Internet Explorer\iexplore.exe"
	Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"
	
	cinst gep13.WindowsUpdate -source https://www.myget.org/F/gep13
	
	Update-Help	
	
	Write-ChocolateySuccess 'gep13.BoxstarterDev'
} catch {
	Write-ChocolateyFailure 'gep13.BoxstarterDev' $($_.Exception.Message)
	throw
}
