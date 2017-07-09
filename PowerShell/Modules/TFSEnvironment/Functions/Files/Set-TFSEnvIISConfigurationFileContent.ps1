#
# Set_TFSEnvIISConfigurationFileContent.ps1
#
Function Set-TFSEnvIISConfigurationFileContent {
param
( 
	[switch]$Force
)	
	If ((Test-Path $tfsEnvIISConfigurationFile) -and -not $Force.IsPresent) {
		Return
	}

	$newFile = (Get-IISConfigurationFileContent | New-Item $tfsEnvIISConfigurationFile -ItemType File -Force)
}