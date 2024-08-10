[CmdletBinding()]
Param(
    [string]$UserName
)

Begin {
    # Verify that the script is running with administrative privileges
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "This script must be run as an Administrator. Please re-run this script as an Administrator."
        return
    }

    # Ensure that the script is being run on an appropriate version of PowerShell
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-Host "This script requires PowerShell 5.0 or later. Please update your PowerShell version."
        return
    }

    # If the UserName parameter is not provided, default to the current user
    if (-not $UserName) {
        try {
            $UserName = (Get-CimInstance -ClassName Win32_ComputerSystem).UserName
        } catch {
            Write-Host "An error occurred while retrieving the current username: $_"
            return
        }
    }

    # Ensure the username is not null or empty
    if ([string]::IsNullOrWhiteSpace($UserName)) {
        Write-Host "UserName cannot be null or empty."
        return
    }
}

Process {
    try {
        # Retrieve the list of administrators and check if the username exists
        $adminGroup = Get-LocalGroupMember -Group 'Administrators'
        $userExists = $adminGroup | Where-Object { $_.Name -ieq $UserName } # Case-insensitive comparison

        if ($userExists) {
            $confirmation = Read-Host "Are you sure you want to remove $UserName from the Administrators group? (yes/no)"
            if ($confirmation -eq 'yes') {
                try {
                    Remove-LocalGroupMember -Group 'Administrators' -Member $UserName -ErrorAction Stop
                    Write-Host "$UserName has been removed from the Administrators group."

                    # Optional: Log this action to the event log for auditing
                    Write-EventLog -LogName "Application" -Source "PowerShell Script" -EntryType Information -EventId 1 -Message "$UserName removed from the Administrators group on $(Get-Date)."
                } catch {
                    Write-Host "Failed to remove $UserName from the Administrators group: $_"
                }
            } else {
                Write-Host "Operation cancelled."
            }
        } else {
            Write-Host "$UserName is not a member of the Administrators group."
        }
    } catch {
        Write-Host "An error occurred during the operation: $_"
    }
}

End {
    Write-Host "Script execution completed."
}
