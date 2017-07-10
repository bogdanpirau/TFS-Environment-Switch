split-path -parent $MyInvocation.MyCommand.Definition | Split-Path -Parent |
	New-variable PSParentPath -Force -scope global
New-variable PSScripts -value "$PSParentPath\Scripts" -Force -scope global
New-variable PSModules -value "$PSParentPath\Modules" -Force -scope global

Import-Module "$PSModules\PsReadLine\PsReadLine.psm1"
Import-Module "$PSModules\psake\psake.psm1"


#add scripts to path
$env:Path += ";$PSScripts\"
$env:Path += ";c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\"

Import-Module d:\Projects\git\TFS-Environment-Switch\PowerShell\Modules\TFSEnvironment\TFSEnvironment.psm1
Use-TFSEnvironment

#run all profile files
dir "$PSParentPath\Profile\*" -Include *.ps1 -Exclude profile.ps1 |% {. $_.FullName} 

#run all functions files
dir "$PSParentPath\functions\*" -Include *.ps1 |% {. $_.FullName}

