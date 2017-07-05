properties {
	$my_property = $p1 + $p2
	$x = $null
	$y = $null
	$z = $null
}

task default -depends TestParams, TestProperties

task TestParams {
	Assert ($my_property -ne $null) '$my_property should not be null'
}

task TestProperties {
    Assert ($x -ne $null) "x should not be null"
    Assert ($y -ne $null) "y should not be null"
    Assert ($z -eq $null) "z should be null"
}

task web {
	Try {
		Push-LocationEX $demo_Web
		dotnet build
	}
	Catch {
		Pop-Location
	}
}

task web-publish {
	Try {
		Push-LocationEX $demo_Web
		dotnet build /p:DeployOnBuild=true /p:PublishProfile=FolderProfile
	}
	Catch {
		Pop-Location
	}
}

task api {
	Try {
		Push-LocationEX $demo_Api
		dotnet build
	}
	Catch {
		Pop-Location
	}
}

task api-publish {
	Try {
		Push-LocationEX $demo_Api
		dotnet build /p:DeployOnBuild=true /p:PublishProfile=FolderProfile
	}
	Catch {
		Pop-Location
	}
}