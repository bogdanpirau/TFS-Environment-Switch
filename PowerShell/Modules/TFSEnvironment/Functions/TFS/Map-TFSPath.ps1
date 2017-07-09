#
# Map_TFSPath.ps1
#
Function Map-TFSPath($tfsPath, $localPath) {
	$global:tfsWorkspaces = @(Get-TFSWorkspaces)
	$workspace = $global:tfsWorkspaces[0]
	
	If ($global:tfsWorkspaces.length -gt 1) {
		$workspace = Get-UserSelection -text "Please select the TFS workspace under which to map the TFS path [$tfsPath] to the local path [$localPath]" -options $global:tfsWorkspaces
	}

	Write-Host Mapping TFS path [$workspace][$tfsPath] to [$localPath] 
	tf workfold /map "$tfsPath" "$localPath" /workspace:"$workspace"

	Write-Host Downloading sources -ForegroundColor DarkCyan -NoNewLine
	$downloadedSources = tf get "$tfsPath" /recursive
	Write-Host "`rDownloading sources finshed" -ForegroundColor Cyan

	$webAppPrjPath = "$localPath\iFOREX Framework\IFOREX.Clients\iFOREX.Clients.Web\iFOREX.Clients.Web.csproj"
	If (Test-Path $webAppPrjPath) {
		$procCores = WmiObject -class win32_processor -Property "numberofcores" | select -ExpandProperty NumberOfCores
		
		Write-Host Building WebApp project [$webAppPrjPath] -ForegroundColor DarkCyan -NoNewLine
		."$msBuildPath\MSBuild.exe" $webAppPrjPath /m:$procCores /verbosity:m /clp:ErrorsOnly /nologo /t:build
		Write-Host "`rBuilding WebApp project [$webAppPrjPath] finshed" -ForegroundColor Cyan
	}
	
	$nodeUtilsPath = "$localPath\iFOREX Framework\IFOREX.Clients\iFOREX.Clients.Web\nodeUtils";
	If (Test-Path "$nodeUtilsPath") {
		Write-Host Installing npm packages -ForegroundColor DarkCyan -NoNewLine

		Try {
			Push-Location "$nodeUtilsPath"
			npm install
		}
		Catch {
			Pop-Location
		}

		Write-Host "`rInstalling npm packages finshed" -ForegroundColor Cyan
	}
}