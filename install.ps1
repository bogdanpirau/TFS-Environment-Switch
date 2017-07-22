#Requires -Version 3.0 -Modules WebAdministration -RunAsAdministrator
Import-Module WebAdministration

Function Install-TFSEnvironmentAndDemo {
	If (!Test-Git) {
		Return
	}

	$destinationPath = Get-DestinationFolder -DisplayText 'Select the location where to install the project'

	#0 download files
	Get-CodeBase -DownloadLocation $destinationPath

	#1 create the WebApi Application Pool
	$wepApiAppPool = New-WebApplicationPool

	#2 create the WebApi Web Site
	
	
	#3 create the WebApp Application Pool

	
	#4 create the WebApp Web Site

	#5 update the hosts file

	#6 add the profile.ps1 file to the windows PowerShell Profile file
}

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
	
	New-Item $IISPath -bindings @{protocol="http";bindingInformation=":80:*";hostName=$Name} -physicalPath $PhysicalPath -Force
	#New-WebBinding -Name $Name -HostHeader $Name -Port 80 -Protocol http
	Set-ItemProperty $IISPath -name ApplicationPool -value $AppPool.Name
}









# Push-Location IIS:
# Pop-Location



