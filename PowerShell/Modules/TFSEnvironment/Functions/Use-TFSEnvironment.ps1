Function Use-TFSEnvironment {
	$global:UseTFSEnvironment = $false
	
	If (Test-Path $tfsEnvironmentSwitchPath) {
		$global:UseTFSEnvironment = $true
	}

	If (!$global:UseTFSEnvironment) {
		Return
	}

	If (!(Test-Path $tfsEnvFile) -or !(Test-Path $tfsEnvIISConfigurationFile)){
		Initialize-TFSEnvironment
		Return
	}

	$sw = [Diagnostics.Stopwatch]::StartNew()
	Write-Host "Loading TFSNET Environment" -ForegroundColor DarkCyan -NoNewline

	. "$tfsEnvIISConfigurationFile"
	. "$tfsEnvFile"
	. "$tfsEnvPathsFile"

	Reload-EnviromentVariables

	$env:TFSApi = [Environment]::GetEnvironmentVariable('TFSApi', [System.EnvironmentVariableTarget]::Machine);
	$env:TFSWeb = [Environment]::GetEnvironmentVariable('TFSWeb', [System.EnvironmentVariableTarget]::Machine);

	$sw.Stop()
	Write-Host "`rLoading TFSNET Environment finished in [$($sw.Elapsed)]" -ForegroundColor Cyan
}