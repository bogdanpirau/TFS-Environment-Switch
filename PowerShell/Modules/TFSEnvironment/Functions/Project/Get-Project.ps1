#
# Get_Project.ps1
#
Function Get-Project {
param(
	[Parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
	[string]$Name,
	[Switch]$ListOnly
)
	$result = @()

	If ([String]::IsNullOrWhiteSpace($Name)){
		$environments = $Global:Projects | Get-Member -MemberType NoteProperty | Select Name
		$environments | % { 
			$result +=  $Global:Projects."$($_.Name)"
		}
	}
	Else {
		$result += $Global:Projects."$Name"
	}
	
	If ($ListOnly.IsPresent) {
		$result | % { Write-Host $_.Name -ForegroundColor ([System.ConsoleColor]$_.Color) -BackgroundColor ([System.ConsoleColor]$_.BackgroundColor) }
	}
	Else {
		Return $result | Select Name
	}
}