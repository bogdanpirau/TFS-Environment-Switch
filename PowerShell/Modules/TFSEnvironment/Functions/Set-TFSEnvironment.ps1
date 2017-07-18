Function Set-TFSEnvironment {
param
(
	[Parameter(Mandatory=$true)]
	[ValidateSet('Dev', 'Dev_US_FeatureBranch', 'Main', 'Rel', 'Hot')]
	[string]$TFSEnvName,
	[string]$DevApi						= $(If ("$global:tfsApi_Dev" -ne "") { $global:tfsApi_Dev } Else { $env:TFSApi }),
	[string]$DevWeb						= $(If ("$global:tfsWeb_Dev" -ne "") { $global:tfsWeb_Dev } Else { $env:TFSWeb }),
	[string]$Dev_US_FeatureBranchApi	= "$global:tfsApi_Dev_US_FeatureBranch",
	[string]$Dev_US_FeatureBranchWeb	= "$global:tfsWeb_Dev_US_FeatureBranch",
	[string]$MainApi					= "$global:tfsApi_Main",
	[string]$MainWeb					= "$global:tfsWeb_Main",
	[string]$RelApi						= "$global:tfsApi_Rel",
	[string]$RelWeb						= "$global:tfsWeb_Rel",
	[string]$HotApi						= "$global:tfsApi_Hot",
	[string]$HotWeb						= "$global:tfsWeb_Hot",
	[switch]$SkipIfFileExists
)
	
	If ((Get-TFSEnvironment) -eq $TFSEnvName){
		Write-Host "The TFS Environment is already set to [#$TFSEnvName]" -ForegroundColor Green
		Return
	}

	$sw = [Diagnostics.Stopwatch]::StartNew()
	Write-Host 'Overwriting environment files' -ForegroundColor DarkCyan -NoNewline
	$cursorPosition = $Host.Ui.RawUI.CursorPosition
	
	$branchName = "tfsApi"
	$tempPath = $branchName + '_' + $TFSEnvName
	$tfsApiLocalPath = (Get-Item -path "variable:\$tempPath").Value
	
	If ([String]::IsNullOrWhiteSpace($tfsApiLocalPath)) {
		$tfsApiLocalPath = Map-TFSEnvLocalPath -TFSEnvName $TFSEnvName -BranchName $branchName
	}

	$newPath  = $TFSEnvName + 'Api'
	Set-Item -path "variable:\$newPath" -Value $tfsApiLocalPath

	$branchName = "tfsWeb"
	$tempPath = $branchName + '_' + $TFSEnvName
	$tfsWebLocalPath = (Get-Item -path "variable:\$tempPath").Value
	
	If ([String]::IsNullOrWhiteSpace($tfsWebLocalPath)) { 
		$tfsWebLocalPath = Map-TFSEnvLocalPath -TFSEnvName $TFSEnvName -BranchName $branchName
	}

	$newPath  = $TFSEnvName + 'Web'
	Set-Item -path "variable:\$newPath" -Value $tfsWebLocalPath

	Set-TFSEnvFileContent $TFSEnvName
	Set-TFSEnvPathsFileContent $DevApi $DevWeb $Dev_US_FeatureBranchApi $Dev_US_FeatureBranchWeb $MainApi $MainWeb $RelApi $RelWeb $HotApi $HotWeb
	
	If ($Host.Ui.RawUI.CursorPosition -ne $cursorPosition) {
		Write-Host ''
	}
	$sw.Stop()
	Write-Host "'`rOverwriting environment files finished in [$($sw.Elapsed)]" -ForegroundColor Cyan

	Set-TFSMachineEnvVariable $TFSEnvName $DevApi $DevWeb $Dev_US_FeatureBranchApi $Dev_US_FeatureBranchWeb $MainApi $MainWeb $RelApi $RelWeb $HotApi $HotWeb
	Use-TFSEnvironment

	Update-IISPaths

	Write-Host "tfsApi: $env:TFSApi" -ForegroundColor Cyan
	Write-Host "tfsWeb: $env:TFSWeb" -ForegroundColor Cyan

	. $Profile
}