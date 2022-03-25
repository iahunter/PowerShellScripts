#Install-Module -Name PowerShellGet -Force -AllowClobber

#Install-Module -Name MicrosoftTeams -Force -AllowClobber

#Update-Module MicrosoftTeams

#Import-Module MicrosoftTeams

Connect-MicrosoftTeams

$user = Read-Host -Prompt "Enter Username: "
$number = Read-Host -Prompt "Enter Phone Number: "


Get-CsOnlineUser $user | Select alias,userprincipalname,samaccountname,interpret*,*voice*,*lineuri*,*dial*,*hosting*,*sip*,displayname

Set-CsPhoneNumberAssignment -Identity $user -PhoneNumber +$number -PhoneNumberType DirectRouting

Get-CsOnlineUser $user | Select alias,userprincipalname,samaccountname,interpret*,*voice*,*lineuri*,*dial*,*hosting*,*sip*,displayname


#Disconnect-MicrosoftTeams

