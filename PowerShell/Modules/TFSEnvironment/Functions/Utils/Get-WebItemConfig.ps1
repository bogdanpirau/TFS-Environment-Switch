#
# Get_WebItemConfig.ps1
#
Function Get-WebItemConfig {
	param
	( 
		$webItem
	)

	$physicalPath = Replace-PhysicalPathWithDevBranchPath($webItem.physicalPath)

	If ($physicalPath -notlike '$*') {
		Return ''
	}

	Return "`$global:iisTFSConfigurations += New-Object PSObject -Property @{
Name = '$($webItem.Name)'
PSPath = '$($webItem.PSPath)'
PhysicalPath = '$physicalPath'
}" + [System.Environment]::NewLine
}
