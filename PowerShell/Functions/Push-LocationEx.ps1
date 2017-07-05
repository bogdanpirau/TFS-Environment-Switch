function global:Push-LocationEx{
param(
[string]$path,
[string]$literalPath,
[string]$stackName,
[switch]$passThru, 
[switch]$UseTransaction
)
	$result = Push-Location @PSBoundParameters
	
	Write-Host "Working in [$(Get-Location)]" -ForegroundColor DarkGray
	
	Return $result
}
New-Alias -Scope global -Name pushdx -Value Push-LocationEx -Force