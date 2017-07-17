split-path -parent $MyInvocation.MyCommand.Definition | Split-Path -Parent |
	New-variable PSParentPath -Force -scope global
New-variable PSScripts -value "$PSParentPath\Scripts" -Force -scope global
New-variable PSModules -value "$PSParentPath\Modules" -Force -scope global

#add folders to path
$env:Path += ";c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\"
$env:Path += ";$PSScripts\"

#add modules folder to module path
$env:PSModulePath = $env:PSModulePath + ";$PSModules\"

#import modules
Import-Module posh-git
Import-Module PsReadLine
Import-Module psake
Import-Module pscx -arg "$PSScripts\Pscx.UserPreferences.ps1"

#import custom module
Import-Module TFSEnvironment.psm1
Use-TFSEnvironment

#run all profile files
dir "$PSParentPath\Profile\*" -Include *.ps1 -Exclude profile.ps1 |% { . $_.FullName } 

#run all functions files
dir "$PSParentPath\functions\*" -Include *.ps1 |% {. $_.FullName}

#setup history
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward