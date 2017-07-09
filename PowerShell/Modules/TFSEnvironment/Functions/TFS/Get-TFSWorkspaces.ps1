#
# Get_TFSWorkspaces.ps1
#
Function Get-TFSWorkspaces {
	Return tf workspaces /format:brief | ?{ $_ -notMatch '^Collection:|^Workspace |^----' } | %{ $isMatch = $_ -Match "(.*)\s*($env:UserFullName).*"; Return $Matches[1].Trim() }
}