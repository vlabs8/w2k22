# New Users
#Create CSV Data

$employees = @(

  [pscustomobject]@{


  FirstName = 'Nelly'

  LastName  = 'Eriksen'

  DisplayName = "Nelly J. Eriksen"

  Department = "Research"

  GivenName= "Nelly"

  Title = "Research Manager"

  StreetAddress = "Hafnarbraut 42"

  UserPrincipalName = "Nelly.Eriksen@vlabs8.com"
  
  SamAccountName = "Nelly.Eriksen"

  UPN = "Nelly.Eriksen@vlabs8.com"

  OU = "OU=Research,DC=vlabs8,DC=com"

  Email = "Nelly.Eriksen@vlabs8.com"

  City = "Bergen"

  Country = "NO"

  MobilePhone = "5551234" `


  }

  

  )

  $employees | Export-Csv -Path C:\Employees2.csv