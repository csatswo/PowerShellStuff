﻿function TeamsLicenseStatus {
    [CmdletBinding()]Param(
        [Parameter(mandatory=$true)][String]$UserPrincipalName
    )
    try {
        $msolUser = Get-MsolUser -UserPrincipalName $UserPrincipalName -ErrorAction Stop
        if ($msolUser.IsLicensed -eq $true) {
            $teamsLicense = foreach ($servicePlan in $msolUser.Licenses.ServiceStatus) { if ($servicePlan.ServicePlan.ServiceName -eq "TEAMS1") { $servicePlan } }
            if ($teamsLicense) {
                [PSCustomObject]@{
                    DisplayName = $msolUser.DisplayName
                    UserPrincipalName = $msolUser.UserPrincipalName
                    IsLicensed = $msolUser.IsLicensed
                    ServicePlan = $teamsLicense.ServicePlan.ServiceName
                    ProvisioningStatus = $teamsLicense.ProvisioningStatus
                    AssignedSkus = ($msolUser.Licenses.AccountSku.SkuPartNumber | Sort-Object) -join ","
                }
            } else {
                [PSCustomObject]@{
                    DisplayName = $msolUser.DisplayName
                    UserPrincipalName = $msolUser.UserPrincipalName
                    IsLicensed = $msolUser.IsLicensed
                    ServicePlan = $null
                    ProvisioningStatus = $null
                    AssignedSkus = ($msolUser.Licenses.AccountSku.SkuPartNumber | Sort-Object) -join ","
                }
            }
        } else {
            [PSCustomObject]@{
                DisplayName = $msolUser.DisplayName
                UserPrincipalName = $msolUser.UserPrincipalName
                IsLicensed = $msolUser.IsLicensed
                ServicePlan = $null
                ProvisioningStatus = $null
                AssignedSkus = $null
            }
        }
    } catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}
