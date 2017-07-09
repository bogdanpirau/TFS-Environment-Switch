#
# Get_IISConfigurationFileContent.ps1
#
Function Get-IISConfigurationFileContent {
param
( 
	[switch]$Force
)	
	$configuration = Get-IIsConfiguration
	$iisConfiguration = '$global:iisTFSConfigurations = @()' + [System.Environment]::NewLine + [System.Environment]::NewLine	
	
	If ($configuration.websites.length -gt 0) {
		Foreach ($website in $configuration.websites) {
			$iisConfiguration += Get-WebItemConfig($website)
		}
	}

	If ($configuration.webApplications.length -gt 0) {
		Foreach ($webApplication in $configuration.webApplications) {
			$iisConfiguration += Get-WebItemConfig($webApplication)
		}
	}

	If ($configuration.virtualDirectories.length -gt 0) {
		Foreach ($virtualDirectory in $configuration.virtualDirectories) {
			$iisConfiguration += Get-WebItemConfig($virtualDirectory)
		}
	}

	Return $iisConfiguration
}