### Base Windows Configuration ###

# Enable Windows Features...
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -NoRestart
Enable-WindowsOptionalFeature -FeatureName Containers -Online -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart

### Chocolatey Installs ###

# Install Chocolatey: https://chocolatey.org/install
Set-ExecutionPolicy AllSigned; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Enable Chocolatey Autoconfirm
choco feature enable -n allowGlobalConfirmation

# Install Boxstarter: http://boxstarter.org/InstallBoxstarter
cinst -y boxstarter

