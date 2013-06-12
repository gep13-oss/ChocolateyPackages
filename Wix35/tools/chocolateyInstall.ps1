
try { 
  $packageName = "Wix35"
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64
  $mydir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
  $contentDir = ($mydir | Split-Path | Join-Path -ChildPath "content")
  $binDir = ($mydir | Split-Path | Join-Path -ChildPath "bin")
  $toolsDir = ($mydir | Split-Path | Join-Path -ChildPath "tools")
  $shortcutTarget = Join-Path $binDir "$packageName.msi"
  
  
	Import-Module "$toolsDir\DeploymentUtils.psm1"

   Install-ChocolateyPackage -packageName "$packageName" `
   						-fileType 'msi' `
   						-url 'https://wix.codeplex.com/downloads/get/204417' `
   						-silentArgs '/quiet' `
   						-validExitCodes @(0)
  Write-ChocolateySuccess $packageName
} catch {
  Write-ChocolateyFailure $packageName "$($_.Exception.Message)"
  throw 
}
