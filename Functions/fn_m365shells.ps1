function iseTitle {
    $Host.UI.RawUI.WindowTitle = (Get-MsolDomain | Where-Object {$_.isDefault}).name
    Set-Location C:\Temp
}

Function msol {
    Import-Module MSOnline;Connect-MsolService | Out-Null
}

Function aad {
    Import-Module AzureADPreview;Connect-AzureAD | Out-Null
}

Function teams {
    Import-Module MicrosoftTeams;Connect-MicrosoftTeams| Out-Null
}

Function exo {
    Import-Module ExchangeOnlineManagement;Connect-ExchangeOnline -ShowBanner:$false
}

Function spo {
    $domain = ((Get-AzureADDomain | Where-Object {$_.Name -like "*.onmicrosoft.com" -and $_.Name -notlike "*.mail.onmicrosoft.com"}).Name) -replace "\.onmicrosoft\.com"
    $spoAdminUrl = "https://"+$domain+"-admin.sharepoint.com"
    Import-Module Microsoft.Online.SharePoint.PowerShell;Connect-SPOService -Url $spoAdminUrl
}

Function m365mfa {
    Write-Host "Connecting to MSOnline..."
    msol
    Write-Host "Connecting to AzureAD..."
    aad
    Write-Host "Connecting to Teams..."
    teams
    Write-Host "Connecting to ExchangeOnline..."
    exo
    iseTitle
}

Function m365 {
    $Credential  = Get-Credential
    Write-Host "Connecting to MSOnline..."
    Import-Module MSOnline;Connect-MsolService -Credential $Credential | Out-Null
    Write-Host "Connecting to AzureAD..."
    Import-Module AzureADPreview;Connect-AzureAD -Credential $Credential | Out-Null
    Write-Host "Connecting to Teams..."
    Import-Module MicrosoftTeams;Connect-MicrosoftTeams -Credential $Credential | Out-Null
    Write-Host "Connecting to ExchangeOnline..."
    Import-Module ExchangeOnlineManagement;Connect-ExchangeOnline -Credential $Credential -ShowBanner:$false
    iseTitle
}

Function refreshM365 {
    $modules = @("AzureADPreview","ExchangeOnlineManagement","Microsoft.Online.SharePoint.PowerShell","MicrosoftTeams","MSOnline")
    foreach ($moduleName in $modules) {
        $installedModule = Get-Module -ListAvailable -Name $moduleName
        $availableModule = Find-Module -Repository PSGallery -Name $moduleName
        if ($installedModule.Version -lt $availableModule.Version) {
            Write-Host "`n$($installedModule.Name) version is $($installedModule.Version)" -ForegroundColor Yellow
            Write-Host "Updating module to version $($availableModule.Version)" -ForegroundColor Yellow
            Uninstall-Module -Name $installedModule.Name
            Install-Module -Repository PSGallery -Name $availableModule.Name
        } else {
            Write-Host "`n$moduleName"
            Write-Host "Installed version is latest `($($installedModule.Version)`)" -ForegroundColor Green
        }
    }
}
