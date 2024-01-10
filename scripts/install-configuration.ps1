# ----------------------------------------
# Header
# ----------------------------------------

# Author: LukeHjo (Azrael)
# Description: Installs the shell configuration for Windows Terminal & subshells.

# ----------------------------------------
# Variables
# ----------------------------------------

$ShellType = if ($host.Version.Major -ge 7) { "Pwsh" } else { "PowerShell" }
$TerminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$ClinkThemePath = "$env:SystemDrive\Program Files (x86)\clink\oh-my-posh.lua"
$OmpConfig = "$env:USERPROFILE\.config\omp.json"
$installationKey = "HKCU:\Software\Azrael\Configuration"
$KernelVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Version

# ----------------------------------------
# Admin
# ----------------------------------------

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator. Exiting..."
    exit
}

# ----------------------------------------
# Start
# ----------------------------------------

if (((Get-ItemProperty -Path $installationKey -Name "$($ShellType)Installed")."$($ShellType)Installed") -eq 1) {
    Remove-Item -Path "HKCU:\Software\Azrael\$($ShellType)" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path $installationKey -Name "$($ShellType)Installed" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$($PROFILE | Split-Path)\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "Shell configuration is already installed. Exiting... re-run the script to reinstall."
    exit
} 
else {
    Write-Host "Shell configuration is not installed. Installing..."
    if (-not (Test-Path $installationKey)) {
        New-Item -Path $installationKey -Force
    }

    if (-not (Test-Path $PROFILE)) {
        New-Item -Path $PROFILE -Force
    }

    Write-Host "Microsoft Windows [Version $($KernelVersion)]" # Fun. I like it.
    Write-Host "(c) Microsoft Corporation. All rights reserved.`n"
    Write-Host "Copyright (c) 2023-2024 Azrael"
    Write-Host "https://github.com/luke-beep/shell-config/`n"
    
    Write-Host "This script covers the following shells: PowerShell, PowerShell Core, Windows Terminal & Command Prompt/Clink."

    Write-Host "Applying Windows Terminal settings..."
    Invoke-WebRequest -Uri https://github.com/luke-beep/shell-config/raw/main/configs/terminal/settings.json -OutFile $TerminalSettingsPath
    Write-Host "Warning: These settings may cause issues with Windows Terminal. Please check the settings.json file in $TerminalSettingsPath. If you encounter any issues, please open an issue on GitHub."

    Write-Host "Installing the oh-my-posh theme for Clink..."
    if (-not (Test-Path $OmpConfig)) {
        New-Item -Path $OmpConfig -Force 
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/omp/theme.json -OutFile $OmpConfig
    }
    Invoke-WebRequest -Uri https://github.com/luke-beep/shell-config/raw/main/configs/clink/oh-my-posh.lua -OutFile $ClinkThemePath

    Write-Host "Installing the $ShellType configuration..."
    Invoke-WebRequest -Uri https://github.com/luke-beep/shell-config/raw/main/configs/pwsh/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE

    Write-Host "Installing the necessary packages..."
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -Command `"& { Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/luke-beep/shell-config/main/scripts/packages/install-packages.ps1') }`""

    Write-Host "Installation complete. Please restart your shell."
    New-ItemProperty -Path $installationKey -Name "$($ShellType)Installed" -Value 1 -PropertyType DWORD -Force
}

# ----------------------------------------
# End
# ----------------------------------------