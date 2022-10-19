# git clone https://github.com/vlabs8/w2k22
# sl .\w2k22\
# ise 3.BaseLabSOP.ps1

# Run all the commands as Administrator

# Install OS
# Do all changes (updates, time, firewall, install soft, etc.)
# Install git
start msedge https://git-scm.com/download/win


# Syprep
cd C:\Windows\System32\Sysprep
.\Sysprep.exe /oobe /generalize /shutdown /mode:vm
# Copy Vm's Image with a new name (w2k22,win11,w2k22core) to base images' central location (E:/VM/VHD)
# Create a new VM and its drive (using base image)
New-VHD -ParentPath E:\VM\vhd\w2k22gui.vhdx -Path e:\vm\DC1\DC1.vhdx -Differencing -Verbose
New-VM -Name DC1 -MemoryStartupBytes 3Gb -VHDPath e:\vm\DC1\DC1.vhdx -Path e:\vm\DC1  -Generation 1 -SwitchName Ext
New-VHD -ParentPath E:\VM\vhd\w2k22gui.vhdx -Path e:\vm\DC2\DC2.vhdx -Differencing -Verbose
New-VM -Name DC2 -MemoryStartupBytes 3Gb -VHDPath e:\vm\DC2\DC2.vhdx -Path e:\vm\DC2  -Generation 1 -SwitchName Ext
New-VHD -ParentPath E:\VM\vhd\w2k22core.vhdx -Path e:\vm\CORE-DC\CORE-DC.vhdx -Differencing -Verbose
New-VM -Name CORE-DC -MemoryStartupBytes 512Mb -VHDPath e:\vm\CORE-DC\CORE-DC.vhdx -Path e:\vm\CORE-DC  -Generation 1 -SwitchName Ext
New-VHD -ParentPath E:\VM\vhd\win11.vhdx -Path e:\vm\CL1\CL1.vhdx -Differencing -Verbose
New-VM -Name CL1 -MemoryStartupBytes 3Gb -VHDPath e:\vm\CL1\CL1.vhdx -Path e:\vm\CL1  -Generation 1 -SwitchName Ext

# To create a NAT virtual switch, use the following Windows PowerShell command:
# New-VMSwitch -Name “NATSwitch” -SwitchType NAT -NATSubnetAddress 172.16.1.0/24


# Checkpoints (https://www.thomasmaurer.ch/2020/07/how-to-manage-hyper-v-vm-checkpoints-with-powershell/)
set-vm DC1,DC2,CORE-DC,CL1 -CheckpointType Disabled
start-vm DC1,DC2,CORE-DC,CL1

# Connect to servers in Hyper-V and set Administrator's password


# Domain Services

# First DC (DC1) 
# Enter-PSSession
$Credentials=Get-Credential
etsn -VMName DC1 -Credential $Credentials

# Rename and add to the domain
Rename-Computer DC1 -Verbose -Restart -Force

# Network Adapter Settings
Get-NetAdapter 
# Check for InterfaceIndex and set it in below commands accordingly "–InterfaceIndex #"
New-NetIPAddress –IPAddress 192.168.1.150 -DefaultGateway 192.168.1.1 -PrefixLength 24 -InterfaceIndex 14
Set-DNSClientServerAddress –InterfaceIndex 14 –ServerAddresses 127.0.0.1,192.168.1.1


Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName "vlabs8.com" -DomainNetbiosName "VLABS8" -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true


# Second DC (CORE-DC)

# Enter-PSSession
etsn -VMName CORE-DC -Credential $Credentials

Get-NetAdapter 
# Check for InterfaceIndex and set it in below commands accordingly "–InterfaceIndex #"
New-NetIPAddress –IPAddress 192.168.1.151 -DefaultGateway 192.168.1.1 -PrefixLength 24 -InterfaceIndex 4
Set-DNSClientServerAddress –InterfaceIndex 4 –ServerAddresses 192.168.1.150


# Rename and add to the domain
Add-Computer -NewName DC-CORE -DomainName vlabs8.com -Credential vlabs8\administrator -Verbose -Restart -Force


# Enter-PSSession
etsn -VMName CORE-DC -Credential vlabs8\administrator

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSDomainController -DomainName "vlabs8.com" -InstallDns:$true -Credential (Get-Credential "vlabs8\administrator")


# Add a Sub-Domain (Child Domain)(DC2)

# Enter-PSSession
etsn -VMName DC2 -Credential $Credentials

Rename-Computer DC2 -Verbose -Restart -Force

# Network Adapter Settings
Get-NetAdapter 
# Check for InterfaceIndex and set it in below commands accordingly "–InterfaceIndex #"
New-NetIPAddress –IPAddress 192.168.1.152 -DefaultGateway 192.168.1.1 -PrefixLength 24 -InterfaceIndex 4
Set-DNSClientServerAddress –InterfaceIndex 4 –ServerAddresses 192.168.1.150,127.0.0.1


Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSDomain -NoGlobalCatalog:$false -CreateDnsDelegation:$true -Credential (Get-Credential) -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainType "ChildDomain" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NewDomainName "lab1” -NewDomainNetbiosName "LAB1" -ParentDomainName "vlabs8.com" -NoRebootOnCompletion:$false -SiteName "Default-First-Site-Name" -SysvolPath "C:\Windows\SYSVOL" -Force:$true

# Enter-PSSession
etsn -VMName DC2 -Credential lab1\administrator


# Client  Windows 11 (CL1)

# Enter-PSSession
etsn -VMName CL1 -Credential tmp

# Network Adapter Settings
Get-NetAdapter 
# Check for InterfaceIndex and set it in below commands accordingly "–InterfaceIndex #"
New-NetIPAddress –IPAddress 192.168.1.153 -DefaultGateway 192.168.1.1 -PrefixLength 24 -InterfaceIndex 4
Set-DNSClientServerAddress –InterfaceIndex 4 –ServerAddresses 192.168.1.150,127.0.0.1


# Rename and add to the domain
Add-Computer -NewName CL1 -DomainName vlabs8.com -Credential vlabs8\administrator -Verbose -Restart -Force

etsn -VMName CL1 -Credential vlabs8\administrator

# Install WAC locally on the Cl1
start msedge https://www.microsoft.com/en-us/evalcenter/download-windows-admin-center

# Add Virtualization for Hyper--V Role
Set-VMProcessor -VMName DC2 -ExposeVirtualizationExtensions $true

# Create checkpoints
stop-vm DC1,DC2,CORE-DC,CL1
set-vm DC1,DC2,CORE-DC,CL1 -CheckpointType Standard
set-VM -Name DC1,DC2,CORE-DC,CL1 -AutomaticCheckpointsEnabled $false
checkpoint-VM -Name DC1,DC2,CORE-DC,CL1 -SnapshotName 'base lab'

# Stop and remove all VMs
stop-vm DC1,DC2,CORE-DC,CL1 -Force
Remove-VM DC1,DC2,CORE-DC,CL1 -Force
Remove-Item -Recurse e:\vm\DC1 -Force
Remove-Item -Recurse e:\vm\DC2 -Force
Remove-Item -Recurse e:\vm\CORE-DC -Force
Remove-Item -Recurse e:\vm\CL1 -Force
