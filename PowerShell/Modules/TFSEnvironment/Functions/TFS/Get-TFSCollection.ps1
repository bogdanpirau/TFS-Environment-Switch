#
# Get_TFSCollection.ps1
#
Function Get-TFSCollection {
	$isMatch = ((tf workspaces) -match '^Collection:\s(.*)')[0] -match '^Collection:\s(.*)'
	Return $Matches[1]
}