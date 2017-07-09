#
# Map_TFSEnvLocalPath.ps1
#
Function Map-TFSEnvLocalPath {
param
(
	[string]$TFSEnvName,
	[string]$BranchName
)
	If ($global:tfsMappedFolders -eq $null -or $global:tfsMappedFolders.Length -eq 0) {
		$global:tfsMappedFolders = Get-TfsMappings
	}

	$tfsPath = $TFSEnvironments.$TFSEnvName.Branches.$BranchName.TFSPath;

	If ($global:tfsMappedFolders.$tfsPath -ne $null -and $global:tfsMappedFolders.$tfspath.length -eq 1) {
		$localPath = $global:tfsMappedFolders.$tfsPath.Path
	
		Return $localPath
	}
	 
	If ($global:tfsMappedFolders.$tfsPath.lenght -gt 1) {
		$mappedPaths = $global:tfsMappedFolders['$/TFS Demo/Dev-WebAPI'] | %{ $_.Path + ' -> Workspace: [' + $_.Workspace + ']' }
		$selectedOption = Get-UserSelection -text "Please select the default local path that you want to use for this TFS path [$tfsPath]" -options @($mappedPaths)
		$isMatch = $selectedOption -Match '(.*)\s+-> Workspace.*'
		$localPath = $Matches[1].Trim()

		Return $localPath
	}

	If (($global:tfsMappedFolders.$tfsPath -eq $Null) -or ($global:tfsMappedFolders.$tfsPath.length -eq 0)) {
		$localPathFolderName = [System.IO.Path]::GetFileName($tfsPath)
		$localPath = Prompt-FolderPath "Map TFS folder [$tfsPath] to a local folder (select it's parent). The TFS folder will be downloaded there, in a new folder called [$localPathFolderName]"
		$localPath = Join-Path $localPath $localPathFolderName

		Map-TFSPath -tfsPath $tfsPath -localPath $localPath
		$global:tfsMappedFolders = Get-TfsMappings

		Return $localPath
	}
}