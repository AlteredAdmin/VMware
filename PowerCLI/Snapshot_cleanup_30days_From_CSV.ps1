<#
####################################################################
_______        _______ _______  ______ _______ ______       _______ ______  _______ _____ __   _
|_____| |         |    |______ |_____/ |______ |     \      |_____| |     \ |  |  |   |   | \  |
|     | |_____    |    |______ |    \_ |______ |_____/      |     | |_____/ |  |  | __|__ |  \_|
                                                                                                

Title: Delete Old Snapshots Using CSV
Description: Delete Any snapshots older than 30 days from .CSV file.
More info: https://alteredadmin.github.io/
=====================================================
Name: Altered Admin
Website: https://alteredadmin.github.io
Twitter: https://twitter.com/Alt3r3dAdm1n
If you found this helpful Please consider:
Buymeacoffee: http://buymeacoffee.com/alteredadmin
BTC: bc1qhkw7kv9dtdk8xwvetreya2evjqtxn06cghyxt7
LTC: ltc1q2mrh9s8sgmh8h5jtra3gqxuhvy04vuagpm3dk9
ETH: 0xef053b0d936746Df00C9CCe0454b7b8afb1497ac

"@

####################################################################


.SYNOPSIS
    Title: Delete Old Snapshots Using CSV
    OS Support: 
    Required modules: NONE

.DESCRIPTION
The script above uses VMware PowerCLI to delete snapshots for virtual machines that are older than 30 days. 
PowerCLI is a set of PowerShell modules that provide cmdlets to manage and automate VMware vSphere, vCloud, and vRealize environments. 
The script starts by importing the VMware PowerCLI module using the Import-Module cmdlet.

Once the PowerCLI module is imported, the script establishes a connection to the vCenter server using the Connect-VIServer cmdlet. 
The Connect-VIServer cmdlet requires several parameters including the server name, username and password to establish the connection. 
Once connected, the script uses the Import-Csv cmdlet to import a CSV file containing the list of virtual machines that we want to process.

After importing the CSV file, the script uses a foreach loop to iterate through each virtual machine in the list. For each virtual machine, the script uses 
the Get-Snapshot cmdlet to retrieve all snapshots associated with that virtual machine. Another foreach loop is used to iterate through each snapshot and determine 
its age. The script calculates the age of each snapshot by subtracting the CreateTime property of the snapshot from the current date using the Get-Date cmdlet.

If the age of a snapshot is greater than 30 days, the script uses the Remove-Snapshot cmdlet to delete that snapshot. The Remove-Snapshot cmdlet takes the 
snapshot object as a parameter, and the script passed the snapshot object obtained from the previous loop. The script also uses the -Confirm:$false flag, 
which will not prompt for confirmation before deleting the snapshots.

Once all snapshots have been processed, the script exits and the connection to the vCenter server is closed. 
It is important to note that this script should be tested in a non-production environment before running it in production, as the deletion of snapshots can 
have serious consequences if not used properly. This script is a basic one, you can add more functionalities to the script like logging, sending notifications etc.



.EXAMPLE
    

.NOTES
    Author:         Altered Admin & ChatGPT
    Email:          
    Date:           Jan 30 2023
####################################################################
#>


# Import the VMware PowerCLI module
Import-Module VMware.PowerCLI

# Connect to vCenter server
Connect-VIServer -Server vcenter.example.com -User administrator -Password password

# Import the CSV file containing the list of VMs
$VMs = Import-Csv -Path C:\path\to\vm-list.csv

# Loop through each VM in the CSV file
foreach ($VM in $VMs) {

    # Get all snapshots for the VM
    $Snapshots = Get-Snapshot -VM $VM.Name

    # Loop through each snapshot and check if it's older than 30 days
    foreach ($Snapshot in $Snapshots) {

        # Calculate the age of the snapshot in days
        $SnapshotAge = (Get-Date) - $Snapshot.CreateTime

        # If the snapshot is older than 30 days, delete it
        if ($SnapshotAge.Days -gt 30) {
            Remove-Snapshot -Snapshot $Snapshot -Confirm:$false
        }
    }
}