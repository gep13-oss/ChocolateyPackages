$package = 'fiddler4'
$silentArgs = '/S'
$validExitCodes = @(0,1)

try {
  # HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Fiddler2
  $file = (Get-ItemProperty -Path "hklm:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Fiddler2").UninstallString
  Uninstall-ChocolateyPackage -PackageName $package -FileType 'EXE' -SilentArgs $silentArgs -validExitCodes $validExitCodes -File $file
  
  # the following is all part of error handling
  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)" 
}