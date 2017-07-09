#
# Set_TFSEnvPathsFileContent.ps1
#
Function Set-TFSEnvPathsFileContent {
param
(
	[string]$DevApi,
	[string]$DevApp,
	#[string]$DevApi_US_FeatureBranch,
	#[string]$DevApp_US_FeatureBranch,
	[string]$MainApi,
	[string]$MainApp,
	[string]$RelApi,
	[string]$RelApp,
	[string]$HotApi,
	[string]$HotApp
)
			$newFile = (
"`$global:TFSApi_Dev = '$DevApi';
`$global:TFSApp_Dev = '$DevApp';
#`$global:TFSApi_Dev_US_FeatureBranch = '$DevApi_US_FeatureBranch';
#`$global:TFSApp_Dev_US_FeatureBranch = '$DevApp_US_FeatureBranch';
`$global:TFSApi_Main = '$MainApi';
`$global:TFSApp_Main = '$MainApp';
`$global:TFSApi_Rel = '$RelApi';
`$global:TFSApp_Rel = '$RelApp';
`$global:TFSApi_Hot = '$HotApi';
`$global:TFSApp_Hot = '$HotApp';" | New-Item $tfsEnvPathsFile -ItemType File -Force)
}