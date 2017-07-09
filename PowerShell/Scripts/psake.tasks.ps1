properties {
}

task web {
	Try {
		Push-LocationEX $env:TFSWeb
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
		Push-LocationEX $env:TFSWeb
		iisreset /stop
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
		Push-LocationEX $env:TFSApi
		dotnet build
	}
	Catch {
		Pop-Location
	}
}

task api-publish {
	Try {
		Push-LocationEX $env:TFSApi
		iisreset /stop
		dotnet build /p:DeployOnBuild=true /p:PublishProfile=FolderProfile
	}
	Catch {
		Pop-Location
	}
	Finally{
		iisreset /start
	}
}