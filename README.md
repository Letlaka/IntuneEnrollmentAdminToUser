# IntuneEnrollmentAdminToUser

This repository contains a PowerShell script designed to automate the process of changing the user account used for Intune enrollment from a local admin to a standard user on Azure AD joined devices. This enhances system security by managing user permissions effectively.

## Script Breakdown

The script is structured into three main blocks: `Begin`, `Process`, and `End`.

### Begin

In the `Begin` block:
- The script verifies that it’s running with administrative privileges. If not, it outputs a message asking to re-run the script as an Administrator and then exits gracefully.
- The script checks that it’s running on PowerShell 5.0 or later to ensure compatibility with the cmdlets used in the script.
- The script attempts to retrieve the current user's name if the `UserName` parameter is not explicitly provided. If this retrieval fails or if the username is empty, the script logs the error and exits.

### Process

In the `Process` block:
- The script checks if the specified user (or the current user by default) is a member of the local Administrators group.
- If the user is a member, the script removes them from the Administrators group using PowerShell-native cmdlets for more reliability and better error handling.
- The action is logged for auditing purposes, both in a specified log file and optionally in the Windows Event Log.
- If the user is not a member of the Administrators group, the script logs this information.

### End

In the `End` block:
- The script outputs a message to the log file indicating that the script execution has been completed.

## SCCM-Friendly Version

A version of the script is available that’s specifically tailored for deployment via System Center Configuration Manager (SCCM):
- **No Interactive Prompts**: The script runs non-interactively, making it suitable for automated deployment.
- **Logging**: Outputs detailed logs to a specified log file to aid in tracking and auditing.
- **Compatibility**: Designed to work under the context SCCM operates in, typically the Local System account.

## Usage

### General Usage

To use this script manually:
1. Open a PowerShell session with administrative privileges.
2. Run the script with the `UserName` parameter if you want to specify a different user, or let it default to the current user:
   ```powershell
   .\IntuneEnrollmentAdminToUser.ps1 -UserName "SpecificUserName"
   ```
3. The script will log actions to the console and, if configured, to the Windows Event Log.

### SCCM Deployment

To deploy the SCCM-friendly version of the script:
1. Upload the script to your SCCM environment.
2. Deploy the script to target machines or collections using SCCM’s script deployment feature.
3. Monitor the deployment logs within SCCM and review the log files on target machines to ensure the script executed as expected.

### Important Notes

- **Administrative Privileges**: The script must be run with administrative privileges as it involves modifying user group memberships.
- **Environment Considerations**: Before deploying widely, test the script in a controlled environment to ensure it behaves as expected.

By using this script, you can easily manage user permissions on Azure AD joined machines, ensuring that users have the appropriate level of access while maintaining system security.
