$Credentials=Get-Credential
New-VHD -ParentPath E:\VM\vhd\w2k22gui.vhdx -Path e:\vm\temp\temp.vhdx -Differencing -Verbose
New-VM -Name temp -MemoryStartupBytes 4Gb -VHDPath e:\vm\temp\temp.vhdx -Path e:\vm\temp  -Generation 1 -SwitchName Ext
Set-VMProcessor temp -Count 4
set-vm temp -CheckpointType Disabled
start-vm temp -verbose
etsn -VMName temp -Credential $Credentials

# Can be skipped
$DomainCredentials=Get-Credential
Rename-Computer DC1test -Verbose -Restart -Force
etsn -VMName temp -Credential $DomainCredentials
Get-NetAdapter
New-NetIPAddress –IPAddress 192.168.1.210 -DefaultGateway 192.168.1.1 -PrefixLength 24 -InterfaceIndex 14
Set-DNSClientServerAddress –InterfaceIndex 14 –ServerAddresses 127.0.0.1,192.168.1.1

# Install ADDS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName "vlabs8.com" -DomainNetbiosName "VLABS8" -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true

#Checkpoint VM
stop-vm temp -force -verbose
set-vm temp -CheckpointType Standard
set-VM -Name temp -AutomaticCheckpointsEnabled $false
checkpoint-VM -Name temp -SnapshotName 'vlabs domain istalled'
start-vm temp -Verbose

# Copy Git Repo
$DomainCredentials=Get-Credential
etsn -VMName temp -Credential $DomainCredentials
sl C:\
git clone https://github.com/vlabs8/w2k22

# Populate with AD Users
sl C:\w2k22\ADUsers
#.\AdventureWorksSetup.ps1

# Get all OUS
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -A

# New OU
New-ADOrganizationalUnit -Description:"vlabs8 Sales department" -Name:"Sales" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Server:"DC1test.vlabs8.com"
New-ADOrganizationalUnit -Description:"vlabs8 Development department" -Name:"Development" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Server:"DC1test.vlabs8.com"
New-ADOrganizationalUnit -Description:"vlabs8 IT department" -Name:"IT" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Server:"DC1test.vlabs8.com"
New-ADOrganizationalUnit -Description:"vlabs8 Managers department" -Name:"Managers" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Server:"DC1test.vlabs8.com"
New-ADOrganizationalUnit -Description:"vlabs8 Marketing department" -Name:"Marketing" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Server:"DC1test.vlabs8.com"
New-ADOrganizationalUnit -Description:"vlabs8 Research department" -Name:"Research" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Server:"DC1test.vlabs8.com"
New-ADOrganizationalUnit -Description:"vlabs8 sales department" -Name:"Sales" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Server:"DC1test.vlabs8.com"
New-ADOrganizationalUnit -Description:"vlabs8 sales department" -Name:"Sales" -Path:"DC=vlabs8,DC=com" -ProtectedFromAccidentalDeletion:$false -Server:"DC1test.vlabs8.com"

# Generate data for new users 
$UserNames = @('Michael', 'Christopher', 'Jessica', 'Matthew', 'Ashley', 'Jennifer', 'Joshua', 'Amanda', 'Daniel', 'David', 'James', 'Robert', 'John', 'Joseph', 'Andrew', 'Ryan', 'Brandon', 'Jason', 'Justin', 'Sarah', 'William', 'Jonathan', 'Stephanie', 'Brian', 'Nicole', 'Nicholas', 'Anthony', 'Heather', 'Eric', 'Elizabeth', 'Adam', 'Megan', 'Melissa', 'Kevin', 'Steven', 'Thomas', 'Timothy', 'Christina', 'Kyle', 'Rachel', 'Laura', 'Lauren', 'Amber', 'Brittany', 'Danielle', 'Richard', 'Kimberly', 'Jeffrey', 'Amy', 'Crystal', 'Michelle', 'Tiffany', 'Jeremy', 'Benjamin', 'Mark', 'Emily', 'Aaron', 'Charles', 'Rebecca', 'Jacob', 'Stephen', 'Patrick', 'Sean', 'Erin', 'Zachary', 'Jamie', 'Kelly', 'Samantha', 'Nathan', 'Sara', 'Dustin', 'Paul', 'Angela', 'Tyler', 'Scott', 'Katherine', 'Andrea', 'Gregory', 'Erica', 'Mary', 'Travis', 'Lisa', 'Kenneth', 'Bryan', 'Lindsey', 'Kristen', 'Jose', 'Alexander', 'Jesse', 'Katie', 'Lindsay', 'Shannon', 'Vanessa', 'Courtney', 'Christine', 'Alicia', 'Cody', 'Allison', 'Bradley', 'Samuel', 'Shawn', 'April', 'Derek', 'Kathryn', 'Kristin', 'Chad', 'Jenna', 'Tara', 'Maria', 'Krystal', 'Jared', 'Anna', 'Edward', 'Julie', 'Peter', 'Holly', 'Marcus', 'Kristina', 'Natalie', 'Jordan', 'Victoria', 'Jacqueline', 'Corey', 'Keith', 'Monica', 'Juan', 'Donald', 'Cassandra', 'Meghan', 'Joel', 'Shane', 'Phillip', 'Patricia', 'Brett', 'Ronald', 'Catherine', 'George', 'Antonio', 'Cynthia', 'Stacy', 'Kathleen', 'Raymond', 'Carlos', 'Brandi', 'Douglas', 'Nathaniel', 'Ian', 'Craig', 'Brandy', 'Alex', 'Valerie', 'Veronica', 'Cory', 'Whitney', 'Gary', 'Derrick', 'Philip', 'Luis', 'Diana', 'Chelsea', 'Leslie', 'Caitlin', 'Leah', 'Natasha', 'Erika', 'Casey', 'Latoya', 'Erik', 'Dana', 'Victor', 'Brent', 'Dominique', 'Frank', 'Brittney', 'Evan', 'Gabriel', 'Julia', 'Candice', 'Karen', 'Melanie', 'Adrian', 'Stacey', 'Margaret', 'Sheena', 'Wesley', 'Vincent', 'Alexandra', 'Katrina', 'Bethany', 'Nichole', 'Larry', 'Jeffery', 'Curtis', 'Carrie', 'Todd');
$LastNames = @('Sutou','Barros','Zubareva','Karlsen','Villareal','Nilsson','Bogason','Fokine','Blom','Sundström','Baumgartner','Gardner');
$departments = @('Sales','Development','IT','Managers','Marketing','Research')
$SecurePass = ConvertTo-SecureString "Somepass1" -AsPlainText -Force
$firstname = (Get-Random -InputObject $UserNames);
$lastname = (Get-Random -InputObject $LastNames);
$department = (Get-Random -InputObject $Departments);
$fullname = "{0} {1}" -f ($firstname , $lastname);
$Description = $fullname 
$SamAccountName = ("{0}.{1}" -f ($firstname, $lastname)).ToLower();
$principalname = "{0}.{1}" -f ($firstname, $lastname);
$OUs = @('ou=Sales,dc=vlabs8,dc=com', '$OU = "ou=Development,dc=vlabs8,dc=com',"ou=IT,dc=vlabs8,dc=com","ou=Managers,dc=vlabs8,dc=com","ou=Marketing,dc=vlabs8,dc=com","ou=Research,dc=vlabs8,dc=com")
$OU = (Get-Random -InputObject $OUs);

# Create new user from generated data
New-ADUser -Name $firstname -UserPrincipalName $principalname -Given $lastname -Surname $lastname -DisplayName $fullname -Path $OU -Description $Description -AccountPassword $SecurePass -Enabled $true	






# Restore Checkpoint
exit
Restore-VMCheckpoint -Name 'vlabs domain istalled' -VMName temp -Confirm:$false
start-vm temp

# Destroy VM
stop-vm temp -Force
Remove-VM temp -Force
Remove-Item -Recurse e:\vm\temp -Force
