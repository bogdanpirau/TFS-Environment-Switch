Function Set-TFSMachineEnvVariable {
param
(
	[ValidateSet('Dev', 'Dev_US_FeatureBranch', 'Main', 'Rel', 'Hot')]
	[string]$TFSEnvName,
	[string]$DevApi,
	[string]$DevApp,
	[string]$DevApi_US_FeatureBranch,
	[string]$DevApp_US_FeatureBranch,
	[string]$MainApi,
	[string]$MainApp,
	[string]$RelApi,
	[string]$RelApp,
	[string]$HotApi,
	[string]$HotApp
)
	Switch($TFSEnvName) {
		$TFSEnvironments.Dev.Name {
			$tfsApi = $DevApi;
			$tfsWeb = $DevApp;
		}

		$TFSEnvironments.Dev_US_FeatureBranch.Name {
			$tfsApi = $DevApi_US_FeatureBranch;
			$tfsWeb = $DevApp_US_FeatureBranch;
		}

		$TFSEnvironments.Main.Name {
			$tfsApi = $MainApi;
			$tfsWeb = $MainApp;
		}

		$TFSEnvironments.Rel.Name {
			$tfsApi = $RelApi;
			$tfsWeb = $RelApp;
		}

		$TFSEnvironments.Hot.Name {
			$tfsApi = $HotApi;
			$tfsWeb = $HotApp;
		}
	}

	$sw = [Diagnostics.Stopwatch]::StartNew()
	Write-Host "Setting machine env var TFSApi: [$tfsApi], TFSWeb: [$tfsWeb]" -ForegroundColor DarkCyan -NoNewline

	[Environment]::SetEnvironmentVariable('TFSApi', $tfsApi, [System.EnvironmentVariableTarget]::Machine);
	[Environment]::SetEnvironmentVariable('tfsWeb', $tfsWeb, [System.EnvironmentVariableTarget]::Machine);

	$sw.Stop()
	Write-Host "`rSetting machine env var TFSApi: [$tfsApi], TFSWeb: [$tfsWeb] finished in [$($sw.Elapsed)]" -ForegroundColor Cyan
}