#
# New_Environment.ps1
#
Function New-Environment{
Param(
	[Parameter(Mandatory = $True)]
	[String]$Name,
	[Parameter(Mandatory = $True)]
	[System.ConsoleColor]$Color,
	[System.ConsoleColor]$BackgroundColor = $Host.UI.RawUI.BackgroundColor
)
	Validate-Environment @PSBoundParameters -IsNewEnvironment

	$Global:Environments | Add-Member -Type NoteProperty -Name $Name -Value (New-Object PSObject -Property @{
		Name = $Name;
		Color = $Color;
		BackgroundColor = $BackgroundColor;
	})
}