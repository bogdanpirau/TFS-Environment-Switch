#
# Get_TFSWorkspaces.ps1
#
Function Get-TFSWorkspaces {
	#Return tf workspaces /format:brief | ?{ $_ -notMatch '^Collection:|^Workspace |^----' } | %{ $isMatch = $_ -Match "(.*)\s*($env:UserFullName).*"; Return $Matches[1].Trim() }
	$isMatch = ((tf workspaces) -match '^Collection:\s(.*)')[0] -match '^Collection:\s(.*)'
	$collection = $Matches[1]

	return ([xml](tf workspaces /format:xml /collection:$collection)).Workspaces.Workspace.name
}