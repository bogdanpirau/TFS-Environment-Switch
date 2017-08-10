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
}