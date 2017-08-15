#
# Validate_Environment.ps1
#
Function Validate-Environment {
Param(
	[Parameter(Mandatory = $True)]
	[String]$Name,
	[Parameter(Mandatory = $True)]
	[System.ConsoleColor]$Color,
	[System.ConsoleColor]$BackgroundColor = $Host.UI.RawUI.BackgroundColor,
	[Switch]$IsNewEnvironment
)
	If (![String]::IsNullOrWhiteSpace($Name)) {
		$Name = $Name.Trim();
	}

	If ([String]::IsNullOrWhiteSpace($Name)) {
		Throw [System.ArgumentException] "Invalid parameter value: [$Name]", 'Name'
	}

	# TODO Add regex validators

	If ($IsNewEnvironment.IsPresent -and $Global:Environments.$Name -ne $Null) {
		Throw [System.ArgumentException] "Envitonment $Name is already defined", 'Name'
	}

	If (!$IsNewEnvironment.IsPresent -and $Global:Environments.$Name -eq $Null) {
		Throw [System.ArgumentException] "Envitonment $Name is not defined", 'Name'
	}

	If ($BackgroundColor -eq $Color){
		Throw [System.ArgumentException] "Color and background color should not be the same [$Color]. Either select a different color or specify a background color", 'BackgroundColor'
	}

	If ($Color -eq $Host.UI.RawUI.BackgroundColor -and $BackgroundColor -eq $Null) {
		Throw [System.ArgumentException] "Color has the same value as the Console Background color [$Color]. Either select a different color or specify a background color", 'BackgroundColor'
	}

	$similarEnvironments = (Get-Environment | ?{ $_.Color -eq $Color -and $_.BackgroundColor -eq $BackgroundColor })

	If (!$IsNewEnvironment.IsPresent) {
		$similarEnvironments = $similarEnvironments | ? { $_.Name -ne $Name }
	}

	If ($similarEnvironments -ne $Null) {
		Throw [System.ArgumentException] "There are other environments [$($similarEnvironments.Name)] that have the same colors. Select other color combinations", 'Color'
	}
}