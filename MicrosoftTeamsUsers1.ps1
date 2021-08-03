

#Install-Module -Name MicrosoftTeams -RequiredVersion 2.3.1
Import-Module MicrosoftTeams
$credential = Get-Credential
Connect-MicrosoftTeams -Credential $credential

# Add Users and number to array. 
$users = @{
    "John.Doe" = 1234567890;
    "Jack.Smith" = 0987654321;
}

#Loop thru Array of users and number and set the user to enterprise voice and set phone number. 
ForEach ($user in $users.Keys) {
    
    $key = $user
    $value = $users["$user"]

    # Add E164 format
    $value = "+1$value"

    Write-Output $key
    Write-Output $value

    Get-CsOnlineUser $key | Select alias,userprincipalname,samaccountname,interpret*,*voice*,*lineuri*,*dial*,*hosting*,*sip*,displayname
    
    # Old Command no longer needed
    #Grant-CsTeamsUpgradePolicy -PolicyName UpgradeToTeams -Identity $key

    #Write-Output "tel:+1$value"
    Set-CsUser -Identity $key -EnterpriseVoiceEnabled $true -HostedVoiceMail $true -OnPremLineURI tel:$value

    Write-Output '----------'
}

# Remove number from user
#Set-CsUser -Identity "John.Doe" -OnPremLineURI $null

#Get-CsOnlineUser -Filter {EnterpriseVoiceEnabled -eq $true} # M$ broke this boolean... :(
#Get-CsOnlineUser -Filter {EnterpriseVoiceEnabled -eq "True"} | Select alias,userprincipalname,samaccountname,interpret*,*voice*,*lineuri*,*dial*,*hosting*,*sip*,displayname

#Get-CsOnlineUser -Filter {EnterpriseVoiceEnabled -eq "True"} | Select alias,userprincipalname,samaccountname,OnPremLineURI,SipAddress | Format-Table

#Disconnect-MicrosoftTeams
