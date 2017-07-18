param(
[ValidateSet('all', 'web', 'web-publish', 'api', 'api-publish')]
[string]$task='web'
)
write-host "root used=$root, time=$(Get-Date)"
$scriptLocation = split-path -parent $MyInvocation.MyCommand.Definition
Invoke-psake -buildFile "$scriptLocation\psake.tasks.ps1" -taskList $task