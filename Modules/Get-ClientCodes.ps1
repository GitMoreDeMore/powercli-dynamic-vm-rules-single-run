function Get-ClientCodes($Cluster, [string[]]$Role_Options, $Affinity_Client_Code, $Confirmation) {
    foreach($Client_Code in Get-Tag -Category "Client_Code") {
        New-DRSVMRules $Client_Code.Name $Cluster $Role_Options $Affinity_Client_Code $Confirmation
    }
}