#
# Import_Environment.ps1
#
Function Import-Environment {
Param(
	[Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
	[string]$Path,
	[Switch]$Force
)
	If (!(Test-Path $Path)) {
		Throw [System.ArgumentException] "The specified file [$Path] does not exist."
	}

	$environments = Get-Content -Raw $Path | ConvertFrom-Json

	$existingEnvironments = $environments | ? { (Get-Environment $_.Name) -ne $Null } | Select -ExpandProperty Name

	if ($existingEnvironments -ne $Null -and !$Force.IsPresent) {
		Throw [System.InvalidOperationException] "Environments [$existingEnvironments] already exist. Use -Force to override them with the ones from the file."
	}

	$environments | % { $_ | New-Environment -Force }
}