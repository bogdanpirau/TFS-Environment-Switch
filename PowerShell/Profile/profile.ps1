split-path -parent $MyInvocation.MyCommand.Definition | Split-Path -Parent |
	New-variable PSParentPath -Force -scope global
New-variable PSScripts -value "$PSParentPath\Scripts" -Force -scope global
New-variable PSModules -value "$PSParentPath\Modules" -Force -scope global

Import-Module "$PSModules\PsReadLine\PsReadLine.psm1"
Import-Module "$PSModules\psake\psake.psm1"

#add scripts to path
$env:Path += ";$PSScripts\"

$demo_api = "$PSParentPath\..\TFSDemo\Dev-WebAPI\DemoAPI\DemoAPI"
$demo_web = "$PSParentPath\..\TFSDemo\Dev-WebApp\DemoApp\DemoApp"

#run all profile files
dir "$PSParentPath\*" -Include *.ps1 -Exclude profile.ps1 |% {. $_.FullName} 

#run all functions files
dir "$PSParentPath\functions\*" -Include *.ps1 |% {. $_.FullName}

