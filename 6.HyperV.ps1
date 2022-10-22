# To enable nested virtualization in a virtual machine named DemoVM:
Set-VMProcessor -VMName DemoVM -ExposeVirtualizationExtensions $true

# To create a NAT virtual switch, use the following Windows PowerShell command:
New-VMSwitch -Name “NATSwitch” -SwitchType NAT -NATSubnetAddress 172.16.1.0/24
	
# To check a virtual machine’s configuration version
Get-VM * | Format-Table Name, Version