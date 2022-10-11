# Creating and modifying AD DS objects with Windows PowerShell

# Creating "VLabs Users" OU
New-ADOrganizationalUnit -Name "VLabs Users" -Path "DC=VLABS8,DC=COM" -ProtectedFromAccidentalDeletion $False
# List all OUs
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
# Remove OU
Remove-ADOrganizationalUnit -Identity "OU=VLabs Users,DC=VLABS8,DC=COM" -WhatIf
# Remove OU with confirming
Remove-ADOrganizationalUnit -Identity "OU=VLabs Users,DC=VLABS8,DC=COM"
# Remove OU without confirmation
Remove-ADOrganizationalUnit -Identity "OU=VLabs Users,DC=VLABS8,DC=COM" -Confirm:$False -Verbose

# Creating Users
New-ADUser -Name Joe -DisplayName "Joe Dow" -GivenName Joe -Surname Dow -Path "ou=VLabs Users,dc=vlabs8,dc=com"
Get-ADUser -Filter * -SearchBase "ou=Vlabs Users,dc=vlabs8,dc=com"
Remove-ADUser -Identity "CN=Joe,OU=VLabs Users,DC=vlabs8,DC=com" -Confirm:$False -Verbose

# Creating "SalesManagement" Group
New-ADGroup -Name "SalesManagement" -Path "ou=Sales,dc=vlabs8,dc=com" -GroupScope Global -GroupCategory Security
# Add a member to a group
Add-ADGroupMember "SalesManagement" -Members "CN=Joe,OU=VLabs Users,DC=vlabs8,DC=com"
# List Groups in Sales
Get-ADGroup -filter * -properties * -searchbase "OU=Sales,DC=vlabs8,DC=Com"
# List Groups' Members
Get-ADGroupMember "SalesManagement"
# Remove a Group
Remove-ADGroup -Identity SalesManagement -Confirm:$False -Verbose

# Remove all above Obects
Remove-ADOrganizationalUnit -Identity "OU=VLabs Users,DC=VLABS8,DC=COM" -Confirm:$False -Verbose
Remove-ADUser -Identity "CN=Joe,OU=VLabs Users,DC=vlabs8,DC=com" -Confirm:$False -Verbose
Remove-ADGroup -Identity SalesManagement -Confirm:$False -Verbose








 

