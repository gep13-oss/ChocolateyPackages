try {
	$configFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'VS2010Config.ini')
	$mountIsoModule = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'mount-iso.psm1')
	
	Import-Module $mountIsoModule
	
	if(Test-Path env:VisualStudio2010IsoLocation) {
		$visualStudio2010iso = env:VisualStudio2010IsoLocation
	}
	else {
		$visualStudio2010iso = "F:\en_visual_studio_2010_premium_x86_dvd_509357.iso"	
	}
	
	if(Test-Path env:VisualStudio2010SP1IsoLocation) {
		$visualStudio2010SP1iso = env:VisualStudio2010SP1IsoLocation
	}
	else {
		$visualStudio2010SP1iso = "F:\mu_visual_studio_2010_sp1_x86_dvd_651704.iso"
	}
	
	# Where are we running from?
	$isoStoreDriveLetter = [System.IO.Path]::GetPathRoot($visualStudio2010SP1iso)
	
	$before = (Get-Volume).DriveLetter
	
	Write-Host "Mounting Visual Studio 2010 iso..."
	$visualStudio2010MountPath = Mount-Iso $visualStudio2010iso
	Write-Host "Mounting complete."
	
	Write-Host "Mounting Visual Studio 2010 SP1 iso..."
	$visualStudio2010SP1MountPath = Mount-Iso $visualStudio2010SP1iso
	Write-Host "Mounting complete."
	
	$after = (Get-Volume).DriveLetter
	$winVolume = compare $before $after -Passthru
	$winVolume | % { new-PSDrive -Name $_ -PSProvider FileSystem -Root "$($_):\" | out-null}
	
	Write-Host "Copying Visual Studio 2010 Files..."
	Copy-Item $visualStudio2010MountPath (Join-Path -Path $isoStoreDriveLetter -ChildPath "2010") -recurse
	Write-Host "Copying complete."
	
	Write-Host "Copying Visual Studio 2010 SP1 Files..."
	Copy-Item $visualStudio2010SP1MountPath (Join-Path -Path $isoStoreDriveLetter -ChildPath "2010\SP1") -recurse
	Write-Host "Copying complete."
	
	Write-Host "Dismounting Visual Studio 2010 iso..."
	Dismount-Iso $visualStudio2010MountPath
	Write-Host "Dismounting complete."
	
	Write-Host "Dismounting Visual Studio 2010 SP1 iso..."
	Dismount-Iso $visualStudio2010SP1MountPath
	Write-Host "Dismounting complete."
	
	Install-ChocolateyInstallPackage "VS2010PremiumMsdn" "EXE" "/q /norestart /unattendfile $configFile" (Join-Path -Path $isoStoreDriveLetter -ChildPath "2010\setup\setup.exe") -validExitCodes @(0)
	Install-ChocolateyInstallPackage "VS2010PremiumMsdn" "EXE" "/q" (Join-Path -Path $isoStoreDriveLetter -ChildPath "2010\SP1\setup.exe") -validExitCodes @(0)
	
	Write-ChocolateySuccess 'VS2010PremiumMsdn'
} catch {
	Write-ChocolateyFailure 'VS2010PremiumMsdn' $($_.Exception.Message)
	throw
}
