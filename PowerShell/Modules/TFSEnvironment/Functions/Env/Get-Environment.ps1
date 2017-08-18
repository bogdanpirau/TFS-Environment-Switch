#
# Get_Environment.ps1
#
Function Get-Environment {
param(
	[Parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
	[string]$Name,
	[Switch]$ListOnly
)
	$result = @()

	If ([String]::IsNullOrWhiteSpace($Name)){
		$environments = $Global:Environments | Get-Member -MemberType NoteProperty | Select Name
		$environments | % { 
			$result +=  $Global:Environments."$($_.Name)"
		}
	}
	Else {
		$result += $Global:Environments."$Name"
	}
	
	If ($ListOnly.IsPresent) {
		$result | % { Write-Host $_.Name -ForegroundColor ([System.ConsoleColor]$_.Color) -BackgroundColor ([System.ConsoleColor]$_.BackgroundColor) }
	}
	Else {
		Return $result | Select Name, Color, BackgroundColor
	}
}