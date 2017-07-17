properties {
}

task web-publish -depends stop-iis, web-restore, publish-web, start-iis
task api-publish -depends stop-iis, api-restore, publish-api, start-iis

task stop-iis {
	iisreset /stop
}

task start-iis {
	iisreset /start
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

task web-restore {
	Try {
		Push-LocationEX $env:TFSWeb\DemoApp
		dotnet restore
	}
	Catch {
		Pop-Location
	}
	Finally{
	}
}

task publish-web {
	Try {
		Push-LocationEX $env:TFSWeb\DemoApp
		dotnet build /p:DeployOnBuild=true /p:PublishProfile=FolderProfile
	}
	Catch {
		Pop-Location
	}
	Finally{
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

task api-restore {
	Try {
		Push-LocationEX $env:TFSApi\DemoApi
		dotnet restore
	}
	Catch {
		Pop-Location
	}
	Finally{
	}
}

task publish-api {
	Try {
		Push-LocationEX $env:TFSApi\DemoApi
		dotnet build /p:DeployOnBuild=true /p:PublishProfile=FolderProfile
	}
	Catch {
		Pop-Location
	}
	Finally{
	}
}