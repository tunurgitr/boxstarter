
$Boxstarter.RebootOk=$true
$Boxstarter.NoPassword=$false
$Boxstarter.AutoLogin=$true

Update-ExecutionPolicy Unrestricted
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder
if (Test-PendingReboot) { Invoke-Reboot }

# Update Windows and reboot if necessary
Install-WindowsUpdate -AcceptEula
if (Test-PendingReboot) { Invoke-Reboot }

Enable-WindowsOptionalFeature -online -all -norestart -featurename Microsoft-Hyper-V-All
Enable-WindowsOptionalFeature -Online -all -norestart -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -all -norestart -FeatureName VirtualMachinePlatform

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
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Name ShellFeedsTaskbarViewMode -Type DWORD -Value 2

Disable-BingSearch
Disable-GameBarTips

# Browsers
cinst googlechrome
cinst firefox

# Runtimes and SDKs
cinst dotnet
cinst dotnet-sdk
cinst dotnetcore-3.1-runtime
cinst dotnetcore-3.1-sdk
cinst dotnetcore-2.1-runtime
cinst dotnetcore-2.1-sdk

# Utils
cinst 7zip
cinst greenshot
cinst chocolateygui
# cinst keepass.install

# Dev tools
cinst git
cinst poshgit
# cinst sourcetree
cinst winmerge
cinst dottrace
cinst visualstudiocode
cinst prefix
cinst nuget.commandline
cinst nugetpackageexplorer
cinst nodejs-lts
cinst yarn
cinst bitwarden

# vscode and associated
cinst vscode 
choco pin add -n=vscode
refreshenv
code --install-extension apollographql.vscode-apollo
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
cinst sysinternals
cinst mremoteng

# K8s tools
cinst lens

# Web tools
# cinst fiddler4
# cinst ngrok.portable

# Communication
cinst slack
cinst microsoft-teams

# Databases
cinst sql-server-express
cinst sql-server-management-studio
cinst microsoftazurestorageexplorer
cinst azure-data-studio
cinst azure-data-studio-sql-server-admin-pack
cinst sqlsearch  # << package maybe not working

cinst visualstudio2019professional
cinst visualstudio2019-workload-manageddesktop
cinst visualstudio2019-workload-netcoretools 
cinst visualstudio2019-workload-netweb 
cinst visualstudio2019-workload-databuildtools
cinst visualstudio2019-workload-nodebuildtools
cinst visualstudio2019-workload-node
cinst visualstudio2019-workload-datascience
cinst visualstudio2019-workload-universalbuildtools


wsl --set-default-version 2
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile Ubuntu.appx -UseBasicParsing
Add-AppxPackage .\Ubuntu.appx

# docker
cinst -y docker-for-windows

# remove bad stuff

# Bing Weather, News, Sports, and Finance (Money):
Get-AppxPackage Microsoft.BingFinance | Remove-AppxPackage
Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage Microsoft.BingSports | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage
