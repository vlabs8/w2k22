# Creating "VLabs Users" OU
New-ADOrganizationalUnit -Name "VLabs Users" -Path "DC=VLABS8,DC=COM" -ProtectedFromAccidentalDeletion $False
# List all OUs
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A
# Creating Users
New-ADUser -Name Joe -DisplayName "Joe Dow" -GivenName Joe -Surname Dow -Path "ou=VLabs Users,dc=vlabs8,dc=com"
Get-ADUser -Filter * -SearchBase "ou=Vlabs Users,dc=vlabs8,dc=com"
# Creating "VLabsManagement" Group
New-ADGroup -Name "VLabsManagement" -Path "ou=VLabs Users,dc=vlabs8,dc=com" -GroupScope Global -GroupCategory Security
# Add a member to a group
Add-ADGroupMember "VLabsManagement" -Members "CN=Joe,OU=VLabs Users,DC=vlabs8,DC=com"
# List Groups in Sales
Get-ADGroup -filter * -properties * -searchbase "OU=VLabs Users,DC=vlabs8,DC=Com"
# List Groups' Members
Get-ADGroupMember "VLabsManagement"
# Remove ADDS Objects
Remove-ADOrganizationalUnit -Identity "OU=VLabs Users,DC=VLABS8,DC=COM" -Confirm:$False -Verbose
Remove-ADUser -Identity "CN=Joe,OU=VLabs Users,DC=vlabs8,DC=com" -Confirm:$False -Verbose
Remove-ADGroup -Identity VLabsManagement -Confirm:$False -Verbose




