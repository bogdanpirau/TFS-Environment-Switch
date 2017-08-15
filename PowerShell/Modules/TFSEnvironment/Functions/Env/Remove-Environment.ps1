#
# Remove_Environment.ps1
#
Function Remove-Environment {
Param(
	[Parameter(Mandatory = $True)]
	[string]$Name
)
	If ($Global:Environments.$Name -eq $Null){
		Write-Host Environment [$Name] does not exist
		Return
	}

	Write-Host Are you sure you want to delete Environment [$Name]?
	Write-Host Type 1 or y for Yes
	Write-Host Type 2 or n for No

	$key = Read-Host

	If ($key -eq '1' -or $key -eq 'y') {
		$Global:Environments.PSObject.Properties.Remove($Name)
		Write-Host Environment [$Name] was removed.
	}
}