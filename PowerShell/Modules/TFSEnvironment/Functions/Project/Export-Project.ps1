#
# Export_Project.ps1
#
Function Export-Project {
Param(
	[Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
	[string]$Path,
	[Parameter(ValueFromPipelineByPropertyName = $True)]
	[string]$Name,
	[Switch]$Force
)
	If (!$Force.IsPresent -and (Test-Path $Path)) {
		Throw [System.InvalidOperationException] "The file [$Path] already exist. Use -Force to override it."
	}

	Get-Project $Name | ConvertTo-Json | Set-Content $Path -Force
}