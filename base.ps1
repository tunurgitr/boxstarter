# ref: https://gist.github.com/ghostinthewires/033276015ba9d58d1f162e7fd47cdbd3

$Boxstarter.RebootOk=$true
$Boxstarter.NoPassword=$false
$Boxstarter.AutoLogin=$true

$ChocoCachePath = "c:\temp"
New-Item -Path $ChocoCachePath -ItemType directory -Force

Update-ExecutionPolicy Unrestricted
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder
if (Test-PendingReboot) { Invoke-Reboot }

# Update Windows and reboot if necessary
Install-WindowsUpdate -AcceptEula
if (Test-PendingReboot) { Invoke-Reboot }

Enable-WindowsOptionalFeature -online -all -norestart -featurename Microsoft-Hyper-V-All
Enable-WindowsOptionalFeature -Online -all -norestart -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -all -norestart -FeatureName VirtualMachinePlatform
cinst TelnetClient -source windowsFeatures

if (Test-PendingReboot) { Invoke-Reboot }

# windows config

# Privacy: Let apps use my advertising ID: Disable
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
    New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo | Out-Null
}
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0

# WiFi Sense: HotSpot Sharing: Disable
If (-Not (Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
    New-Item -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting | Out-Null
}
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name value -Type DWord -Value 0

# WiFi Sense: Shared HotSpot Auto-Connect: Disable
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name value -Type DWord -Value 0

# Start Menu: Disable Bing Search Results
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows Search' -Name 'Windows Search' -ItemType Key
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name AllowCortana -Type DWORD -Value 0
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name BingSearchEnabled -Type DWORD -Value 0
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name ConnectedSearchUseWeb -Type DWORD -Value 0
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name DisableWebSearch -Type DWORD -Value 1

# Start Menu: Disable Cortana 
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Windows Search' -ItemType Key
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name AllowCortana -Type DWORD -Value 0

# Disable the Lock Screen (the one before password prompt - to prevent dropping the first character)
If (-Not (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization)) {
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name Personalization | Out-Null
}
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -Name NoLockScreen -Type DWord -Value 1


# Disable Xbox Gamebar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name AppCaptureEnabled -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name GameDVR_Enabled -Type DWord -Value 0

# Disable news and interests
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Name ShellFeedsTaskbarViewMode -Type DWORD -Value 2

# Disable search toolbar
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name SearchTaskbarMode -Type DWORD -Value 0


# Turn off People in Taskbar
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
    New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name PeopleBand -Type DWord -Value 0


Disable-BingSearch
Disable-GameBarTips

# Browsers
cinst --cachelocation $ChocoCachePath googlechrome
cinst --cachelocation $ChocoCachePath  firefox

# Runtimes and SDKs
cinst --cachelocation $ChocoCachePath  dotnet
cinst --cachelocation $ChocoCachePath  dotnet-sdk
cinst --cachelocation $ChocoCachePath  dotnetcore-3.1-runtime
cinst --cachelocation $ChocoCachePath  dotnetcore-3.1-sdk
cinst --cachelocation $ChocoCachePath  dotnetcore-2.1-runtime
cinst --cachelocation $ChocoCachePath  dotnetcore-2.1-sdk

# Utils
cinst --cachelocation $ChocoCachePath  7zip
cinst --cachelocation $ChocoCachePath  greenshot
cinst --cachelocation $ChocoCachePath  chocolateygui
# cinst keepass.install

# Dev tools
cinst --cachelocation $ChocoCachePath  git
cinst --cachelocation $ChocoCachePath  poshgit
cup --cacheLocation $ChocoCachePath git-credential-manager-for-windows
# cinst sourcetree
cinst --cachelocation $ChocoCachePath  winmerge
cinst --cachelocation $ChocoCachePath  dottrace
cinst --cachelocation $ChocoCachePath  visualstudiocode
cinst --cachelocation $ChocoCachePath  prefix
cinst --cachelocation $ChocoCachePath  nuget.commandline
cinst --cachelocation $ChocoCachePath  nugetpackageexplorer
cinst --cachelocation $ChocoCachePath  nodejs --version=12.22.1 --force -y
cinst --cachelocation $ChocoCachePath  yarn
cinst --cachelocation $ChocoCachePath  bitwarden
cup --cacheLocation $ChocoCachePath postman
cup --cacheLocation $ChocoCachePath openssl.light

##############
# PowerShell
##############

# Installing Azure PowerShell modules
Install-Module -Name AzureRM -Scope AllUsers
Install-Module -Name Azure -Scope AllUsers -AllowClobber


#############################
# Runtime Environments & SDKs
#############################

# Ghostscript
cup ghostscript --cacheLocation $ChocoCachePath

#Install Go
cup golang --cacheLocation $ChocoCachePath

# Install Java Runtime
cup javaruntime --cacheLocation $ChocoCachePath

# Install JDK 8
cup jdk8 --cacheLocation $ChocoCachePath

# Install Python 2/3
cup python2 --cacheLocation $ChocoCachePath
cup python3 --cacheLocation $ChocoCachePath

###########################
# vscode and associated
############################
cinst --cachelocation $ChocoCachePath  vscode 
choco pin add -n=vscode
refreshenv
code --install-extension apollographql.vscode-apollo
code --install-extension k--kato.docomment
code --install-extension ms-dotnettools.csharp
code --install-extension jchannon.csharpextensions
code --install-extension ms-azuretools.vscode-docker
code --install-extension dbaeumer.vscode-eslint
code --install-extension eamodio.gitlens
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension bierner.markdown-emoji
code --install-extension bierner.markdown-mermaid
code --install-extension tintoy.msbuild-project-tools
code --install-extension ms-vscode.powershell
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension craigthomas.supersharp
code --install-extension redhat.vscode-yaml
code --install-extension octref.vetur
choco install openinvscode
# cinst python

# Ops tools
cinst --cachelocation $ChocoCachePath  sysinternals
cinst --cachelocation $ChocoCachePath  mremoteng

# K8s tools
cinst --cachelocation $ChocoCachePath  lens

# Web tools
# cinst fiddler4
# cinst ngrok.portable

########
# Azure
########

# Install Azure cli
cup  --cacheLocation $ChocoCachePath azure-cli

# Install azcopy
cup  --cacheLocation $ChocoCachePathazcopy

# Install Microsoft Azure Storage Explorer
cup  --cacheLocation $ChocoCachePathmicrosoftazurestorageexplorer

# Install Microsoft Azure ServiceBus Explorer
cup  --cacheLocation $ChocoCachePathservicebusexplorer


# Communication
cinst --cachelocation $ChocoCachePath  slack
cinst --cachelocation $ChocoCachePath  microsoft-teams

# Office
cinst --cachelocation $ChocoCachePath  -y office365business --params='/productId:"O365ProPlusRetail" /updates:"TRUE"'

# Databases
cinst --cachelocation $ChocoCachePath  sql-server-express
cinst --cachelocation $ChocoCachePath  sql-server-management-studio
cinst --cachelocation $ChocoCachePath  microsoftazurestorageexplorer
cinst --cachelocation $ChocoCachePath  azure-data-studio
cinst --cachelocation $ChocoCachePath  azure-data-studio-sql-server-admin-pack
cinst --cachelocation $ChocoCachePath  sqlsearch  # << package maybe not working

#visual studio
cinst --cachelocation $ChocoCachePath  visualstudio2019professional
cinst --cachelocation $ChocoCachePath  visualstudio2019-workload-manageddesktop
cinst --cachelocation $ChocoCachePath  visualstudio2019-workload-netcoretools 
cinst --cachelocation $ChocoCachePath  visualstudio2019-workload-netweb 
cinst --cachelocation $ChocoCachePath  visualstudio2019-workload-databuildtools
cinst --cachelocation $ChocoCachePath  visualstudio2019-workload-nodebuildtools
cinst --cachelocation $ChocoCachePath  visualstudio2019-workload-node
cinst --cachelocation $ChocoCachePath  visualstudio2019-workload-datascience
cinst --cachelocation $ChocoCachePath  visualstudio2019-workload-universalbuildtools

# wsl
cinst --cachelocation $ChocoCachePath  -y wsl2
wsl --set-default-version 2
if (-not (Get-AppxPackage CanonicalGroupLimited.Ubuntu20.04onWindows)) {
    Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
    Add-AppxPackage .\Ubuntu.appx
}

# docker
cinst --cachelocation $ChocoCachePath  -y docker-for-windows

# remove bad stuff

# Bing Weather, News, Sports, and Finance (Money):
Get-AppxPackage Microsoft.BingFinance | Remove-AppxPackage
Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage Microsoft.BingSports | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage

# xbox garbage
Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage
Get-AppxPackage Microsoft.GetHelp | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxGameOverlay | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxTCUI | Remove-AppxPackage
Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage
Get-AppxPackage Microsoft.Zune* | Remove-AppxPackage
Get-AppxPackage DellInc.PartnerPromo | Remove-AppxPackage
Get-AppxPackage *Solitaire* | Remove-AppxPackage


Invoke-Reboot