
$Boxstarter.RebootOk=$true
$Boxstarter.NoPassword=$false
$Boxstarter.AutoLogin=$true

Update-ExecutionPolicy Unrestricted
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder
if (Test-PendingReboot) { Invoke-Reboot }

# Update Windows and reboot if necessary
Install-WindowsUpdate -AcceptEula
if (Test-PendingReboot) { Invoke-Reboot }

Enable-WindowsOptionalFeature -online -featurename Microsoft-Hyper-V-All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

if (Test-PendingReboot) { Invoke-Reboot }
lxrun /install /y

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
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0

# Start Menu: Disable Cortana 
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Windows Search' -ItemType Key
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name AllowCortana -Type DWORD -Value 0

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
choco install microsoftazurestorageexplorer
choco install azure-data-studio
choco install azure-data-studio-sql-server-admin-pack
cinst sqlsearch  # << package maybe not working

choco install visualstudio2019professional
choco install visualstudio2019-workload-manageddesktop
choco install visualstudio2019-workload-netcoretools 
choco install visualstudio2019-workload-netweb 
choco install visualstudio2019-workload-databuildtools
choco install visualstudio2019-workload-nodebuildtools
choco install visualstudio2019-workload-node
choco install visualstudio2019-workload-datascience
choco install visualstudio2019-workload-universalbuildtools


# docker
choco install -y docker-for-windows