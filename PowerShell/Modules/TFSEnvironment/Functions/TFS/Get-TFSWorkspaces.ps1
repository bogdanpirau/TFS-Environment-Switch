#
# Get_TFSWorkspaces.ps1
#
Function Get-TFSWorkspaces {
	$collection = Get-TFSCollection

	return ([xml](tf workspaces /format:xml /collection:$collection)).Workspaces.Workspace.name
}