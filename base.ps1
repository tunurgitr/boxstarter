# ref: https://gist.github.com/ghostinthewires/033276015ba9d58d1f162e7fd47cdbd3

$Boxstarter.RebootOk=$true
$Boxstarter.NoPassword=$false
$Boxstarter.AutoLogin=$true

$ChocoCachePath = "c:\temp"
New-Item -Path $ChocoCachePath -ItemType directory -Force

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

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
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name SearchboxTaskbarMode -Type DWORD -Value 0


# Turn off People in Taskbar
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
    New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name PeopleBand -Type DWord -Value 0


Disable-BingSearch
Disable-GameBarTips

# Browsers
cup -y --cachelocation $ChocoCachePath googlechrome
cup -y --cachelocation $ChocoCachePath firefox

# Runtimes and SDKs
cup -y --cachelocation $ChocoCachePath  dotnet
cup -y --cachelocation $ChocoCachePath  dotnet-sdk
cup -y --cachelocation $ChocoCachePath  dotnet-6.0-sdk
cup -y --cachelocation $ChocoCachePath  dotnet-6.0-runtime
cup -y --cachelocation $ChocoCachePath  dotnet-5.0-sdk
cup -y --cachelocation $ChocoCachePath  dotnet-5.0-runtime
cup -y --cachelocation $ChocoCachePath  dotnetcore-3.1-runtime
cup -y --cachelocation $ChocoCachePath  dotnetcore-3.1-sdk
cup -y --cachelocation $ChocoCachePath  dotnetcore-2.1-runtime
cup -y --cachelocation $ChocoCachePath  dotnetcore-2.1-sdk

# Utils
cup -y --cachelocation $ChocoCachePath  7zip
cup -y --cachelocation $ChocoCachePath  sharex
cup -y --cachelocation $ChocoCachePath  chocolateygui
# cinst keepass.install

# Dev tools
cup -y --cachelocation $ChocoCachePath git
cup -y --cachelocation $ChocoCachePath poshgit
cup -y --cacheLocation $ChocoCachePath git-credential-manager-for-windows
# cinst sourcetree
cup -y --cachelocation $ChocoCachePath winmerge
cup -y --cachelocation $ChocoCachePath dottrace
cup -y --cachelocation $ChocoCachePath visualstudiocode
cup -y --cachelocation $ChocoCachePath prefix
cup -y --cachelocation $ChocoCachePath nuget.commandline
cup -y --cachelocation $ChocoCachePath nugetpackageexplorer
cup -y --cachelocation $ChocoCachePath nodejs --version=14.21.3
cup -y --cachelocation $ChocoCachePath nodejs --version=16.20.0
cup -y --cachelocation $ChocoCachePath yarn
cup -y --cachelocation $ChocoCachePath bitwarden
cup -y --cacheLocation $ChocoCachePath postman
cup -y --cacheLocation $ChocoCachePath openssl.light

##############
# PowerShell
##############

# Installing Azure PowerShell modules
Install-Module -Name AzureRM -Scope AllUsers -Repository PSGallery
Install-Module -Name Azure -Scope AllUsers -Repository PSGallery -AllowClobber


#############################
# Runtime Environments & SDKs
#############################

# Ghostscript
cup -y --cacheLocation $ChocoCachePath ghostscript

#Install Go
cup -y --cacheLocation $ChocoCachePath golang

# Install Java Runtime
cup -y --cacheLocation $ChocoCachePath openjdk

# Install Python 2/3
cup -y --cacheLocation $ChocoCachePath python2
cup -y --cacheLocation $ChocoCachePath python3

###########################
# vscode and associated
############################
cup -y --cachelocation $ChocoCachePath  vscode 
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
code --install-extension ms-python.python
code --install-extension ms-toolsai.jupyter
code --install-extension ms-toolsai.vscode-jupyter-slideshow
code --install-extension visualstudioexptteam.vscodeintellicode


# copilot
code --install-extension github.copilot
code --install-extension github.copilot-labs

cup -y --cachelocation $ChocoCachePath openinvscode
# cinst python

# Ops tools
cup -y --cachelocation $ChocoCachePath sysinternals
cup -y --cachelocation $ChocoCachePath mremoteng

# K8s tools
cup -y --cachelocation $ChocoCachePath lens

# Web tools
# cinst fiddler4
# cinst ngrok.portable

########
# Azure
########

# Install Azure cli
cup -y --cacheLocation $ChocoCachePath azure-cli

# Install azcopy
cup -y --cacheLocation $ChocoCachePath azcopy

# Install Microsoft Azure Storage Explorer
cup -y --cacheLocation $ChocoCachePath microsoftazurestorageexplorer

# Install Microsoft Azure ServiceBus Explorer
cup -y --cacheLocation $ChocoCachePath servicebusexplorer


# Communication
cup -y --cachelocation $ChocoCachePath slack
cup -y --cachelocation $ChocoCachePath microsoft-teams

# Office
cup -y --cachelocation $ChocoCachePath  -y office365business --params='/productId:"O365ProPlusRetail" /updates:"TRUE"'

# Databases
cup -y --cachelocation $ChocoCachePath  sql-server-express
cup -y --cachelocation $ChocoCachePath  sql-server-management-studio
cup -y --cachelocation $ChocoCachePath  microsoftazurestorageexplorer
cup -y --cachelocation $ChocoCachePath  azure-data-studio
cup -y --cachelocation $ChocoCachePath  azure-data-studio-sql-server-admin-pack

#visual studio
cup -y --cachelocation $ChocoCachePath  visualstudio2022professional
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-data
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-netweb
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-webbuild
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-azure
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-azurebuildtools
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-databuildtools
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-nativecrossplat
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-nativemobile
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-netcrossplat
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-node
cup -y --cachelocation $ChocoCachePath  visualstudio2022-workload-python

# jetbrains
cup -y --cachelocation $ChocoCachePath  jetbrains-rider
cup -y --cachelocation $ChocoCachePath  resharper-platform

cup -y --cachelocation $ChocoCachePath  obsidian

# wsl
cup -y --cachelocation $ChocoCachePath  wsl2
wsl --set-default-version 2
if (-not (Get-AppxPackage CanonicalGroupLimited.Ubuntu20.04onWindows)) {
    Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
    Add-AppxPackage .\Ubuntu.appx
}

# docker
cup -y --cachelocation $ChocoCachePath  docker-for-windows

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
