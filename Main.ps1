## Create DRS rules dynamically for matching Client_Code/Role Tags

# Import Function Modules
. .\Modules\Remove-DRSVMRules.ps1
. .\Modules\Get-ClientCodes.ps1
. .\Modules\New-DRSVMRules.ps1

##Global Variables for SMTP
$global:EmailTo = ""
$global:EmailFrom = ""
$global:SMTPS = ""
$global:SMTP_Port = 25

# Set vCenter FQDN/IP and confirmation variables
$vCenter = ""
$vCredential = Get-Credential
$Confirmation ="no"

# Connect to vCenter Server
Connect-VIServer -Server $vCenter -Credential $vCredential -WarningAction SilentlyContinue

# Set exclusions for Role
$Exclude_Role = Get-Tag -Category "Exclude_Role"
$Exclude_Role = $Exclude_Role.name -join '|'

# Gather Workload Tags from vCenter IE. RGI,WEB,MDB
$Role_Options = Get-Tag -Category "Role" | Where-Object {$_.name -notmatch "$Exclude_Role"}

# Loop vCenter Clusters creating rules for matching Client / Workload
#Dry Run
foreach($Cluster in Get-Cluster) {
	Remove-DRSVMRules $Cluster.Name $Confirmation
	Get-ClientCodes $Cluster.Name $Role_Options.Name $Affinity_Client_Code $Confirmation
}

#Actual run
$Confirmation = Read-Host "Enter y to proceed"
if ($Confirmation -eq "y" -or $Confirmation -eq "yes") {
	foreach($Cluster in Get-Cluster) {
		Remove-DRSVMRules $Cluster.Name $Confirmation
		Get-ClientCodes $Cluster.Name $Role_Options.Name $Affinity_Client_Code $Confirmation
	}
}
else {
	Write-Host "Aborting..."
}

# Disconnect vCenter Server
Disconnect-VIServer -confirm:$false