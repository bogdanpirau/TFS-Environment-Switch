#
# New_Environment.ps1
#
Function New-Environment {
Param(
	[Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
	[String]$Name,
	[Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
	[System.ConsoleColor]$Color,
	[Parameter(ValueFromPipelineByPropertyName = $True)]
	[System.ConsoleColor]$BackgroundColor = $Host.UI.RawUI.BackgroundColor,
	[Switch]$Force
)
	Validate-Environment @PSBoundParameters

	$Global:Environments | Add-Member -Force -Type NoteProperty -Name $Name -Value (New-Object PSObject -Property ([ordered]@{
		Name = $Name;
		Color = $Color;
		BackgroundColor = $BackgroundColor;
	}))
}