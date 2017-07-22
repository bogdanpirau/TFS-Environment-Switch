#Requires -Version 3.0 -Modules WebAdministration -RunAsAdministrator
Import-Module WebAdministration

Function Test-Git {
	Try { 
		$gitVersion = git --version
		Return $True
	} catch { 
		Write-Host Please install Git -ForgroundColor Red
		Return $False 
	}
}

Function Get-DestinationFolder {
param
(
	[string]$DisplayText = 'Select Folder'
)
	$folder = $Null

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
	
	Return $folder
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

	# create new website
	If (Test-Path $IISPath){
		Remove-WebSite -Name $Name
	}
	
	New-Item $IISPath -bindings @{protocol="http";bindingInformation="*:80:$Name";} -physicalPath $PhysicalPath -Force
	#New-WebBinding -Name $Name -HostHeader $Name -Port 80 -Protocol http
	#Remove-WebBinding 
	
	Set-ItemProperty $IISPath -name ApplicationPool -value $AppPool.Name
}

Function Add-HostsFileEntry {
param(
	[string]$Name
)
	$hostsPath = "$env:windir\System32\drivers\etc\hosts"
	Add-Content $hostsPath "`n127.0.0.1 `t $name`n"
}

Function Add-FileToPowerShellProfile {
param(
	[string]$psProfileFile
)
	If (!(Test-Path $profile)){
		New-Item -typeFile $profile
	}
	
	Add-Content $profile "`n`n$psProfileFile"
}



Function Install-TFSEnvironmentAndDemo {
	If (!(Test-Git)) {
		Return
	}

	$destinationPath = Get-DestinationFolder -DisplayText 'Select the location where to install the project'

	#0 download files
	Get-CodeBase -DownloadLocation $destinationPath
    $destinationPath = Join-Path $destinationPath 'TFS-Environment-Switch'

	#1 create the WebApi Application Pool
	$wepApiAppPool = New-IISApplicationPool DemoWebApi

	#2 create the WebApi Web Site
	New-IISWebSite webapi.demmo.com (Join-Path $destinationPath 'TFSDemo\Dev-WebApi\DemoApi\DemoApi\bin\Debug\PublishOutput') $wepApiAppPool

	#3 update the hosts file
	Add-HostsFileEntry webapi.demo.com
	
	#4 create the WebApp Application Pool
	$wepAppAppPool = New-IISApplicationPool DemoWebApp
	
	#5 create the WebApp Web Site
	New-IISWebSite webapp.demmo.com (Join-Path $destinationPath 'TFSDemo\Dev-WebApp\DemoApp\DemoApp\bin\Debug\PublishOutput') $wepAppAppPool

	#6 update the hosts file
	Add-HostsFileEntry webapp.demo.com
	
	#7 add the profile.ps1 file to the windows PowerShell Profile file	
	Add-FileToPowerShellProfile (Join-Path $destinationPath 'PowerShell\Profile\profile.ps1')
}



Install-TFSEnvironmentAndDemo