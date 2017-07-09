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
		$PhysicalPath = $PhysicalPath.Replace($env:TFSApi, '$($env:TFSApi)')
	}

	If ($PhysicalPath -like "$($env:TFSWeb)*"){
		$PhysicalPath = $PhysicalPath.Replace($env:TFSWeb, '$($env:TFSWeb)')
	}
	
	Return $PhysicalPath
}