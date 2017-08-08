#Requires -Version 3.0 -RunAsAdministrator
param([switch]$y) #accept default location of [C:\test] for testing purposes

Start-Transcript -OutputDirectory (split-path -parent $MyInvocation.MyCommand.Definition)

Function Write-FancyHost {
param(
	[string]$text
)
	Write-Host -------------------------------------------------------------------------------------------------
	Write-Host "$text" -ForegroundColor Cyan
	Write-Host -------------------------------------------------------------------------------------------------
}

Function Start-Timer {
param(
	[System.Diagnostics.Stopwatch]$stopWatch
)
	If ($stopWatch -eq $Null) {
		$stopWatch = New-Object System.Diagnostics.Stopwatch
	}

	$stopWatch.Start()

	Return $stopWatch
}


Function Stop-Timer {
param(
	[System.Diagnostics.Stopwatch]$stopWatch,
	[string]$label = 'Execution time for ',
	[String]$text = '',
	[Switch]$restart,
	[Switch]$total
)
	$stopWatch.Stop()

	If ($total.IsPresent) {
		$props = @{ 'Step' = '-------------------------------------------------'; 'Time' = '----------------' }
		$Script:executionTimes += (New-Object –TypeName PSObject –Prop $props)

		$text = 'Total execution time'
	}

	$props = @{ 'Step' = (Get-Culture).TextInfo.ToTitleCase($text[0]) + $text.Substring(1); 'Time' = $stopWatch.Elapsed.ToString() }
	$Script:executionTimes += (New-Object –TypeName PSObject –Prop $props)

	Write-FancyHost "$label$text`: $($props.Time)"

	If ($restart.IsPresent) {
		$stopWatch.Restart()
	}
}

Function Get-DestinationFolder {
param
(
	[string]$DisplayText = 'Select Folder'
)
	$folder = $Null

	If ($y.IsPresent) {
		$folder = 'C:\test'
		$newFolder = md $folder -Force -ErrorAction SilentlyContinue
	}

	While (($folder -eq $Null) -or !(Test-Path $folder)) {
		$formsAssembly = [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

		$folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
		$folderBrowserDialog.Description = $DisplayText
		$folderBrowserDialog.RootFolder = "MyComputer"

		If ($folderBrowserDialog.ShowDialog() -eq "OK")
		{
			$folder = $folderBrowserDialog.SelectedPath
		}
		Else {
			If ([System.Windows.Forms.MessageBox]::Show('Are you sure you want to quit setting up your environment?',"$DisplayText", 'YesNo', 'Error') -eq "Yes") {
				throw [System.InvalidOperationException] "Environment configuration aborted"
			}
		}
	}

	Write-Host "Selected folder: [$folder]."

	Return $folder
}

Function Install-Chocolatey {
	$retries = 0
	$success = $false

	Do {
		$success = $true

		Try {
			iex ((new-object net.webclient).DownloadString("https://chocolatey.org/install.ps1"))
		}
		Catch {
			$success = $false
		}
		$retries++

		If (!$success) {
			Write-FancyHost "Try $retries for installing chocolatey"
		}
	}
	While ($success -eq $false -and $retries -lt 3)

	If (!$success) {
		Throw "Tried 3 times to install chocolatey without success. Please check the [chocolatey] error logs and try to fix the issues."
	}
}


Function Install-IISAndTools {
	$retries = 0
	$success = $false

	Do {
		Dism.exe /Online /Enable-Feature /All /NoRestart /FeatureName:IIS-ManagementConsole /FeatureName:IIS-WindowsAuthentication /FeatureName:IIS-HttpCompressionStatic /FeatureName:IIS-ServerSideIncludes /FeatureName:IIS-ASPNET /FeatureName:IIS-DirectoryBrowsing /FeatureName:IIS-DefaultDocument /FeatureName:IIS-StaticContent /FeatureName:IIS-ISAPIFilter  /FeatureName:IIS-ISAPIExtensions /FeatureName:IIS-WebServerManagementTools /FeatureName:IIS-Performance  /FeatureName:IIS-HttpTracing /FeatureName:IIS-RequestMonitor /FeatureName:IIS-LoggingLibraries /FeatureName:IIS-Security /FeatureName:IIS-URLAuthorization /FeatureName:IIS-RequestFiltering /FeatureName:IIS-NetFxExtensibility /FeatureName:IIS-HealthAndDiagnostics /FeatureName:IIS-HttpLogging /FeatureName:IIS-WebServerRole /FeatureName:IIS-WebServer /FeatureName:IIS-CommonHttpFeatures /FeatureName:IIS-HttpErrors /FeatureName:IIS-HttpRedirect /FeatureName:IIS-ApplicationDevelopment
		$success = $?
		$retries++

		If (!$success) {
			Write-FancyHost "Try $retries for installing IIS & Tools"
		}
	}
	While ($success -eq $false -and $retries -lt 3)

	If (!$success) {
		Throw "Tried 3 times to install IIS & Tools without success. Please check the [IIS] error logs and try to fix the issues."
	}
}

Function Test-DotNetCore {
	Try {
		$dotNetVersion = dotnet --version
		Return $True
	} catch {
		Return $False
	}
}

Function Test-Git {
	Try {
		$gitVersion = git --version
		Return $True
	} catch {
		Return $False
	}
}

Function Install-Prerequisites {
	$innerSw = Start-Timer

	Install-Chocolatey
	Stop-Timer $innerSw -text "  --  Installing chocolatey" -restart

	Install-IISAndTools
	Stop-Timer $innerSw -text "  -- Installing IIS & tools" -restart

	If (!(Test-DotNetCore)) {
		cinst -y dotnetcore-sdk
		Stop-Timer $innerSw -text "  --  Installing DotNet core SDK" -restart

		cinst -y dotnetcore
		Stop-Timer $innerSw -text "  --  Installing DotNet core" -restart
	}

	cinst -y dotnetcore-windowshosting
	Stop-Timer $innerSw -text "  --  Installing DotNet hosting" -restart

	If (!(Test-Git)) {
		cinst -y git
		Stop-Timer $innerSw -text "  --  Installing Git" -restart
	}

	. $profile

	$env:path += ';C:\program files\dotnet\;;C:\Program Files\Git\cmd;'

	net stop was /y
	net start w3svc
	Stop-Timer $innerSw -text "  --  Restarting WAS/W3SVC" -restart

	dotnet publish
	Stop-Timer $innerSw -text "  --  Initializing DotNet" -restart
}

Function Get-CodeBase {
param
(
	[Parameter(Mandatory=$true)]
	[string]$DownloadLocation
)
	Push-Location $DownloadLocation

	git clone https://github.com/bogdanpirau/TFS-Environment-Switch.git

	Pop-Location
}

Function New-IISApplicationPool {
param (
	[Parameter(Mandatory=$true)]
	[string]$Name
)
	$IISPath = (Join-Path IIS:\AppPools $Name)

	# create new Application pool
	If (Test-Path $IISPath){
		Remove-WebAppPool -Name $Name
	}

	$appPool = New-WebAppPool -Name $Name
	$appPool.ProcessModel.IdentityType = "ApplicationPoolIdentity"
	$appPool.ManagedRuntimeVersion = ''
	$appPool.ManagedPipelineMode = 'Integrated'
	$appPool | Set-Item -Path $IISPath

	Return $appPool
}

Function New-IISWebSite {
param(
	[string]$Name,
	[string]$PhysicalPath,
	$AppPool
)
	$IISPath = (Join-Path IIS:\Sites $Name)

	If (Test-Path $IISPath){
		Remove-WebSite -Name $Name
	}

	New-Item $IISPath -bindings @{protocol="http";bindingInformation="*:80:$Name";} -physicalPath $PhysicalPath -Force

	Set-ItemProperty $IISPath -name ApplicationPool -value $AppPool.Name
}

Function Add-HostsFileEntry {
param(
	[string]$Name
)
	$hostsPath = "$env:windir\System32\drivers\etc\hosts"
	Add-Content $hostsPath "`n127.0.0.1 `t $name`n"
}

Function Add-PowerShellProfileFile {
	If (!(Test-Path $profile)) {
		$targetPath = [System.IO.Directory]::GetParent("$PROFILE")

		If (!(Test-Path $targetPath)) {
			$newFolder = md $targetPath -Force -ErrorAction SilentlyContinue
		}

		Push-Location $targetPath
		$newFile = New-Item -type File -Name ([System.IO.Path]::GetFileName("$PROFILE"))
		Pop-Location
	}
}

Function Add-FileToPowerShellProfile {
param(
	[string]$psProfileFile
)
	Add-Content $Profile "`n`n. '$psProfileFile'"

	. "$Profile"
}

Function Set-EnvironmentVariables {
param(
	[Parameter(Mandatory=$True)]
	[string]$destinationPath
)
	$tfsApiPath = (Join-Path $destinationPath 'TFSDemo\Dev-WebApi')
	$tfsWebPath = (Join-Path $destinationPath 'TFSDemo\Dev-WebApp')

	[Environment]::SetEnvironmentVariable("TFSApi", $tfsApiPath, 'Machine')
	[Environment]::SetEnvironmentVariable("TFSWeb", $tfsWebPath, 'Machine')

	$env:TFSApi = $tfsApiPath
	$env:TFSWeb = $tfsWebPath
}

Function New-IISConfiguration {
param(
	[string]$Name,
	[string]$physicalPath
)
	Import-Module WebAdministration

	$wepApiAppPool = New-IISApplicationPool $Name

	New-IISWebSite $Name $physicalPath $wepApiAppPool

	Add-HostsFileEntry $Name
}

Function Print-NetworkStatistics {
param(
	$initialNetworkStatistics,
	$finalNetworkStatistics
)
	$receivedBytes = ($finalNetworkStatistics.ReceivedBytes | Sort | Select -last 1) - ($initialNetworkStatistics.ReceivedBytes | Sort | Select -last 1)
	$sentBytes = ($finalNetworkStatistics.SentBytes | Sort | Select -last 1) - ($initialNetworkStatistics.SentBytes | Sort | Select -last 1)

	$totalReceived = $receivedBytes / 1GB
	$receivedUnit = 'GB'

	If ($totalReceived -lt 1) {
		$totalReceived = $receivedBytes / 1MB
		$receivedUnit = 'MB'
	}

	$totalSent = $sentBytes / 1GB
	$sentUnit = 'GB'

	If ($totalSent -lt 1) {
		$totalSent = $sentBytes / 1MB
		$sentUnit = 'MB'
	}

	Write-FancyHost "Received $totalReceived $receivedUnit while running this script. Sent $totalSent $sentUnit".
}

Function Install-TFSEnvironment {
	$mainSW = Start-Timer
	$sw = Start-Timer
	$Script:executionTimes = @()

	$initialNetworkStatistics = Get-NetAdapterStatistics
	Stop-Timer $sw -text "getting initial Network statistics" -restart

	$destinationPath = Get-DestinationFolder -DisplayText 'Select the location where to install the project'
	Stop-Timer $sw -text "selecting a destination location" -restart

	Add-PowerShellProfileFile
	Stop-Timer $sw -text "creating the default user PowerShell profile file" -restart

	Install-Prerequisites
	Stop-Timer $sw -text "installing prerequisites" -restart

	Get-CodeBase -DownloadLocation $destinationPath
	$destinationPath = Join-Path $destinationPath 'TFS-Environment-Switch'
	Stop-Timer $sw -text "downloading source code" -restart

	New-IISConfiguration webapi.demo.com (Join-Path $destinationPath 'TFSDemo\Dev-WebApi\DemoApi\DemoApi\bin\Debug\PublishOutput')
	Stop-Timer $sw -text "configuring webapi.demo.com in IIS" -restart

	New-IISConfiguration webapp.demo.com (Join-Path $destinationPath 'TFSDemo\Dev-WebApp\DemoApp\DemoApp\bin\Debug\PublishOutput')
	Stop-Timer $sw -text "configuring webapp.demo.com in IIS" -restart

	Set-EnvironmentVariables $destinationPath
	Stop-Timer $sw -text "setting system environment variables" -restart

	Add-FileToPowerShellProfile (Join-Path $destinationPath 'PowerShell\Profile\profile.ps1')
	Stop-Timer $sw -text "setting up PowerShell profile" -restart

	bld all
	Stop-Timer $sw -text "setting up web applications" -restart

	start 'http://webapp.demo.com'
	Stop-Timer $sw -text "for opening the website" -restart

	$finalNetworkStatistics = Get-NetAdapterStatistics
	Stop-Timer $sw -text "getting final Network statistics" -restart

	Print-NetworkStatistics $initialNetworkStatistics $finalNetworkStatistics

	Stop-Timer $mainSW -Label 'Total execution time' -total

	Write-FancyHost ($Script:executionTimes | Select Step, Time | Out-String)
}

Install-TFSEnvironment

Stop-Transcript