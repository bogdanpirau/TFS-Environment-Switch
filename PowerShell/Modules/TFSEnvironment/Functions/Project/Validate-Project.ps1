#
# Validate_Environment.ps1
#
Function Validate-Environment {
Param(
	[Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
	[String]$Name,
	[Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
	[System.ConsoleColor]$Color,
	[Parameter(ValueFromPipelineByPropertyName = $True)]
	[System.ConsoleColor]$BackgroundColor = $Host.UI.RawUI.BackgroundColor,
	[Switch]$Force
)
	If (![String]::IsNullOrWhiteSpace($Name)) {
		$Name = $Name.Trim();
	}

	If ([String]::IsNullOrWhiteSpace($Name)) {
		Throw [System.ArgumentException] "Invalid parameter value: [$Name]", 'Name'
	}

	# TODO Add regex validators

	If (!$Force.IsPresent -and $Global:Projects.$Name -ne $Null) {
		Throw [System.ArgumentException] "Envitonment [$Name] is already defined. Use -Force to override it or provide a different name.", 'Name'
	}

	If ($BackgroundColor -eq $Color){
		Throw [System.ArgumentException] "Color and background color should not be the same [$Color]. Either select a different color or specify a background color", 'BackgroundColor'
	}

	If ($Color -eq $Host.UI.RawUI.BackgroundColor -and $BackgroundColor -eq $Null) {
		Throw [System.ArgumentException] "Color has the same value as the Console Background color [$Color]. Either select a different color or specify a background color", 'BackgroundColor'
	}

	$similarEnvironments = Get-Environment | ? { $_.Color -eq $Color -and $_.BackgroundColor -eq $BackgroundColor -and $_.Name -ne $Name } | Select -ExpandProperty Name

	If ($similarEnvironments -ne $Null) {
		Throw [System.ArgumentException] "There are other environments [$similarEnvironments] that have the same colors. Select other color combinations", 'Color'
	}
}