Function Get-IISConfiguration {
	$iisConfiguration = New-Object PSObject -Property @{
		webSites = @()
		webApplications = @()
		virtualDirectories = @()
	}
	
	$webSites = Get-Website

	If ($webSites -ne $Null -and $webSites.length -gt 0) {
		Foreach ($webSite in $webSites) {
			$psPath = 'IIS:\Sites\' + $website.Name
			$iisConfiguration.websites += New-Object PSObject -Property @{
				Name = $website.Name
				PSPath = $psPath
				PhysicalPath = $website.physicalPath
			}			
		}
	}

	$webApplications = Get-WebApplication

	If ($webApplications -ne $Null -and $webApplications.length -gt 0) {
		Foreach ($webApplication in $webApplications) {
			$psPath = Get-PSPathFromItemXPath($webApplication.ItemXPath)
			$iisConfiguration.webApplications += New-Object PSObject -Property @{
				Name = $webApplication.Path
				PSPath = $psPath
				PhysicalPath = $webApplication.physicalPath
			}	
		}
	}

	$virtualDirectories = Get-WebVirtualDirectory

	If ($virtualDirectories -ne $Null -and $virtualDirectories.length -gt 0) {
		Foreach ($virtualDirectory in $virtualDirectories) {
			$psPath = Get-PSPathFromItemXPath($virtualDirectory.ItemXPath)
			$iisConfiguration.virtualDirectories += New-Object PSObject -Property @{
				Name = $virtualDirectory.Path
				PSPath = $psPath
				PhysicalPath = $website.physicalPath
			}
		}
	}

	Return $iisConfiguration
} 