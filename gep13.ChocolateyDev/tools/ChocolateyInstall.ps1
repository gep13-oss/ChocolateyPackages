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
choco install ChocolateyGUI 
choco install githubforwindows 
choco install PowerGUI
choco install powershell
choco install kdiff3
choco install markdownpad2
choco install 7zip
choco install wixtoolset

choco install NetFx3 -source windowsfeatures

choco install VS2010PremiumMsdn -source https://www.myget.org/F/gep13

choco install gep13.aspnetmvc -source https://www.myget.org/F/gep13
choco install IISExpress -source webpi

choco install VisualStudio2013Premium -InstallArguments "Blend WebTools Win8SDK SilverLight_Developer_Kit WindowsPhone80"

choco install gep13.DefaultConfig -source https://www.myget.org/F/gep13
choco install gep13.gitConfig -source https://www.myget.org/F/gep13
choco install gep13.vs2010extensions -source https://www.myget.org/F/gep13
choco install gep13.vs2013extensions -source https://www.myget.org/F/gep13
	
# fix the "WARNING: Could not find ssh-agent" in PowerShell console as per here:
# http://stackoverflow.com/questions/7470385/git-in-powershell-saying-could-not-find-ssh-agent
$currentPathVariable = [environment]::GetEnvironmentVariable("PATH", "Machine")
[System.Environment]::SetEnvironmentVariable("PATH", $currentPathVariable + ";C:\Program Files (x86)\Git\bin", "Machine")

if(!(Test-Path "c:\github")) {
	New-Item -Type Directory "C:\github"
}

if(!(Test-Path "c:\github\organisations")) {
	New-Item -Type Directory "C:\github\organisations"
}

cd "C:\github\organisations"

if(!(Test-Path "c:\github\organisations\chocolatey-coreteampackages")){
	git clone https://github.com/chocolatey/chocolatey-coreteampackages.git
}

if(!(Test-Path "c:\github\organisations\chocolatey.org")){
	git clone https://github.com/chocolatey/chocolatey.org.git
}

if(!(Test-Path "c:\github\organisations\chocolatey-webhooks")){
	git clone https://github.com/chocolatey/chocolatey-webhooks.git
}

if(!(Test-Path "c:\github\organisations\puppet-chocolatey")){
	git clone https://github.com/chocolatey/puppet-chocolatey.git
}

if(!(Test-Path "c:\github\organisations\puppet-chocolatey-handsonlab")){
	git clone https://github.com/chocolatey/puppet-chocolatey-handsonlab.git
}

if(!(Test-Path "c:\github\organisations\chocolatey")){
	git clone https://github.com/chocolatey/chocolatey.git
}

if(!(Test-Path "c:\github\organisations\chocolateytemplates")){
	git clone https://github.com/chocolatey/chocolateytemplates.git
}

if(!(Test-Path "c:\github\organisations\chocolatey.github.com")){
	git clone https://github.com/chocolatey/chocolatey.github.com.git
}

if(!(Test-Path "c:\github\organisations\chocolatey-cookbook")){
	git clone https://github.com/chocolatey/chocolatey-cookbook.git
}

if(!(Test-Path "c:\github\organisations\chocolatey.web")){
	git clone https://github.com/chocolatey/chocolatey.web.git
}

if(!(Test-Path "c:\github\organisations\ChocolateyGUI")){
	git clone https://github.com/chocolatey/ChocolateyGUI.git
}

# My Repos
cd "c:\github"

if(!(Test-Path "c:\github\ChocolateyPackages")){
	git clone https://github.com/gep13/ChocolateyPackages.git
}

if(!(Test-Path "c:\github\ChocolateyAutomaticPackages")){
	git clone https://github.com/gep13/ChocolateyAutomaticPackages.git
}

if(!(Test-Path "C:\github\chocolatey")) {
	git clone https://github.com/gep13/chocolatey.git
}

if(!(Test-Path "C:\github\chocolatey.org")) {
	git clone https://github.com/gep13/chocolatey.org.git
}

Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Notepad++\notepad++.exe"
Install-ChocolateyPinnedTaskBarItem "C:\Program Files\Internet Explorer\iexplore.exe"
Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\devenv.exe"
Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\devenv.exe"

# Enable Nuget Package Restore
choco install NuGetEnablePackageRestore -source https://www.nuget.org/api/v2/

choco install gep13.WindowsUpdate -source https://www.myget.org/F/gep13

Update-Help	