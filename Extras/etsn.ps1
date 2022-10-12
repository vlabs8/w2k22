$DomainCredentials=Get-Credential vlabs8\administrator
etsn -VMName DC1 -Credential $DomainCredentials
etsn -VMName DC2 -Credential $DomainCredentials
etsn -VMName DC-CORE -Credential $DomainCredentials
etsn -VMName CL1 -Credential $DomainCredentials

$20742BDomainCredentials=Get-Credential adatum\administrator
etsn -VMName 20742B-LON-DC1 -Credential $20742BDomainCredentials
 
