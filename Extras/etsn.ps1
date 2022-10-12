$DomainCredentials=Get-Credential vlabs8\administrator
etsn -VMName DC1 -Credential $DomainCredentials
etsn -VMName DC2 -Credential $DomainCredentials
etsn -VMName DC-CORE -Credential $DomainCredentials
etsn -VMName CL1 -Credential $DomainCredentials
