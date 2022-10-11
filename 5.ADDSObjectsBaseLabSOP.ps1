### HANDS-ON LAB #### Creating and modifying AD DS objects with Windows PowerShell ####

# New OU
New-ADOrganizationalUnit -Description:"vlabs8 Sales department" -Name:"Sales" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose
New-ADOrganizationalUnit -Description:"vlabs8 Development department" -Name:"Development" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose
New-ADOrganizationalUnit -Description:"vlabs8 IT department" -Name:"IT" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose
New-ADOrganizationalUnit -Description:"vlabs8 Managers department" -Name:"Managers" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose 
New-ADOrganizationalUnit -Description:"vlabs8 Marketing department" -Name:"Marketing" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose
New-ADOrganizationalUnit -Description:"vlabs8 Research department" -Name:"Research" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose

# New Users
#Create CSV Data with CreateCSVData.ps1
# ise ./CreateCSVData.ps1
  
# Import Data from CSV and Create User
Import-Csv -Path C:\Employees2.csv | ForEach-Object {New-ADUser -AccountPassword $SecurePWD -GivenName $_.FirstName -Surname $_.LastName -Name $_.DisplayName -DisplayName $_.DisplayName -SamAccountName $_.SamAccountName -UserPrincipalName $_.UPN -Path $_.OU -StreetAddress $_.StreetAddress -Title $_.Title -Department $_.Department -EmailAddress $_.Email -City $_.City -Country $_.Country -MobilePhone $_.MobilePhone -PasswordNeverExpires $true -Enabled $true}

# Create Groups
New-ADGroup -Name ResearchManagers -GroupCategory Security -GroupScope Universal -DisplayName Research_Managers -Path "OU=Research,DC=vlabs8,DC=com"

# Add to Groups
Get-ADUser -Filter * -SearchBase "OU=Research,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'ResearchManagers' -Members $_}


# Remove Lab
Get-ADOrganizationalUnit -Identity "OU=Sales,DC=VLABS8,DC=COM" | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$false -PassThru |Remove-ADObject -Recursive -Confirm:$false
Get-ADOrganizationalUnit -Identity "OU=Development,DC=VLABS8,DC=COM" | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$false -PassThru |Remove-ADObject -Recursive -Confirm:$false
Get-ADOrganizationalUnit -Identity "OU=IT,DC=VLABS8,DC=COM" | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$false -PassThru |Remove-ADObject -Recursive -Confirm:$false
Get-ADOrganizationalUnit -Identity "OU=Managers,DC=VLABS8,DC=COM" | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$false -PassThru |Remove-ADObject -Recursive -Confirm:$false
Get-ADOrganizationalUnit -Identity "OU=Marketing,DC=VLABS8,DC=COM" | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$false -PassThru |Remove-ADObject -Recursive -Confirm:$false
Get-ADOrganizationalUnit -Identity "OU=Research,DC=VLABS8,DC=COM" | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion:$false -PassThru |Remove-ADObject -Recursive -Confirm:$false




Get-ADUser -Filter * -SearchBase "ou=sales,dc=vlabs8,dc=com"
#Remove-ADUser -Identity 'Nelly J. Eriksen' -Confirm:$False -Verbose
Remove-ADObject -Confirm:$false -Identity:"CN=Nelly J. Eriksen,OU=Research,DC=vlabs8,DC=com" 