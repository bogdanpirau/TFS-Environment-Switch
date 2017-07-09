Function Get-PSPathFromItemXPath($itemXpath)
{
    $result = 'IIS:\Sites\'
 
    $tempString = $itemXPath.substring($itemXPath.IndexOf("@name"))   
    $result += $tempString.Split("'")[1]

    $tempString = $itemXPath.substring($itemXPath.IndexOf("application[@path"))
	$applicationName = $tempString.Split("'")[1]
	If ($applicationName -ne '/') {
		$result += $applicationName
	}
    
	$virtualDirectoryIndex = $itemXPath.IndexOf("virtualDirectory[@path");
	If ($virtualDirectoryIndex -ge 0) {
		$tempString = $itemXPath.substring($virtualDirectoryIndex)
		$virtualDirName = $tempString.Split("'")[1]
		If ($virtualDirName -ne '/') {
			$result += $virtualDirName
		}
	}

	return $result
}