function Prompt-FolderPath{
param
(
	[string]$DisplayText = 'Select Folder'
)
	$folder = $Null

	While (($folder -eq $Null) -or !(Test-Path $folder)) {
		$formsAssembly = [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
		
		$folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
		$folderBrowserDialog.Description = $DisplayText
		$folderBrowserDialog.RootFolder = "MyComputer"

		If ($folderBrowserDialog.ShowDialog() -eq "OK")
		{
			$folder = $folderBrowserDialog.SelectedPath
		}
		Else {
			If ([System.Windows.Forms.MessageBox]::Show('Are you sure you want to quit setting up your environment?',"$DisplayText", 'YesNo', 'Error') -eq "Yes") {
				throw [System.InvalidOperationException] "Environment configuration aborted"
			}
		}
	}
	
	Return $folder
}