New-Variable TFSEnvironments -Scope Global -Force -Value (New-Object PSObject -Property @{ 
    Dev =  @{ 
		Name = 'Dev'; 
		Color = 'Green';
		Branches = @{
			tfsApi = @{
				Name = 'tfsApi';
				TFSName = 'Dev-WebApi';
				TFSPath= '$/TFS Demo/Dev-WebAPI';
			};
			tfsWeb = @{
				Name = 'tfsWeb';
				TFSName = 'Dev-WebApp';
				TFSPath= '$/TFS Demo/Dev-WebApp';
			};
		};
	};

	#Dev_US_FeatureBranch =  @{ 
	#	Name = 'Dev_US_FeatureBranch'; 
	#	Color = 'Cyan';
	#	Branches = @{
	#		tfsApi = @{
	#			Name = 'tfsApi';
	#			TFSName = 'Dev-WebApi';
	#			TFSPath= '$/TFS Demo/US-Features-Dev-WebApi/US-FeatureBranch';
	#		};
	#		tfsWeb = @{
	#			Name = 'tfsWeb';
	#			TFSName = 'US-FeatureBranch';
	#			TFSPath= '$/TFS Demo/US-Features-Dev-WebApp/US-FeatureBranch';
	#		};
	#	};
	#};

	Main = @{
		Name = 'Main';
		Color = 'Yellow';
		Branches = @{
			tfsApi = @{
				Name = 'tfsApi';
				TFSName = 'Main-WebApi';
				TFSPath= '$/TFS Demo/Main-WebApi';
			};
			tfsWeb = @{
				Name = 'tfsWeb';
				TFSName = 'Main-WebApp';
				TFSPath= '$/TFS Demo/Main-WebApp';
			};
		};
	};

	Rel =  @{
		Name = 'Rel';
		Color = 'Red';
		Branches = @{
			tfsApi = @{
				Name = 'tfsApi';
				TFSName = 'Rel-WebApi';
				TFSPath= '$/TFS Demo/Rel-WebApi';
			};
			tfsWeb = @{
				Name = 'tfsWeb';
				TFSName = 'Rel-WebApp';
				TFSPath= '$/TFS Demo/Rel-WebApp';
			};
		};
	};

	Hot = @{
		Name = 'Hot';
		Color = 'DarkRed';
		Branches = @{
			tfsApi = @{
				Name = 'tfsApi';
				TFSName = 'Hot-WebApi'
				TFSPath= '$/TFS Demo/Hot-WebApi';
			};
			tfsWeb = @{
				Name = 'tfsWeb';
				TFSName = 'Hot-WebApp'
				TFSPath= '$/TFS Demo/Hot-WebApp';
			};
		};
	}
});

$tfsEnvFile = Join-Path (Split-Path "$profile") 'TFSEnvironment.ps1'
$tfsEnvPathsFile = Join-Path (Split-Path "$profile") 'TFSEnvironmentPaths.ps1'
$tfsEnvIISConfigurationFile = Join-Path (Split-Path "$profile") 'TFSEnvironmentIISConfiguration.ps1'
$tfsEnvironmentSwitchPath = Join-Path (Split-Path "$profile") 'Use-TFSEnvironment.ps1'