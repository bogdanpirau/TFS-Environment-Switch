Function Get-TFSEnvironment {
	$envFileDefined = (Get-Content "$tfsEnvFile" -ErrorAction Ignore) -match "'(.*)'"
	$currentTFSEnv = $Matches[1]

	Return $currentTFSEnv
}