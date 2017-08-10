#
# Get_TFSBranchChildren.ps1
#
Function Get-TFSBranchChildren {
param(
[string]$TfsUrl = (Get-TfsCollection),
[string]$BranchTFSPath,
[switch]$IncludeDeletedBranches,
[switch]$IncludeSpecifiedBranch
)
	[psobject] $tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($TfsUrl)
	$vcs = $tfs.GetService([type]"Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer")
	$branches = $vcs.QueryBranchObjects($BranchTFSPath, 'Full')

	If (!$IncludeDeletedBranches.IsPresent) {
		$branches = $branches | ?{ ($_.Properties.RootItem.ChangeType -band [Microsoft.TeamFoundation.VersionControl.Client.ChangeType]::Delete) -eq 0 }
	}

	If ($IncludeSpecifiedBranch.IsPresent) {
		Return $branches | % { $_.Properties.RootItem.Item }
	}
	
	Return $branches | ? { $_.Properties.RootItem.Item -ne $BranchTFSPath } | % { $_.Properties.RootItem.Item }
}