$packageName = 'wixtoolset'
$uninstallRegKey = 'HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{3d1f6355-a0b0-49a1-b977-43cdbe771169}'

$uninstallPath = (Get-ItemProperty $uninstallRegKey).QuietUninstallString

Start-ChocolateyProcessAsAdmin -exeToRun $uninstallPath