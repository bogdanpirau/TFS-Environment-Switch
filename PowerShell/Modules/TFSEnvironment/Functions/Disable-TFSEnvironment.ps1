#
# Disable-TFSEnvironment.ps1
#
Function Disable-TFSEnvironment {
param
(
)
	Remove-Item $tfsEnvironmentSwitchPath -Force
	. $Profile
}