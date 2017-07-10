#
# Replace_PhysicalPathWithDevBranchPath.ps1
#
Function Replace-PhysicalPathWithDevBranchPath {
param
( 
	[Parameter(Mandatory=$true)]
	[string]$PhysicalPath
)

	If ($PhysicalPath -like "$($env:TFSApi)*"){
		$PhysicalPath = $PhysicalPath -ireplace $env:TFSApi.Replace('\', '\\'), '$env:TFSApi'
	}

	If ($PhysicalPath -like "$($env:TFSWeb)*"){
		$PhysicalPath = $PhysicalPath -ireplace $env:TFSWeb.Replace('\', '\\'), '$env:TFSWeb'
	}
	
	Return $PhysicalPath
}