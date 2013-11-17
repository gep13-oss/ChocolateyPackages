$packageName = 'poweriso'
$silentArgs = '/S'
$validExitCodes = @(0)

try {
  # HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\PowerISO
  $file = (Get-ItemProperty -Path "hklm:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\PowerISO").UninstallString
  Uninstall-ChocolateyPackage -PackageName $packageName -FileType 'EXE' -SilentArgs $silentArgs -validExitCodes $validExitCodes -File $file
  
  # the following is all part of error handling
  Write-ChocolateySuccess $package
} catch {
  Write-ChocolateyFailure $package "$($_.Exception.Message)" 
}