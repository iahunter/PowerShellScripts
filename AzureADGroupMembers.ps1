Install-Module -Name AzureAD
Connect-AzureAD

# Search for String
Get-AzureADGroup -SearchString "SEARCHSTRING"

# Exact record
Get-AzureADGroup -Filter "DisplayName eq 'EXACTGROUPNAME'"

# Get members - Lists Objtecid, DisplayName, UUserPrincipalName, UserType
Get-AzureADGroupMember -ObjectId "OBJECTIDOFGROUP"
