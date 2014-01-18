try {
	cinst IIS-WebServerRole -source windowsfeatures
	cinst IIS-HttpCompressionDynamic -source windowsfeatures
	cinst TelnetClient -source windowsFeatures
	
	cinst notepadplusplus
	cinst fiddler4
	cinst git-credential-winstore
	cinst git
	cinst poshgit
	cinst gitextensions 
	cinst NugetPackageExplorer 
	cinst ChocolateyGUI 
	cinst githubforwindows 
	cinst PowerGUI
	cinst powershell
	cinst kdiff3
	cinst markdownpad2
	
	cinst NetFx3 -source windowsfeatures
	
	cinst VS2010PremiumMsdn -source https://www.myget.org/F/gep13
	
	cinst gep13.aspnetmvc -source https://www.myget.org/F/gep13
	cinst IISExpress -source webpi
	
	cinst gep13.DefaultConfig -source https://www.myget.org/F/gep13
	cinst gep13.gitConfig -source https://www.myget.org/F/gep13
	cinst gep13.vs2010extensions -source https://www.myget.org/F/gep13
	 
	# fix the "WARNING: Could not find ssh-agent" in PowerShell console as per here:
	# http://stackoverflow.com/questions/7470385/git-in-powershell-saying-could-not-find-ssh-agent
	$currentPathVariable = [environment]::GetEnvironmentVariable("PATH", "Machine")
	[System.Environment]::SetEnvironmentVariable("PATH", $currentPathVariable + ";C:\Program Files (x86)\Git\bin", "Machine")
	
	if(!(Test-Path "c:\github")) {
		New-Item -Type Directory "C:\github"
	}
	
	cd "C:\github"
	
	if(!(Test-Path "c:\github\chocolatey-coreteampackages")){
		git clone https://github.com/chocolatey/chocolatey-coreteampackages.git
	}
	
	if(!(Test-Path "c:\github\chocolatey.org")){
		git clone https://github.com/chocolatey/chocolatey.org.git
	}
	
	if(!(Test-Path "c:\github\chocolatey-webhooks")){
		git clone https://github.com/chocolatey/chocolatey-webhooks.git
	}
	
	if(!(Test-Path "c:\github\puppet-chocolatey")){
		git clone https://github.com/chocolatey/puppet-chocolatey.git
	}
	
	if(!(Test-Path "c:\github\puppet-chocolatey-handsonlab")){
		git clone https://github.com/chocolatey/puppet-chocolatey-handsonlab.git
	}
	
	if(!(Test-Path "c:\github\chocolatey")){
		git clone https://github.com/chocolatey/chocolatey.git
	}
	
	if(!(Test-Path "c:\github\chocolateytemplates")){
		git clone https://github.com/chocolatey/chocolateytemplates.git
	}
 
	if(!(Test-Path "c:\github\chocolatey.github.com")){
		git clone https://github.com/chocolatey/chocolatey.github.com.git
	}
	
	if(!(Test-Path "c:\github\chocolatey-cookbook")){
		git clone https://github.com/chocolatey/chocolatey-cookbook.git
	}
	
	if(!(Test-Path "c:\github\chocolatey.web")){
		git clone https://github.com/chocolatey/chocolatey.web.git
	}
	
	if(!(Test-Path "c:\github\chocolatey-Explorer")){
		git clone https://github.com/gep13/chocolatey-Explorer.git
	}
	
	if(!(Test-Path "c:\github\ChocolateyPackages")){
		git clone https://github.com/gep13/ChocolateyPackages.git
	}
	
	if(!(Test-Path "c:\github\ChocolateyAutomaticPackages")){
		git clone https://github.com/gep13/ChocolateyAutomaticPackages.git
	}
	
	Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Notepad++\notepad++.exe"
	Install-ChocolateyPinnedTaskBarItem "C:\Program Files\Internet Explorer\iexplore.exe"
	Install-ChocolateyPinnedTaskBarItem  "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\devenv.exe"
	
	# Enable Nuget Package Restore
	cinst NuGetEnablePackageRestore -source https://www.nuget.org/api/v2/
	
	cinst gep13.WindowsUpdate -source https://www.myget.org/F/gep13
	
	Update-Help	
	
	Write-ChocolateySuccess 'gep13.ChocolateyDev'
} catch {
	Write-ChocolateyFailure 'gep13.ChocolateyDev' $($_.Exception.Message)
	throw
}
