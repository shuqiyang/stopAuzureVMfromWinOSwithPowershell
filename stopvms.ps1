### START - Stopping Azure VMs ####
$VMFile = "D:\your dir\AzureVMs.txt"
$ReportFile = "D:\your dir\VMStopReport.txt"

Connect-AzAccount -Environment AzureChinaCloud -Subscription 'your subscription ID'

Add-Content $ReportFile "---------------------------------------------"
$timestamp = Get-Date -Format "dddd MM/dd/yyyy HH:mm"
$vmcount=1
Add-Content $ReportFile $timestamp
Foreach ($ThisVMNow in Get-Content "$VMFile")
{

    $Error.Clear()
    $RGnow = ($ThisVMNow -split ' ')[0]
    $VMnow = ($ThisVMNow -split ' ')[1]
    Stop-AzVM -ResourceGroupName $RGnow -Name $VMnow -Force
    IF ($Error.Count -eq 0)
    {
        $STR = "("+$vmcount + ")Azure Virtual Machine was stopped : " + $ThisVMNow
        Add-Content $ReportFile $STR
    }
    else
    {
        $STR = "("+$vmcount + ")ERROR: Failed to stop Azure Virtual Machine : " + $ThisVMNow+","+$Error[0]
        Add-Content $ReportFile $STR
    }
    $vmcount++
}
$STR = "End of operation log report @" + $timestamp
Add-Content $ReportFile $STR
### END - Stopping Azure VMs ####