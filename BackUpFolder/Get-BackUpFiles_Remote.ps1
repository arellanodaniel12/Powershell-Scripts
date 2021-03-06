Write-Host "`n`n--------------- BACK UP FILE SCRIPT ---------------`n`n"

$ComputerName = Read-Host "Enter computer name"
$userName = Read-Host "Enter username"

$src = "\\$ComputerName\c$\Users\$userName"
$dest = "\\vfileall_dept\is_share`$\helpdesk\@User Profiles\"

$Desktop = "$src\Desktop\"
$Favorites = "$src\Favorites\"
$Outlook = "$src\AppData\Roaming\Microsoft\Outlook\"
$Proof = "$src\AppData\Roaming\Microsoft\Proof\"
$Signatures = "$src\AppData\Roaming\Microsoft\Signatures\"

New-Item -Path "$dest\$userName" -ItemType directory

Copy-Item "$Desktop" -Destination "$dest\$userName\Desktop" -Recurse
Copy-Item "$Favorites" -Destination "$dest\$userName\Favorites" -Recurse
Copy-Item "$Outlook" -Destination "$dest\$userName\Outlook" -Recurse
Copy-Item "$Proof" -Destination "$dest\$userName\Proof" -Recurse
Copy-Item "$Signatures" -Destination "$dest\$userName\Signatures" -Recurse


    


