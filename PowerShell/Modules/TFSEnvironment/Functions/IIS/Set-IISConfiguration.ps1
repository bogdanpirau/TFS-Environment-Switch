Function Set-IISConfiguration {
	$iisConfiguration = Get-IISConfiguration
	
	If($iisConfiguration.webSites -ne $Null -and $iisConfiguration.webSites.length -gt 0){
		Foreach ($website in $iisConfiguration.websites){
			Set-ItemProperty $website.PSPath -Name physicalPath -Value 
		}
	}

	If($iisConfiguration.webApplications -ne $Null -and $iisConfiguration.webApplications.length -gt 0){
		Foreach ($webApplication in $iisConfiguration.webApplications){
			Set-ItemProperty $webApplication.PSPath -Name physicalPath -Value 
		}
	}

	If($iisConfiguration.virtualDirectories -ne $Null -and $iisConfiguration.virtualDirectories.length -gt 0){
	Foreach ($virtualDirectory in $iisConfiguration.virtualDirectories){
			Set-ItemProperty $virtualDirectory.PSPath -Name physicalPath -Value 
		}
	}
}