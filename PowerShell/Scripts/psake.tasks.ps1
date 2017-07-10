properties {
}

task web {
	Try {
		Push-LocationEX $env:TFSWeb\DemoApp
		dotnet build
	}
	Catch {
		Pop-Location
	}
}

task stop-iis {
		iisreset /stop
}

task start-iis {
		iisreset /start
}

task web-publish {
	Try {
		Push-LocationEX $env:TFSWeb\DemoApp
		iisreset /stop
		dotnet restore
		dotnet build /p:DeployOnBuild=true /p:PublishProfile=FolderProfile
	}
	Catch {
		Pop-Location
	}
	Finally{
		iisreset /start
	}
}

task api {
	Try {
		Push-LocationEX $env:TFSApi\DemoApi
		dotnet build
	}
	Catch {
		Pop-Location
	}
}

task api-publish {
	Try {
		Push-LocationEX $env:TFSApi\DemoApi
		iisreset /stop
		dotnet restore
		dotnet build /p:DeployOnBuild=true /p:PublishProfile=FolderProfile
	}
	Catch {
		Pop-Location
	}
	Finally{
		iisreset /start
	}
}