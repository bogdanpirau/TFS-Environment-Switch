$global:tfsMappedFolders = @()
$global:tfsWorkspaces = @()

# Import everything
Get-ChildItem -Recurse -Path "$PSScriptRoot\Functions\*.ps1" | % { . $_.FullName }

Export-ModuleMember -Function Set-TFSEnvironment
Export-ModuleMember -Function Get-TFSEnvironment
Export-ModuleMember -Function Use-TFSEnvironment
Export-ModuleMember -Function Enable-TFSEnvironment
Export-ModuleMember -Function Disable-TFSEnvironment

# TFS Branches utility functions

$TFSAssembliesPath = "C:\Program Files\Common Files\Microsoft Shared\Team Foundation Server\14.0"

If (Test-Path $TFSAssembliesPath) {
	#move to a separate TFS module
	[void][System.Reflection.Assembly]::LoadFrom("$TFSAssembliesPath\Microsoft.TeamFoundation.Client.dll")
	[void][System.Reflection.Assembly]::LoadFrom("$TFSAssembliesPath\Microsoft.TeamFoundation.Common.dll")
	[void][System.Reflection.Assembly]::LoadFrom("$TFSAssembliesPath\Microsoft.TeamFoundation.WorkItemTracking.Client.dll")
	[void][System.Reflection.Assembly]::LoadFrom("$TFSAssembliesPath\Microsoft.TeamFoundation.VersionControl.Client.dll")
	[void][System.Reflection.Assembly]::LoadFrom("$TFSAssembliesPath\Microsoft.TeamFoundation.VersionControl.Client.dll")

	Export-ModuleMember -Function Get-TFSBranchChildren
	Export-ModuleMember -Function Get-TFSBranches
	Export-ModuleMember -Function Get-TFSBranchIerachyTree
	Export-ModuleMember -Function Get-TFSBranchParent
}

# Export-ModuleMember -Function *-*