#
# Set_TFSEnvFileContent.ps1
#
Function Set-TFSEnvFileContent {
param
(
	[string]$TFSEnvName
)
	$newFile = ("`$global:tfsEnv = '$TFSEnvName'" | New-Item $tfsEnvFile -ItemType File -Force);
}