Admin command prompt
```
# install boxstarter from admin command prompt
. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
```



From an admin powershell prompt
```
$creds = Get-Credential
Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/tunurgitr/boxstarter/main/base.ps1 -Credential $cred
```