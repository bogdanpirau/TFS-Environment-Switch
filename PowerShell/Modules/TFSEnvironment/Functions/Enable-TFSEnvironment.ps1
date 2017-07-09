#
# Enable-TFSEnvironment.ps1
#
Function Enable-TFSEnvironment {
param
(
)
	$tfsEnvSwitchFile = '' | New-Item $tfsEnvironmentSwitchPath -ItemType File -Force
	. $Profile
}