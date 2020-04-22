### START - Stopping Azure VMs ####
$VMFile = "your dir\AzureVMs.txt"
$ReportFile = "your dir\VMStopReport.txt"
##https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-authenticate-service-principal-powershell#create-service-principal-with-self-signed-certificate
$Thumbprint = 'your thumbprint'
$TenantId = 'your TenantID'
$ApplicationId = 'your service principle ApplicationID'
Connect-AzAccount -Environment AzureChinaCloud -CertificateThumbprint $Thumbprint -ApplicationId $ApplicationId -Tenant $TenantId -ServicePrincipal 

##Connect-AzAccount -Environment AzureChinaCloud -Subscription 'f7ccde76-13d3-4104-a67c-a396e59e872b'

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