#
# Update_PSCustomObject.ps1
#
Update-TypeData -TypeName System.Management.Automation.PSCustomObject `
    -MemberType ScriptMethod `
    -MemberName ToHashTable `
    -Value { 
		$hash = @{}
		$this.psobject.properties | % { $hash[$_.Name] = $_.Value }

		Return $hash
	}
	