choco install DotNet3.5
choco install notepadplusplus
choco install fiddler4
choco install hg
choco install Posh-HG
choco install tortoisehg
choco install Wix35
choco install resharper

Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Notepad++\notepad++.exe"
Install-ChocolateyPinnedTaskBarItem "C:\Program Files\Internet Explorer\iexplore.exe"

if(!(Test-Path "c:\dev\stylecop-main")) {
	New-Item -Type Directory "c:\dev\stylecop-main"
}

cd "c:\dev\stylecop-main"

if(!(Test-Path "c:\dev\stylecop-main\stylecop")){
	hg clone https://hg.codeplex.com/stylecop
}

# Add a section to update the C:\users\gep13\mercurial.ini with:
# [ui]
# username = gep13 <gep13@gep13.co.uk>

Install-ChocolateyDesktopLink '%windir%\system32\cmd.exe /k c:\dev\stylecop-main\project\environment.cmd'