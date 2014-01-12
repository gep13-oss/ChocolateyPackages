try {
	$configFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'VS2010Config.ini')
	$mountIsoModule = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'mount-iso.psm1')
	
	Import-Module $mountIsoModule
	
	$visualStudio2010iso = "E:\en_visual_studio_2010_premium_x86_dvd_509357.iso"
	$visualStudio2010SP1iso = "E:\mu_visual_studio_2010_sp1_x86_dvd_651704.iso"
	
	$before = (Get-Volume).DriveLetter
	
	Write-Host "Mounting Visual Studio 2010 iso..."
	$visualStudio2010MountPath = Mount-Iso $visualStudio2010iso
	Write-Host "Mounting complete."
	
	$after = (Get-Volume).DriveLetter
    $winVolume = compare $before $after -Passthru
    $winVolume | % { new-PSDrive -Name $_ -PSProvider FileSystem -Root "$($_):\" | out-null}
	
	Write-Host "Copying Visual Studio 2010 Files..."
	Copy-Item $visualStudio2010MountPath "E:\2010" -recurse
	Write-Host "Copying complete."
	
	Write-Host "Dismounting Visual Studio 2010 iso..."
	Dismount-Iso $visualStudio2010MountPath
	Write-Host "Dismounting complete."
	
	$before = (Get-Volume).DriveLetter
	
	Write-Host "Mounting Visual Studio 2010 SP1 iso..."
	$visualStudio2010SP1MountPath = Mount-Iso $visualStudio2010SP1iso
	Write-Host "Mounting complete."
	
	$after = (Get-Volume).DriveLetter
    $winVolume = compare $before $after -Passthru
    $winVolume | % { new-PSDrive -Name $_ -PSProvider FileSystem -Root "$($_):\" | out-null}
	
	Write-Host "Copying Visual Studio 2010 SP1 Files..."
	Copy-Item $visualStudio2010SP1MountPath "E:\2010\SP1" -recurse
	Write-Host "Copying complete."
	
	Write-Host "Dismounting Visual Studio 2010 SP1 iso..."
	Dismount-Iso $visualStudio2010SP1MountPath
	Write-Host "Dismounting complete."
	
	Install-ChocolateyInstallPackage "VS2010PremiumMsdn" "EXE" "/q /norestart /unattendfile $configFile" "E:\2010\setup\setup.exe" -validExitCodes @(0)
	Install-ChocolateyInstallPackage "VS2010PremiumMsdn" "EXE" "/q" "E:\2010\SP1\setup.exe" -validExitCodes @(0)
	
    Write-ChocolateySuccess 'VS2010PremiumMsdn'
} catch {
    Write-ChocolateyFailure 'VS2010PremiumMsdn' $($_.Exception.Message)
    throw
}