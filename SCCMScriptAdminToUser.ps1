[CmdletBinding()]
Param(
    [string]$UserName,
    [string]$LogFilePath = "C:\Windows\Logs\RemoveAdminUser.log"
)

Function Write-Log {
    Param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    Add-Content -Path $LogFilePath -Value $logEntry
}

Begin {
    # Verify that the script is running with administrative privileges
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Log "This script must be run as an Administrator. Script execution aborted."
        return
    }

    # Ensure that the script is being run on an appropriate version of PowerShell
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-Log "This script requires PowerShell 5.0 or later. Script execution aborted."
        return
    }

    # If the UserName parameter is not provided, default to the current user
    if (-not $UserName) {
        try {
            $UserName = (Get-CimInstance -ClassName Win32_ComputerSystem).UserName
            Write-Log "Username not provided. Defaulting to current user: $UserName"
        } catch {
            Write-Log "An error occurred while retrieving the current username: $_. Script execution aborted."
            return
        }
    }

    # Ensure the username is not null or empty
    if ([string]::IsNullOrWhiteSpace($UserName)) {
        Write-Log "UserName cannot be null or empty. Script execution aborted."
        return
    }
}

Process {
    try {
        # Retrieve the list of administrators and check if the username exists
        $adminGroup = Get-LocalGroupMember -Group 'Administrators'
        $userExists = $adminGroup | Where-Object { $_.Name -ieq $UserName } # Case-insensitive comparison

        if ($userExists) {
            try {
                Remove-LocalGroupMember -Group 'Administrators' -Member $UserName -ErrorAction Stop
                Write-Log "$UserName has been removed from the Administrators group."

                # Optional: Log this action to the event log for auditing
                Write-EventLog -LogName "Application" -Source "PowerShell Script" -EntryType Information -EventId 1 -Message "$UserName removed from the Administrators group on $(Get-Date)."
            } catch {
                Write-Log "Failed to remove $UserName from the Administrators group: $_"
            }
        } else {
            Write-Log "$UserName is not a member of the Administrators group."
        }
    } catch {
        Write-Log "An error occurred during the operation: $_"
    }
}

End {
    Write-Log "Script execution completed."
}
