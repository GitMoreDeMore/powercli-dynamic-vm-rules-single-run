function Remove-DRSVMRules($Cluster, $Confirmation)
    {
    $Old_Rules = Get-DrsRule -Cluster $Cluster -Name "*"
    if ($Old_Rules)
        {
        if ($Confirmation -eq 'y')
            {
            Remove-DrsRule $Old_Rules -Confirm:$false
            }
        else 
            {
            Write-host Old Rules: $Old_Rules -ForegroundColor DarkRed
            }
        }
    }