####################################################################
$text = @"

_______        _______ _______  ______ _______ ______       _______ ______  _______ _____ __   _
|_____| |         |    |______ |_____/ |______ |     \      |_____| |     \ |  |  |   |   | \  |
|     | |_____    |    |______ |    \_ |______ |_____/      |     | |_____/ |  |  | __|__ |  \_|
                                                                                                

Title: Delete 30 Day Old Snapshots With Error Handling
Description: Delete Any snapshots older than 30 day
More info: https://alteredadmin.github.io/
=====================================================
Name: Altered Admin
Website: https://alteredadmin.github.io

If you found this helpful Please consider:
Buymeacoffee: http://buymeacoffee.com/alteredadmin
BTC: bc1qhkw7kv9dtdk8xwvetreya2evjqtxn06cghyxt7
LTC: ltc1q2mrh9s8sgmh8h5jtra3gqxuhvy04vuagpm3dk9
ETH: 0xef053b0d936746Df00C9CCe0454b7b8afb1497ac

"@

####################################################################

<#
.SYNOPSIS
    Delete 30 Day Old Snapshots WIth Error Handling
    OS Support:
    Required modules: NONE

.DESCRIPTION
    This script uses the VMware PowerCLI module to connect to a vCenter server, get a list of all virtual machines, and then loop through each 
    virtual machine to check the age of its snapshots. Any snapshots older than 30 days are deleted.
.EXAMPLE
    To use this script, you will need to replace <vCenter_Server_IP_or_Hostname> with the IP address or hostname of your vCenter server. 
    You can also adjust the value of $maxSnapshotAge if you want to use a different snapshot age threshold.

    Note that this script will delete all snapshots for virtual machines that are older than 30 days. 
    If you want to keep certain snapshots, you will need to modify the script to exclude those snapshots from being deleted.
    
.NOTES
    Author:         Altered Admin
    Email:          
    Date:           Jan 13 2023
#>

Write-Host $text

####################################################################


# Import the VMware PowerCLI module
Import-Module VMware.PowerCLI

# Connect to the vCenter server
try {
    Connect-VIServer -Server <vCenter_Server_IP_or_Hostname>
}
catch {
    # Print an error message if the connection fails
    Write-Error "Error: Failed to connect to vCenter server"
    return
}

# Get a list of all virtual machines
try {
    $vms = Get-VM
}
catch {
    # Print an error message if the command fails
    Write-Error "Error: Failed to get list of virtual machines"
    return
}

# Set the maximum snapshot age to 30 days
$maxSnapshotAge = (Get-Date).AddDays(-30)

# Loop through each virtual machine
foreach ($vm in $vms) {
    # Get a list of all snapshots for the virtual machine
    try {
        $snapshots = Get-Snapshot -VM $vm
    }
    catch {
        # Print an error message if the command fails
        Write-Error "Error: Failed to get snapshots for virtual machine '$($vm.Name)'"
        continue
    }

    # Loop through each snapshot
    foreach ($snapshot in $snapshots) {
        # Check if the snapshot is older than 30 days
        if ($snapshot.Created -lt $maxSnapshotAge) {
            # Delete the snapshot
            try {
                Remove-Snapshot -Snapshot $snapshot -Confirm:$false
            }
            catch {
                # Print an error message if the command fails
                Write-Error "Error: Failed to delete snapshot '$($snapshot.Name)' for virtual machine '$($vm.Name)'"
                continue
            }
        }
    }
}

