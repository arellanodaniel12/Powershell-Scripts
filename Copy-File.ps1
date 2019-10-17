cls

Write-Host "`n`n----------------------------------   READ ME   ----------------------------------
            `n1. Only use when files cannot be push through GPO Group Policy Preferences.
            `n2. This script is getting computer name list from C:\temp\ComputerOR.txt"

Write-Host "`n3. DO NOT PUT QUOTES ON THE LOCATION PATH" -Foreground Red

Write-Host "`nExample:`n     Enter path of the file you want to copy: C:\temp\Synapse Viewer.url" -Foreground DarkGreen -Background White
Write-Host "     Enter destination path: \Users\Public\Desktop`n`n" -Foreground DarkGreen -Background White


$src = Read-Host -Prompt "Enter path of the file you want to copy " 
$dest = Read-Host -Prompt "`nEnter destination path (ex. \temp) "

foreach($PC in Get-Content C:\Temp\ComputerOR.txt) {

    Copy-Item -Path "$src" -Destination "\\$PC\c$\$dest" -Force -Recurse
}