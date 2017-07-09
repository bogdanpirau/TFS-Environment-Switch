function global:prompt {
	$realLASTEXITCODE = $LASTEXITCODE

	Try {
		If ($global:UseTFSEnvironment) {
			$currentTFSEnv = Get-TFSEnvironment

			If ($currentTFSEnv -ne $tfsEnv){
				Write-Host "The TFS Ex$currentTFSEnv -- vs -- $tfsEnv" 
				. "$profile"
			}

			$tfsEnvProperties = $TFSEnvironments."$tfsEnv"

			$Host.UI.RawUI.WindowTitle = $pwd.Path + ' [#' + $TFSEnvProperties.Name + ']'
		}
		Else {
			$Host.UI.RawUI.WindowTitle = $pwd.Path
		}
	}
	Catch {
	}

	Write-Host ($pwd.Path) -ForegroundColor DarkGray -NoNewline

	Try {
		If ($global:UseTFSEnvironment) {
			Write-Host " [#$($tfsEnvProperties.Name)]" -ForegroundColor $tfsEnvProperties.Color -NoNewline
		}
	}
	Catch {
	}

	Write-VcsStatus

	$global:LASTEXITCODE = $realLASTEXITCODE

	Write-Host '>' -ForegroundColor DarkGray -NoNewline

	return ' '
}
