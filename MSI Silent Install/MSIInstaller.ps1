Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Welcome screen
Write-Host 
"
 -----------------------------------------------------------------------
 --------------------- MSI Silent Installer Script ---------------------
 -----------------------------------------------------------------------
 `n"

 Write-Host "- ONLY use this script if there is a problem with SCCM"
 Write-Host "- This script does not work for all msi package.`n`n"

# Prompt user for the computer name
$pc = Read-Host -Prompt "Enter computer name"
$isPConline = Test-Connection -ComputerName $pc -Count 1 -Quiet

if ($isPConline -eq $false) {
    Write-Host "`nDevice not online. Please check connection or firewall and launch script again.`n" -ForegroundColor Red
} else {
    Write-Host "MSI package location" 

    # Dialog box to open MSI installer
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = [Environment]::GetFolderPath('Desktop')
        Filter = 'MSI Package (*.msi)|*.msi|Executable (*.exe)|*.exe'
    }
    $null = $FileBrowser.ShowDialog()
    $installerLocation = $FileBrowser.FileName
    $filename = $FileBrowser.SafeFileName

    # Copying the installer to local
    Copy-Item -Path $installerLocation -Destination \\$pc\c$\temp\
    Copy-Item -Path '\\dc01is007\c$\PsExec.exe' -Destination C:\

    <#
    if (-Not (Test-Path C:\temp\PsExec.exe)) {
        $copyPsExec = Read-Host "It seems like your PsExec file is not on Directory C:\. Type y to copy PsExec"
    } else {
    
    }
    #>

    # Remoting through PsExec and installing using msexec. Not using powershell cmdlets since most computer does not have powershell service. 
    C:\PsExec.exe \\$pc msiexec /i C:\temp\$filename /qn /quiet /log C:\temp\install.log
}

$result = Read-Host "Hit Enter to exit"