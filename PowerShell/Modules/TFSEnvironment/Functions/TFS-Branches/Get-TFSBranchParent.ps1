#
# Get_TFSBranchParent.ps1
#
Function Get-TFSBranchParent {
param(
[string]$TfsUrl = (Get-TFSCollection),
[string]$BranchTFSPath
)
	[psobject] $tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($TfsUrl)
	$vcs = $tfs.GetService([type]"Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer")
	$branch = $vcs.QueryBranchObjects($BranchTFSPath, 'None')

	Return $branch.Properties.ParentBranch.Item #| % { $_.Properties.RootItem.Item }
}