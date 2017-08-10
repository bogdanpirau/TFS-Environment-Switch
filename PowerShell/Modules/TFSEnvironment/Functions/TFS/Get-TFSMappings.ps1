#
# Get-TFSMappings.ps1
#
Function Get-TFSMappings {
	$workspaces = @(Get-TFSWorkspaces)

	If ($workspaces[0] -eq $Null){
		Return $Null
	}

	$mappings = @{};
	Foreach ($workspace in $workspaces) {
		$workfolds = tf workfold /workspace:"$workspace" | ?{ $_ -Match "^ \$.*" } | %{ $isMatch = $_ -Match "^ (\$.*): (.*)"; Return @{ TFPath = $Matches[1]; Path = $Matches[2]; Workspace = $workspace; } }

		If ($workfolds -eq $Null -or $workfolds.length -eq 0) {
			Continue
		}

		Foreach ($workfold in $workfolds) {
			If ($mappings.ContainsKey($workfold.TFPath)){
				$mappings[$workfold.TFPath] += $workfold
			}
			Else {
				$mappings.Add($workfold.TFPath, @($workfold))
			}
		}
	}

	Return $mappings
}