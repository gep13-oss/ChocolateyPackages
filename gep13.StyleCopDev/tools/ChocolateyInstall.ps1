try {
	cinstm DotNet3.5
	cinstm notepadplusplus
	cinstm fiddler4
	cinstm hg
	cinstm Posh-HG
	cinstm tortoisehg
	cinstm Wix35
	cinstm resharper
	
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