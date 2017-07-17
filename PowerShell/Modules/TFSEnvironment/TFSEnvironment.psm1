$global:tfsMappedFolders = @()
$global:tfsWorkspaces = @()

# Import everything
Get-ChildItem -Recurse -Path "$PSScriptRoot\Functions\*.ps1" | % { . $_.FullName }

Export-ModuleMember -Function Set-TFSEnvironment
Export-ModuleMember -Function Get-TFSEnvironment
Export-ModuleMember -Function Use-TFSEnvironment
Export-ModuleMember -Function Enable-TFSEnvironment
Export-ModuleMember -Function Disable-TFSEnvironment
# Export-ModuleMember -Function *-*