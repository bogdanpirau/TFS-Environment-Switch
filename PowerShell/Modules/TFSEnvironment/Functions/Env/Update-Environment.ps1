#
# Update_Environment.ps1
#
Function Update-Environment {
Param(
	[Parameter(Mandatory = $True)]
	[String]$Name,
	[Parameter(Mandatory = $True)]
	[System.ConsoleColor]$Color,
	[System.ConsoleColor]$BackgroundColor = $Host.UI.RawUI.BackgroundColor
)
	Validate-Environment @PSBoundParameters

	$Global:Environments | Add-Member -Force -Type NoteProperty -Name $Name -Value (New-Object PSObject -Property @{
		Name = $Name;
		Color = $Color;
		BackgroundColor = $BackgroundColor;
	})
}