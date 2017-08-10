#
# Get_TFSBranches.ps1
#
Function Get-TFSBranches {
param(
[string]$TfsUrl = (Get-TFSCollection),
[switch]$IncludeDeletedBranches
)
	[psobject] $tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($TfsUrl)
	$vcs = $tfs.GetService([type]"Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer")
	$rootBranches = $vcs.QueryRootBranchObjects('OneLevel')

	$branches = $rootBranches | % { $_.Properties.RootItem.Item } | %{ $vcs.QueryBranchObjects($_, 'Full') } 

	If (!$IncludeDeletedBranches.IsPresent) {
		$branches = $branches | ?{ ($_.Properties.RootItem.ChangeType -band [Microsoft.TeamFoundation.VersionControl.Client.ChangeType]::Delete) -eq 0 }
	}

	Return $branches | % { $_.Properties.RootItem.Item }
}