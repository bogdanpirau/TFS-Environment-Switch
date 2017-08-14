#
# Get_TFSBranchIerachyTree.ps1
#
Function Get-TFSBranchIerachyTree {
param(
[string]$TfsUrl = (Get-TFSCollection),
[string]$BranchTFSPath
)
	[PSObject] $tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($TfsUrl)
	$vcs = $tfs.GetService([type]"Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer")
	
	$branch = $BranchTFSPath

	While (($parentBranch = Get-TFSBranchParent -TfsUrl $TfsUrl -BranchTFSPath $branch) -ne $Null) {
		$branch = $parentBranch
	}

	Return Get-TFSBranchChildren -TfsUrl $TfsUrl -BranchTFSPath $branch -IncludeSpecifiedBranch
}