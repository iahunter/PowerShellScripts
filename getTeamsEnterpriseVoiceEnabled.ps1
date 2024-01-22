#Install-Module -Name PowerShellGet -Force -AllowClobber
Install-Module -Name MicrosoftTeams -Force -AllowClobber
#Update-Module MicrosoftTeams
Import-Module MicrosoftTeams
Connect-MicrosoftTeams
#Get-InstalledModule -Name MicrosoftTeams

##########################################################################################
# Return Users who have a onpremlineuri that is not null and enterprisevoice is false. 
$allusers = Get-CsOnlineUser -Filter 'EnterpriseVoiceEnabled -eq $true' -OrderBy LineURI | Select alias,userprincipalname,samaccountname,HostedVoiceMail,EnterpriseVoiceEnabled,*LineURI*,SipAddress
$allusers | Format-Table

echo $allusers.count
