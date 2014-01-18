try {
	cinst DotNet3.5
	cinst notepadplusplus
	cinst fiddler4
	cinst hg
	cinst Posh-HG
	cinst tortoisehg
	cinst Wix35
	cinst resharper
	
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
	
    Write-ChocolateySuccess 'gep13.StyleCopDev'
} catch {
  Write-ChocolateyFailure 'gep13.StyleCopDev' $($_.Exception.Message)
  throw
}