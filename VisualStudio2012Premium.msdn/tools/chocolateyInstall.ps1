$adminFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'AdminDeployment.xml')
$imagePath = "\\10.10.13.200\shared\msdn\Developer Tools\Visual Studio 2012\en_visual_studio_premium_2012_x86_dvd_920758.iso"

# Mount the iso
Mount-DiskImage $imagePath

$visualStudioIso = Get-DiskImage $imagePath

if($visualStudioIso.Attached -eq "True") {
	$driveLetter = (Get-DiskImage -ImagePath $imagePath | Get-Volume).DriveLetter
	$executablePath = $driveLetter + ':\vs_premium.exe'

	Install-ChocolateyInstallPackage 'VisualStudio2012Premium' 'exe' "/Passive /NoRestart /AdminFile $adminFile /Log $env:temp\vs.log" $executablePath

	# Dismount the iso
	Get-Volume $driveLetter | Get-DiskImage | Dismount-DiskImage
}
else {
	Write-Host "Unable to mount iso image"
}