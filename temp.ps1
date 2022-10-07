﻿$Credentials=Get-Credential
New-VHD -ParentPath E:\VM\vhd\w2k22gui.vhdx -Path e:\vm\temp\temp.vhdx -Differencing -Verbose
New-VM -Name temp -MemoryStartupBytes 4Gb -VHDPath e:\vm\temp\temp.vhdx -Path e:\vm\temp  -Generation 1 -SwitchName Ext
Set-VMProcessor temp -Count 4
set-vm temp -CheckpointType Disabled
start-vm temp -verbose
etsn -VMName temp -Credential $Credentials

# Can be skipped
Rename-Computer DC1test -Verbose -Restart -Force
etsn -VMName temp -Credential $Credentials
Get-NetAdapter
New-NetIPAddress –IPAddress 192.168.1.210 -DefaultGateway 192.168.1.1 -PrefixLength 24 -InterfaceIndex 8
Set-DNSClientServerAddress –InterfaceIndex 8 –ServerAddresses 127.0.0.1,192.168.1.1

# Install ADDS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName "vlabs8.com" -DomainNetbiosName "VLABS8" -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true

#Checkpoint VM
stop-vm temp -force -verbose
set-vm temp -CheckpointType Standard
set-VM -Name temp -AutomaticCheckpointsEnabled $false
checkpoint-VM -Name temp -SnapshotName 'vlabs domain istalled'
start-vm temp

# Copy Git Repo
$DomainCredentials=Get-Credential
etsn -VMName temp -Credential $DomainCredentials
sl C:\
git clone https://github.com/vlabs8/w2k22

# Populate with AD Users
sl C:\w2k22\ADUsers
.\AdventureWorksSetup.ps1
Get-ADUser Gates


# Restore Checkpoint
exit
Restore-VMCheckpoint -Name 'vlabs domain istalled' -VMName temp -Confirm:$false
start-vm temp

# Destroy VM
stop-vm temp -Force
Remove-VM temp -Force
Remove-Item -Recurse e:\vm\temp -Force
