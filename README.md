# IntuneEnrollmentAdminToUser

This repository contains a PowerShell script designed to automate the process of changing the user account used for Intune enrollment from a local admin to a standard user on Azure AD joined devices. This enhances system security by managing user permissions effectively.

## Script Breakdown

The script is divided into three main sections: `Begin`, `Process`, and `End`.

### Begin

In the `Begin` block, the script verifies that it’s running with administrative privileges. If not, it outputs a message asking to re-run the script as an Administrator and then exits.

### Process

The `Process` block checks if the current user is a member of the local administrator's group. If they are, it prompts for confirmation before removing them from the group using the `net localgroup administrators /delete` command. If they’re not, it outputs a message stating that the user is not a member of the Administrators group.

### End

The `End` block outputs a message indicating that the script execution has been completed.

## Usage

To use this script, simply run it in a PowerShell session with administrative privileges. This is particularly useful for managing user permissions on machines that are Azure AD joined. By running this script, you can easily change a user from being a local admin to a standard user.

Please note that this script should be run with administrative privileges as it involves changing user group memberships.
