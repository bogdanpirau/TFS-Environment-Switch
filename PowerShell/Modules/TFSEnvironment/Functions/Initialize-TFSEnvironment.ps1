Function Initialize-TFSEnvironment {
	Set-TFSEnvIISConfigurationFileContent
	Set-TFSEnvFileContent 'Dev'
	Set-TFSEnvPathsFileContent -DevApi $env:TFSApi -DevApp $env:TFSWeb

	Use-TFSEnvironment

	Write-Host "Web Api: $env:TFSApi" -ForegroundColor DarkCyan
	Write-Host "Web App: $env:TFSWeb" -ForegroundColor DarkCyan
}