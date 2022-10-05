# Download WAC
start msedge https://www.microsoft.com/en-us/evalcenter/download-windows-admin-center

# Clone a github repository 
git clone https://github.com/vlabs8/w2k22

# Open a file with powershell commands in ISE
ise .\w2k22\2.DomainServices.ps1

# Rename a Server and Add it to vlabs domain
Add-Computer -NewName DC-CORE -DomainName vlabs8.com -Credential vlabs8\administrator - Verbose - Restart - Force

# Promote a Server to a Domain Controller
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSDomainController -DomainName "vlabs8.com" -InstallDns:$true -Credential (Get-Credential "vlabs8\administrator")

# Add a Sub-Domain (Child Domain)
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSDomain `
-NoGlobalCatalog:$false `
-CreateDnsDelegation:$true `
-Credential (Get-Credential) `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainType "ChildDomain" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NewDomainName "lab1” `
-NewDomainNetbiosName "LAB1" `
-ParentDomainName "vlabs8.com" `
-NoRebootOnCompletion:$false `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true