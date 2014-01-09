try {
	git config --global "user.name" "Gary Ewan Park"
	git config --global "user.email" "gep13@gep13.co.uk"

	git config --global "push.default" "simple"
 
	git config --global "diff.tool" "kdiff3"
	git config --global "merge.tool" "kdiff3"
 
	git config --global "difftool.kdiff3.path" "C:/Program Files (x86)/KDiff3/kdiff3.exe"
	git config --global "difftool.kdiff3.keepBackup" "false"
	git config --global "difftool.kdiff3.trustExitCode" "false"

	git config --global "mergetool.kdiff3.path" "C:/Program Files (x86)/KDiff3/kdiff3.exe"
	git config --global "mergetool.kdiff3.keepBackup" "false"
	git config --global "mergetool.kdiff3.trustExitCode" "false"

	git config --global "core.symlinks" "false"
	git config --global "core.autocrlf" "true"
	git config --global "core.editor" "npp.bat"
	
	if(!(Test-Path "c:\Program Files (x86)\Git\bin\npp.bat")){
		New-Item -Type File "c:\Program Files (x86)\Git\bin\npp.bat"
		Add-Content "c:\Program Files (x86)\Git\bin\npp.bat" "#!/bin/sh`n"
		Add-Content "c:\Program Files (x86)\Git\bin\npp.bat" '"c:/Program Files (x86)/Notepad++/notepad++.exe" -multiInst -notabbar -nosession -noPlugin "$*"'
	}
	
    Write-ChocolateySuccess 'gep13.gitConfig'
} catch {
	Write-ChocolateyFailure 'gep13.gitConfig' $($_.Exception.Message)
	throw
}