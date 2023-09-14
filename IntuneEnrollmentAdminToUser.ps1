[CmdletBinding()]
Param(
    [string]$UserName = (Get-WmiObject -Class Win32_ComputerSystem).UserName
)
Begin{
    # Verify that the script is running with administrative privileges
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "This script must be run as an Administrator. Please re-run this script as an Administrator."
        exit
    }
}
Process
{
    try {
        if (net localgroup administrators | Select-String $UserName -SimpleMatch){
            $confirmation = Read-Host "Are you sure you want to remove $UserName from the Administrators group? (yes/no)"
            if ($confirmation -eq 'yes') {
                net localgroup administrators $($UserName) /delete 
                Write-Host "$UserName has been removed from the Administrators group."
            } else {
                Write-Host "Operation cancelled."
            }
        }
        else{
            Write-Host "$UserName is not a member of the Administrators group."
        }
    } catch {
        Write-Host "An error occurred: $_"
    }
}
End{
    Write-Host "Script execution completed."
}
