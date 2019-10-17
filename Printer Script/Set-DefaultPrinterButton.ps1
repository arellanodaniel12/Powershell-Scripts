<# 
Author: Jose Daniel Arellano
Description: Place in Startup folder. This will prompt user for their location if they logon. Once chosen, it will set the right default printer for the right location.
#>

Function Main_Click {
    
    <#Change Default Printer#>
    (New-Object -ComObject WScript.Network).SetDefaultPrinter("B-ACCS-01-06");
    $Form.Close()

}

Function Shirl_Click {

   (New-Object -ComObject WScript.Network).SetDefaultPrinter("B-PS15-04-03");
   $Form.Close()

}


Function Generate-Form {

    Add-Type -AssemblyName System.Windows.Forms    
    Add-Type -AssemblyName System.Drawing
    
    # Build Form
    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "Default printer"
    $Form.Size = New-Object System.Drawing.Size(300,150)
    $Form.StartPosition = "CenterScreen"
    $Form.Topmost = $True

    # Add Label
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Where are you working today?'
    $form.Controls.Add($label)

    # Add Button
    $Button = New-Object System.Windows.Forms.Button
    $Button.Location = New-Object System.Drawing.Size(10,50)
    $Button.Size = New-Object System.Drawing.Size(120,23)
    $Button.Text = "Main"
    

    # Add Button
    $Button1 = New-Object System.Windows.Forms.Button
    $Button1.Location = New-Object System.Drawing.Size(150,50)
    $Button1.Size = New-Object System.Drawing.Size(120,23)
    $Button1.Text = "Shirlington"

    
    $Form.Controls.Add($Button1)
    $Form.Controls.Add($Button)

     #Add Button event 
    $Button.Add_Click({Main_Click})
    $Button1.Add_Click({Shirl_Click})

    $form.Topmost = $true


    #Show the Form 
    $result = $form.ShowDialog()

 
} #End Function 
 
#Call the Function 
Generate-Form

