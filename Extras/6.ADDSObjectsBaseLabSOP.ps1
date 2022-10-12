### HANDS-ON LAB #### Creating and modifying AD DS objects with Windows PowerShell ####

# New OU
New-ADOrganizationalUnit -Description:"vlabs8 Sales department" -Name:"Sales" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose
New-ADOrganizationalUnit -Description:"vlabs8 Development department" -Name:"Development" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose
New-ADOrganizationalUnit -Description:"vlabs8 IT department" -Name:"IT" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose
New-ADOrganizationalUnit -Description:"vlabs8 Managers department" -Name:"Managers" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose 
New-ADOrganizationalUnit -Description:"vlabs8 Marketing department" -Name:"Marketing" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose
New-ADOrganizationalUnit -Description:"vlabs8 Research department" -Name:"Research" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Verbose

# New Users from CSV
#Create CSV Data with CreateCSVData.ps1
# ise ./CreateCSVData.ps1 
# Import Data from CSV and Create User
#$SecurePWD = "Somepass1" | ConvertTo-SecureString -AsPlainText -Force 
#$SecurePWD = (Read-Host -AsSecureString "Type the Password")
#Import-Csv -Path C:\Employees2.csv | ForEach-Object {New-ADUser -AccountPassword $SecurePWD -GivenName $_.FirstName -Surname $_.LastName -Name $_.DisplayName -DisplayName $_.DisplayName -SamAccountName $_.SamAccountName -UserPrincipalName $_.UPN -Path $_.OU -StreetAddress $_.StreetAddress -Title $_.Title -Department $_.Department -EmailAddress $_.Email -City $_.City -Country $_.Country -MobilePhone $_.MobilePhone -PasswordNeverExpires $true -Enabled $true}


# New Users from Generated Data
# Generate data for new users 
$UserNames = @('Michael', 'Christopher', 'Jessica', 'Matthew', 'Ashley', 'Jennifer', 'Joshua', 'Amanda', 'Daniel', 'David', 'James', 'Robert', 'John', 'Joseph', 'Andrew', 'Ryan', 'Brandon', 'Jason', 'Justin', 'Sarah', 'William', 'Jonathan', 'Stephanie', 'Brian', 'Nicole', 'Nicholas', 'Anthony', 'Heather', 'Eric', 'Elizabeth', 'Adam', 'Megan', 'Melissa', 'Kevin', 'Steven', 'Thomas', 'Timothy', 'Christina', 'Kyle', 'Rachel', 'Laura', 'Lauren', 'Amber', 'Brittany', 'Danielle', 'Richard', 'Kimberly', 'Jeffrey', 'Amy', 'Crystal', 'Michelle', 'Tiffany', 'Jeremy', 'Benjamin', 'Mark', 'Emily', 'Aaron', 'Charles', 'Rebecca', 'Jacob', 'Stephen', 'Patrick', 'Sean', 'Erin', 'Zachary', 'Jamie', 'Kelly', 'Samantha', 'Nathan', 'Sara', 'Dustin', 'Paul', 'Angela', 'Tyler', 'Scott', 'Katherine', 'Andrea', 'Gregory', 'Erica', 'Mary', 'Travis', 'Lisa', 'Kenneth', 'Bryan', 'Lindsey', 'Kristen', 'Jose', 'Alexander', 'Jesse', 'Katie', 'Lindsay', 'Shannon', 'Vanessa', 'Courtney', 'Christine', 'Alicia', 'Cody', 'Allison', 'Bradley', 'Samuel', 'Shawn', 'April', 'Derek', 'Kathryn', 'Kristin', 'Chad', 'Jenna', 'Tara', 'Maria', 'Krystal', 'Jared', 'Anna', 'Edward', 'Julie', 'Peter', 'Holly', 'Marcus', 'Kristina', 'Natalie', 'Jordan', 'Victoria', 'Jacqueline', 'Corey', 'Keith', 'Monica', 'Juan', 'Donald', 'Cassandra', 'Meghan', 'Joel', 'Shane', 'Phillip', 'Patricia', 'Brett', 'Ronald', 'Catherine', 'George', 'Antonio', 'Cynthia', 'Stacy', 'Kathleen', 'Raymond', 'Carlos', 'Brandi', 'Douglas', 'Nathaniel', 'Ian', 'Craig', 'Brandy', 'Alex', 'Valerie', 'Veronica', 'Cory', 'Whitney', 'Gary', 'Derrick', 'Philip', 'Luis', 'Diana', 'Chelsea', 'Leslie', 'Caitlin', 'Leah', 'Natasha', 'Erika', 'Casey', 'Latoya', 'Erik', 'Dana', 'Victor', 'Brent', 'Dominique', 'Frank', 'Brittney', 'Evan', 'Gabriel', 'Julia', 'Candice', 'Karen', 'Melanie', 'Adrian', 'Stacey', 'Margaret', 'Sheena', 'Wesley', 'Vincent', 'Alexandra', 'Katrina', 'Bethany', 'Nichole', 'Larry', 'Jeffery', 'Curtis', 'Carrie', 'Todd');
$LastNames = @('Sutou','Barros','Zubareva','Karlsen','Villareal','Nilsson','Bogason','Fokine','Blom','Sundström','Baumgartner','Gardner');
$departments = @('Sales','Development','IT','Managers','Marketing','Research')
$SecurePass = ConvertTo-SecureString "Somepass1" -AsPlainText -Force
$firstname = (Get-Random -InputObject $UserNames);
$lastname = (Get-Random -InputObject $LastNames);
$department = (Get-Random -InputObject $Departments);
$fullname = "{0} {1}" -f ($firstname , $lastname);
$Name = $fullname
$DisplayName = $fullname
$Description = $fullname 
$SamAccountName = ("{0}.{1}" -f ($firstname, $lastname)).ToLower();
$principalname = "{0}.{1}" -f ($firstname, $lastname);
$OUs = @('ou=Sales,dc=vlabs8,dc=com', '$OU = "ou=Development,dc=vlabs8,dc=com',"ou=IT,dc=vlabs8,dc=com","ou=Managers,dc=vlabs8,dc=com","ou=Marketing,dc=vlabs8,dc=com","ou=Research,dc=vlabs8,dc=com")
$OU = (Get-Random -InputObject $OUs);


# Create new user from generated data
New-ADUser -Name $DisplayName -UserPrincipalName $principalname -Given $firstname -Surname $lastname -DisplayName $fullname -SamAccountName $SamAccountName -Path $OU -Description $Description -AccountPassword $SecurePass -Enabled $true	
#New-ADUser -Name $firstname -UserPrincipalName $principalname -Given $lastname -Surname $lastname -DisplayName $fullname -Description $Description -AccountPassword $SecurePass -Enabled $true	



# Create Groups
New-ADGroup -Name SalesDep -GroupCategory Security -GroupScope Universal -DisplayName SalesDep -Path "OU=Sales,DC=vlabs8,DC=com"
New-ADGroup -Name DevelopmentDep -GroupCategory Security -GroupScope Universal -DisplayName DevelopmentDep -Path "OU=Development,DC=vlabs8,DC=com"
New-ADGroup -Name ITDep -GroupCategory Security -GroupScope Universal -DisplayName ITDep -Path "OU=IT,DC=vlabs8,DC=com"
New-ADGroup -Name ManagersDep -GroupCategory Security -GroupScope Universal -DisplayName ManagersDep -Path "OU=Managers,DC=vlabs8,DC=com"
New-ADGroup -Name MarketingDep -GroupCategory Security -GroupScope Universal -DisplayName MarketingDep -Path "OU=Marketing,DC=vlabs8,DC=com"
New-ADGroup -Name ResearchDep -GroupCategory Security -GroupScope Universal -DisplayName ResearchDep -Path "OU=Research,DC=vlabs8,DC=com"


# Add to Groups
Get-ADUser -Filter * -SearchBase "OU=Sales,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'SalesDep' -Members $_}
Get-ADUser -Filter * -SearchBase "OU=Development,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'DevelopmentDep' -Members $_}
Get-ADUser -Filter * -SearchBase "OU=IT,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'ITDep' -Members $_}
Get-ADUser -Filter * -SearchBase "OU=Managers,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'ManagersDep' -Members $_}
Get-ADUser -Filter * -SearchBase "OU=Marketing,DC=vlabs8,DC=com" | ForEach-Object {Add-ADGroupMember -Identity 'MarketingDep' -Members $_}
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