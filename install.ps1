#Requires -Version 3.0 -Modules WebAdministration -RunAsAdministrator

#0 download files
#ask for download location
$parentFolderLocation = 
#clone git repo there

Write-Host 'Importing-Module WebAdministration'
Import-Module WebAdministration

Push-Location IIS:

#1 create the web api Application Pool



#2 create the web app Application Pool



#3 create the web api Web Site



#4 create the web app Web Site



#5 update the hosts file

#6 add the profile.ps1 file to the windows PowerShell Profile file

Pop-Location

Function New-WebSite {
}

Function New-WebApplicationPool {
}

Function Get-CustomFolder {
	Add-Type -AssemblyName System.Windows.Forms
 
	$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
		SelectedPath = 'C:\Temp'
	}
 
	[void]$FolderBrowser.ShowDialog()
	Return $FolderBrowser.SelectedPath
}