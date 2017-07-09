#
# Update_IISPaths.ps1
#
Function Set-CursorPosition ([int]$x,[int]$y) { 
	# Get current cursor position and store away 
	$position=$host.ui.rawui.cursorposition 
	# Store new X Co-ordinate away 
	$position.x=$x
	$position.y=$y
	# Place modified location back to $HOST 
	$host.ui.rawui.cursorposition=$position 
}

Function Update-IISPaths {
	$webItems = $global:iisTFSConfigurations

	If ($webItems -eq $null -or $webItems.length -eq 0) {
		Write-Host "No configiration saved in $tfsEnvIISConfigurationFile" -ForegroundColor Red
		Return
	}

    Import-Module WebAdministration

	$sw = [Diagnostics.Stopwatch]::StartNew()
	$initialCursorPosition = $host.ui.rawui.cursorposition
	Write-Host 'Updating IIS Configuration' -ForegroundColor DarkCyan

	Foreach ($webItem in $webItems) {
		Write-Host Executing "Set-ItemProperty '$($webItem.PspATH)' -Name physicalPath -Value '$($ExecutionContext.InvokeCommand.ExpandString($webItem.PhysicalPath))'"
		Set-ItemProperty "$($webItem.PspATH)" -Name physicalPath -Value "$($ExecutionContext.InvokeCommand.ExpandString($webItem.PhysicalPath))"
	}
	
	$finalCursorPosition = $host.ui.rawui.cursorposition

	Set-CursorPosition -x $initialCursorPosition.x -y $initialCursorPosition.y
	$sw.Stop()
	Write-Host "Updating IIS Configuration finished in [$($sw.Elapsed)]" -ForegroundColor Cyan
	Set-CursorPosition -x $finalCursorPosition.x -y $finalCursorPosition.y
}