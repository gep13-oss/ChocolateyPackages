function Get-InstalledPrograms([string]$include = "*", [switch] $detailed=$false)
{
#EX:
#	Get-InstalledPrograms *desktop* |
#		foreach {(get-itemproperty -path $_.PSPath -name UninstallString -ea SilentlyContinue).UninstallString}


	$name = "";
	$items = dir -path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
	$items += dir -path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
	$items |
		foreach {
			$regObj = $_; 
			if(-not $regObj) { continue; }
			
			$name = (get-itemproperty -path $_.PSPath -name DisplayName -ea SilentlyContinue)
			if(-not $name) {
				$name = $regObj.PSChildName
			}
			else { $name = $name.DisplayName }
			if($detailed) {
				foreach ($vname in $regObj.GetValueNames()) {
					$val = $regObj.GetValue($vname);
					#$regObj[$vname] = $val;
					write-host "$vname=$val"
				}
			}

			echo $regObj
		} |
		where { 
			$_ -like $include -or $name -like $include -or $_.Name -like $include -or $_.PSChildName -like $include
		} | 
		foreach { 

			$_; 
			if($_.PSPath -and $detailed) {
				foreach ($vname in $_.GetValueNames()) {
					$val = $_.GetValue($vname);
					
					write-host "$vname=$val"
				}
				write-host -for yellow (get-itemproperty -path $_.PSPath -name UninstallString -ea SilentlyContinue) -ea SilentlyContinue;
				write-host -for yellow (get-itemproperty -path $_.PSPath -name DisplayName -ea SilentlyContinue) -ea SilentlyContinue;
			}
			
		}
}


function Uninstall-Conditionally(
		[Parameter(Mandatory=$true)]
		[string]$installerKeyName, 
		[Parameter(Mandatory=$true)]
		[string]$newDisplayVersion, 
		[Parameter(Mandatory=$true)]
		[int]$newVersion, 
		[Parameter(Mandatory=$true)]
		[string]$packageName,
		[Parameter(Mandatory=$true)]
		[string]$logDir) {
	#check for existing PowerGUI installs
	$powerguiRegs = get-installedprograms "$installerKeyName"
	
	foreach($powerguiReg in $powerguiRegs) {

		$installedDisplayVersion = $powerguiReg.GetValue("DisplayVersion");
		$installedVersion = $powerguiReg.GetValue("Version");
		
		if($newDisplayVersion -like $installedDisplayVersion) {
			Write-Warning "$packageName $installedDisplayVersion is already installed (but not by Chocolatey!), not installing new version"
			return $false;
		}
		elseif($installedVersion -lt $newversion) {
			Write-Warning "$packageName $installedDisplayVersion is lower than new version: $newDisplayVersion, will uninstall existing version"
			$msiUninstallLoggingArgs = "/lvoicewarmupx `"$logDir\${packageName}${installedDisplayVersion}_uninstall.log`""
			Start-ChocolateyProcessAsAdmin "/quiet $msiUninstallLoggingArgs /x$installerKeyName" 'msiexec'
			return $true

		} else {
			throw "$packageName $installedDisplayVersion is a higher version than the version attempting to be installed ($newDisplayVersion), will not install"
		}
		
	}

}


function Uninstall-UnConditionally(
		[Parameter(Mandatory=$true)]
		[string]$installerKeyName) {
	#check for existing PowerGUI installs
	$powerguiRegs = get-installedprograms "$installerKeyName"
	
	foreach($powerguiReg in $powerguiRegs) {

			Exec-Process "Msiexec" "/quiet $msiUninstallLoggingArgs /x$installerKeyName" 

	}

}


#Use this to wait a process to complete
function Exec-Process([string]$executablePath, [string]$arguments, [switch]$waitForCompletion) {
	Write-Host ("Start at: " + [DateTime]::Now.ToString())
	write-host -for cyan "$executablePath ${arguments}"
	$continue = $true
	while($continue) {
		try {
			$process = [diagnostics.process]::start($executablePath, $arguments); 
			if($waitForCompletion) {
			    $process.WaitForExit(); 
		        Write-host "Exited with code: $($process.ExitCode)"
			}
			$continue = $false;
			break;
		} catch {
		
			if($_.Exception.Message.Contains("The wrong diskette is in the drive")) {
				Write-Warning $_.Exception
				Write-Warning "Retrying operation..."
				$continue = $true;
				[Threading.Thread]::Sleep(1000);
			} else {
				throw
			}
		}
	}
	Write-Host ("End at: " + [DateTime]::Now.ToString())
}

#requires -version 2.0
Add-Type @"
public class Shift {
   public static int   Right(int x,   int count) { return x >> count; }
   public static uint  Right(uint x,  int count) { return x >> count; }
   public static long  Right(long x,  int count) { return x >> count; }
   public static ulong Right(ulong x, int count) { return x >> count; }
   public static int    Left(int x,   int count) { return x << count; }
   public static uint   Left(uint x,  int count) { return x << count; }
   public static long   Left(long x,  int count) { return x << count; }
   public static ulong  Left(ulong x, int count) { return x << count; }
}                    
"@


function VCDMount-Iso([string]$isoPath, [switch]$waitUntilDriveAvailable) {
	<#
		.SYNOPSIS
			Uses Virtual Clone Drive to mount the specified ISO file
	
		.DESCRIPTION
			Mounts the specified image file and returns the PSDrive that was mounted
	
		.PARAMETER  isoPath
			the Path of the image file
	
		.EXAMPLE
			PS C:\> $mountedDrive = VCDMount-Iso "c:\Stuff.iso"
	
		.INPUTS
			System.String
	
		.OUTPUTS
			PSDrive
	
		.NOTES
			Requires Virtual Clone Drive and at least one drive letter is configured in Virtual Clone Drive

	#>
	
	
	$vcdPath = ""

	$path = (gi "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\VCDMount.exe" -errorAction silentlycontinue)
	if($path) {
	$vcdPath = $path.GetValue($null)
	if(-not [io.File]::exists($vcdPath)) {
		throw "The file $vcdPath does not exist, please install Virtual Clone Drive"
	}
	} else {
	throw "The registry key 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\App Paths\VCDMount.exe' was not found.  Please install Virtual Clone Drive"
	}

	$drives = VCDGet-PSDrives
	$driveToMount = $null
	if(-not $drives) { throw "Virtual Clone Drive does not have any drive letters assigned.  Please assign at least one drive." }
	foreach($drive in $drives) {
		if(-not (Get-PSDrive $drive -ErrorAction SilentlyContinue)) {
			$driveToMount = $drive
			break;
		}
	}
	
	#all drives are in use, then unmount the first one
	if(-not $driveToMount) {
		$driveToMount = $drives[0]
	}

	$val = Exec-Process -executablePath $vcdPath -arguments "/l=$driveToMount `"$isoPath`"" -waitForCompletion
	
	$psdrive = $null

	if($waitUntilDriveAvailable) {	
		$sw = new-object System.Diagnostics.Stopwatch
		$sw.Start();
		while(-not $psdrive -or ($psdrive -and -not (dir $psdrive.Root -erroraction silentlycontinue))) { 
			Write-Progress -PercentComplete -1 -Activity "Waiting for Drive $driveToMount to become available" -CurrentOperation "Waiting" -SourceId 1 -Status "Polling for drive readiness"
			$psdrive = (Get-PSDrive | where { $_.Name -like "$driveToMount" })

			[Threading.Thread]::Sleep(200)
			if($sw.Elapsed.TotalSeconds -gt 30) {Write-Warning "Timeout (30 seconds) waiting for drive to become ready"; break; }
		}
       
        Write-Progress -PercentComplete -1 -Activity "Waiting for Drive $driveToMount to become available" -CurrentOperation "Waiting" -completed -SourceId 1 -Status "Polling for drive readiness"
	}
	return $psdrive
}


function VCDGet-PSDrives() {
<#
	.SYNOPSIS
		Gets a list of all drive letters that Virtual Clone Drive uses

	.DESCRIPTION
		Gets a list of all drive letters that Virtual Clone Drive uses

	.EXAMPLE
		PS C:\> $drives = VCDGet-PSDrives
		
	.INPUTS
		None

	.OUTPUTS
		char[]

	.NOTES
		Requires that Virtual clone drive is installed

	.LINK
		VCDMount-Iso

#>



	#need to get the drives that VCD uses
	$vcdKey = gi "Registry::HKEY_CURRENT_USER\Software\Elaborate Bytes\VirtualCloneDrive"

	if( -not $vcdKey) {
		throw "No Virtual Clone Drive letters are specified in HKEY_CURRENT_USER\Software\Elaborate Bytes\VirtualCloneDrive" 
	}
	
	$driveMask = [int]$vcdKey.GetValue("VCDDriveMask");
	
	$driveLetters = @();
	
	$start = [int][char]'A';
	$end = [int][char]'Z';
	for($letter = $start; $letter -le $end; $letter++)
	{
		if(1 -band $driveMask) {
			#found a letter
			$driveLetters += [char]$letter
		}
		
		$driveMask = [Shift]::Right($driveMask, 1)
	}
	$driveLetters
}

function Remove-ZoneIdentifier([string]$path) {
<#
	.SYNOPSIS
		Prevent the Unblock prompt from occurring

#>

	cmd /c "echo.>`"$path`":Zone.Identifier"

}

Export-ModuleMember Get-InstalledPrograms
Export-ModuleMember Uninstall-Conditionally
Export-ModuleMember Uninstall-UnConditionally
Export-ModuleMember Exec-Process
Export-ModuleMember VCDGet-PSDrives
Export-ModuleMember VCDMount-Iso
Export-ModuleMember Remove-ZoneIdentifier