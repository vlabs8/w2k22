#$PlainPWD = "Somepass1"
#$SecurePWD = $PlainPWD | ConvertTo-SecureString -AsPlainText -Force 

$SecurePWD = (Read-Host -AsSecureString "Type the Password")

# Create OUs
New-ADOrganizationalUnit -Name AdventureWorks -Path "DC=vlabs8,DC=com"
New-ADOrganizationalUnit -Name Sales -Path "OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADOrganizationalUnit -Name Development -Path "OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADOrganizationalUnit -Name IT -Path "OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADOrganizationalUnit -Name Managers -Path "OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADOrganizationalUnit -Name Marketing -Path "OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADOrganizationalUnit -Name Research -Path "OU=AdventureWorks,DC=vlabs8,DC=com"

# Create Groups
New-ADGroup -Name AllAdventureWorks -GroupCategory Security -GroupScope Universal -DisplayName "All Adventure Works" -Path "OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADGroup -Name AWSales -GroupCategory Security -GroupScope Universal -DisplayName AW_Sales -Path "OU=Sales,OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADGroup -Name AWDevelopment -GroupCategory Security -GroupScope Universal -DisplayName AW_Development -Path "OU=Development,OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADGroup -Name AWIT -GroupCategory Security -GroupScope Universal -DisplayName AW_IT -Path "OU=IT,OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADGroup -Name AWManagers -GroupCategory Security -GroupScope Universal -DisplayName AW_Managers -Path "OU=Managers,OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADGroup -Name AWMarketing -GroupCategory Security -GroupScope Universal -DisplayName AW_Marketing -Path "OU=Marketing,OU=AdventureWorks,DC=vlabs8,DC=com"
New-ADGroup -Name AWResearch -GroupCategory Security -GroupScope Universal -DisplayName AW_Research -Path "OU=Research,OU=AdventureWorks,DC=vlabs8,DC=com"

# Create Users
Import-Csv -Path .\AdventureWorksUsers.csv | ForEach-Object {New-ADUser -AccountPassword $SecurePWD -GivenName $_.FirstName -Surname $_.LastName -Name $_.DisplayName -DisplayName $_.DisplayName -SamAccountName $_.FirstName -UserPrincipalName $_.UPN -Path $_.OU -PasswordNeverExpires $true -Enabled $true}

# Add to Groups
Get-ADUser -Filter * -SearchBase "OU=AdventureWorks,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'AllAdventureWorks' -Members $_}
Get-ADUser -Filter * -SearchBase "OU=Sales,OU=AdventureWorks,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'AWSales' -Members $_}
Get-ADUser -Filter * -SearchBase "OU=Development,OU=AdventureWorks,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'AWDevelopment' -Members $_}
Get-ADUser -Filter * -SearchBase "OU=IT,OU=AdventureWorks,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'AWIT' -Members $_}
Get-ADUser -Filter * -SearchBase "OU=Managers,OU=AdventureWorks,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'AWManagers' -Members $_}
Get-ADUser -Filter * -SearchBase "OU=Marketing,OU=AdventureWorks,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'AWMarketing' -Members $_}
Get-ADUser -Filter * -SearchBase "OU=Research,OU=AdventureWorks,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'AWResearch' -Members $_}
