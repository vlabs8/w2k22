New-VHD -ParentPath E:\VM\vhd\w2k22gui.vhdx -Path e:\vm\temp\temp.vhdx -Differencing -Verbose
New-VM -Name temp -MemoryStartupBytes 3Gb -VHDPath e:\vm\temp\temp.vhdx -Path e:\vm\temp  -Generation 1 -SwitchName Ext
set-vm temp -CheckpointType Disabled
start-vm temp
etsn -VMName temp -Credential administrator
Rename-Computer DC1test -Verbose -Restart -Force
etsn -VMName temp -Credential administrator
Get-NetAdapter
New-NetIPAddress –IPAddress 192.168.1.210 -DefaultGateway 192.168.1.1 -PrefixLength 24 -InterfaceIndex 8
Set-DNSClientServerAddress –InterfaceIndex 8 –ServerAddresses 127.0.0.1,192.168.1.1
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName "vlabs8.com" -DomainNetbiosName "VLABS8" -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true
stop-vm temp -force -verbose
set-vm temp -CheckpointType Standard
Set-VM -Name temp -AutomaticCheckpointsEnabled $false
checkpoint-VM -Name temp -SnapshotName 'vlabs domain istalled'
start-vm temp
etsn -VMName temp -Credential vlabs8\administrator
sl C:\
git clone https://github.com/vlabs8/w2k22
sl C:\w2k22\ADUsers
.\AdventureWorksSetup.ps1

# Restore Checkpoint
exit
Restore-VMCheckpoint -Name 'vlabs domain istalled' -VMName temp -Confirm:$false
start-vm temp