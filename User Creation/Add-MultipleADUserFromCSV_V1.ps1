# Author: Jose Daniel Arellano
# Description: This script will automate AD user creation from a CSV file ONLY if their username does not exist yet in AD.
# Date: 7/13/2018
# Version: 1

# Import required modules
Import-Module ActiveDirectory

# Temporary Password
$securePassword = ConvertTo-SecureString "Welcome1" -AsPlainText -Force

# Prompt user for CSV path
$filepath = Read-Host -Prompt "Enter the path to your CSV file (example. C:\temp\test.csv)"

# Import file into a variable
$users = Import-Csv $filepath

# Loop through each row and gather information
ForEach ($user in $users) {
    
    # Variable
    $TextInfo = (Get-Culture).TextInfo
    $fnameArr = ($user.'First Name').ToCharArray()

    # If user has 2 LastName OR contains hyphen. 
    # Find index of the space or hyphen, then delete the first last name. Use the SECOND LastName. Ex. (Biedron-Cheema, Alicja = acheema)
    if ($user.'Last Name' -contains " ") {
        $userName_TwoLastName = 
    }
    
    $userName =  ($fnameArr[0] + $user.'Last Name').ToLower()
    
    
    $lastName = $TextInfo.ToTitleCase($user.'Last Name'.ToLower())
    $firstName = $TextInfo.ToTitleCase($user.'First Name'.ToLower())
    $expirationDate = $user.'End Date'



    try
    {
        $account = Get-ADUser $userName
    }

    catch

    {

    }

    if ($account)
    {
        
        # Without the -Append it will overwrite the existing file
        $account.SamAccountName | Out-File "C:\temp\ALREADY_EXISTS.txt" -Append
        
        
    } else {
        
        # Will add created users to a Text file
        Write-Output $userName | Out-File "C:\temp\Account_Created.txt" -Append
        
        <######## Creating User #########
        New-ADUser -Name "$lastName, $firstName" -DisplayName "$lastName, $firstName" -GivenName "$firstName" -Path "OU=USERS,OU=NURSING-STUDENTS,OU=NURSING UNITS,OU=VHC,DC=is,DC=virginiahospitalcenter,DC=com" -SamAccountName $userName -Server:"VHCSRV02.is.virginiahospitalcenter.com" -Surname "$lastName" -Type "user" -UserPrincipalName "$userName@is.virginiahospitalcenter.com"
        

        ######### Setting Temp Password #######
        Set-ADAccountPassword -Identity: $userName -NewPassword: $securePassword -Reset:$true -Server:"VHCSRV02.is.virginiahospitalcenter.com"
        

        ######### Enabling ADAccount ######### 
        Enable-ADAccount -Identity: $userName -Server:"VHCSRV02.is.virginiahospitalcenter.com"


        ######### Set Their Membership ######### 
        Add-ADPrincipalGroupMembership -Identity: $userName -MemberOf:"CN=POOL_CLINICALS_GRP,OU=VDi POOLS,OU=Groups,OU=~ Administration,OU=VHC,DC=is,DC=virginiahospitalcenter,DC=com" -Server:"VHCSRV02.is.virginiahospitalcenter.com"
        

        ######### Account Control ######### 
        Set-ADAccountControl -AccountNotDelegated:$false -AllowReversiblePasswordEncryption:$false -CannotChangePassword:$false -DoesNotRequirePreAuth:$false -Identity: $userName -PasswordNeverExpires:$false -Server:"VHCSRV02.is.virginiahospitalcenter.com" -UseDESKeyOnly:$false


        ######### Setting up user ######### 
        Set-ADUser -ChangePasswordAtLogon:$true -Identity: $userName -Server:"VHCSRV02.is.virginiahospitalcenter.com" -SmartcardLogonRequired:$false


        ######### Set account expiration ######### 
        Set-ADAccountExpiration -DateTime: "$expirationDate" -Identity: $userName -Server:"VHCSRV02.is.virginiahospitalcenter.com"

        <#
        $Params = @{
        Name = "$lastName, $firstName" 
        DisplayName = "$lastName, $firstName" 
        GivenName = "$firstName" 
        Path = "OU=USERS,OU=NURSING-STUDENTS,OU=NURSING UNITS,OU=VHC,DC=is,DC=virginiahospitalcenter,DC=com" 
        SamAccountName = $userName 
        Server = "VHCSRV02.is.virginiahospitalcenter.com" 
        Surname = "$lastName" 
        Type = "user" 
        UserPrincipalName = "$userName@is.virginiahospitalcenter.com"
        }
        New-ADUser @Params
        #>
    }
    Clear-Variable account
   
}

