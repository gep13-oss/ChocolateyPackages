choco install IIS-WebServerRole -source windowsfeatures
choco install IIS-HttpCompressionDynamic -source windowsfeatures
choco install TelnetClient -source windowsFeatures

choco install GoogleChrome
choco install Firefox
choco install dotPeek
choco install filezilla
choco install notepadplusplus
choco install fiddler4
choco install git-credential-winstore
choco install git
choco install poshgit
choco install gitextensions 
choco install NugetPackageExplorer
choco install githubforwindows 
choco install PowerGUI
choco install powershell
choco install kdiff3
choco install markdownpad2
choco install 7zip
choco install 7zip.CommandLine
choco install pester
choco install psake -source http://packages.nuget.org/v1/FeedService.svc/

choco install NetFx3 -source windowsfeatures

choco install VisualStudio2013Premium -InstallArguments "Blend WebTools Win8SDK SilverLight_Developer_Kit WindowsPhone80"
choco install VS2013.1 

choco install gep13.DefaultConfig -source https://www.myget.org/F/gep13
choco install gep13.gitConfig -source https://www.myget.org/F/gep13
choco install gep13.vs2013extensions -source https://www.myget.org/F/gep13

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

# Enable Nuget Package Restore
choco install NuGetEnablePackageRestore -source https://www.nuget.org/api/v2/

choco install gep13.WindowsUpdate -source https://www.myget.org/F/gep13

Update-Help	
