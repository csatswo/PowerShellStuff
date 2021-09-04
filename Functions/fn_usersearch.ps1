# Find a user based on any provided attribute
Function csou {
    [CmdletBinding()]Param(
        [string]$prop,
        [string]$search
        )
    $result =  Get-CsOnlineUser -Filter "($prop -like '*$search*')"
    $result
}

# Find Enterprise Voice related attributes for a user based on any provided attribute
Function csouev {
    [CmdletBinding()]Param(
        [string]$prop,
        [string]$search
        )
    $result = Get-CsOnlineUser -Filter "($prop -like '*$search*')" | Select-Object DisplayName,UserPrincipalName,SipAddress,EnterpriseVoiceEnabled,HostedVoiceMail,OnPremLineURI,OnlineVoiceRoutingPolicy,TenantDialPlan,TeamsCallingPolicy,TeamsMeetingPolicy,TeamsMeetingBroadcastPolicy,TeamsUpgradeEffectiveMode,RegistrarPool,UsageLocation
    $result
}