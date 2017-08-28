#
# New_Environment.ps1
#
Function New-Environment {
Param(
	[Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
	[String]$Name,
	[Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
	[bool]$ShowOnlyInFolder,
	[Switch]$Force
)
	Validate-Environment @PSBoundParameters

	$Global:Projects | Add-Member -Force -Type NoteProperty -Name $Name -Value (New-Object PSObject -Property ([ordered]@{
		Name = $Name;
		Color = $Color;
		BackgroundColor = $BackgroundColor;
	}))
}