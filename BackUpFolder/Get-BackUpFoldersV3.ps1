Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'User BackUp'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter username below:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $userName = $textBox.Text

    #Remote computer that needs to be backed up
    $src = "C:\Users\$userName"

    #Where you want the backed up files to be saved
    $dest = "C:\Users\jarellano\Desktop\UsersBackup"

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

}