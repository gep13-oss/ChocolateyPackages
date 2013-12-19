$package = 'cdburnerxp'
$silentArgs = '/SILENT'
$validExitCodes = @(0,1)

try {
  # HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7E265513-8CDA-4631-B696-F40D983F3B07}_is1
  $file = (Get-ItemProperty -Path "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7E265513-8CDA-4631-B696-F40D983F3B07}_is1").UninstallString
  Uninstall-ChocolateyPackage -PackageName $package -FileType 'EXE' -SilentArgs $silentArgs -validExitCodes $validExitCodes -File $file
  
  # the following is all part of error handling
  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)" 
}