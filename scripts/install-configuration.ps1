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
$ompConfig = "$env:USERPROFILE\.config\omp.json"
$installationKey = "HKCU:\Software\Azrael\Configuration"
$KernelVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Version

# ----------------------------------------
# Start
# ----------------------------------------

if ((Get-ItemProperty -Path $installationKey -Name Installed).Installed -eq 1) {
    Remove-Item -Path 'HKCU:\Software\Azrael' -Force -Recurse
    $PROFILE | Split-Path | Get-ChildItem | Remove-Item -Force -Recurse
    if ($ShellType -eq "PowerShell") {
        pwsh -Command "`$PROFILE | Split-Path | Get-ChildItem | Remove-Item -Force -Recurse" 
    }
    else {
        powershell -Command "`$PROFILE | Split-Path | Get-ChildItem | Remove-Item -Force -Recurse"
    }
    Write-Host "Shell configuration is already installed. Exiting... re-run the script to reinstall."
}
else {
    Write-Host "Shell configuration is not installed. Installing..."
    if (-not (Test-Path $installationKey)) {
        New-Item -Path $installationKey -Force
    }
    New-ItemProperty -Path $installationKey -Name Installed -Value 1 -PropertyType DWORD -Force

    Write-Host "Microsoft Windows [Version $($KernelVersion)]" # Fun. I like it.
    Write-Host "(c) Microsoft Corporation. All rights reserved.`n"
    Write-Host "Copyright (c) 2023-2024 Azrael"
    Write-Host "https://github.com/luke-beep/shell-config/`n"
    
    Write-Host "This script covers the following shells: PowerShell, PowerShell Core, Windows Terminal & Command Prompt/Clink."

    Write-Host "Installing the necessary packages..."
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/luke-beep/shell-config/master/scripts/packages/install-packages.ps1 | Invoke-Expression

    Write-Host "Applying Windows Terminal settings..."
    Invoke-WebRequest -Uri https://github.com/luke-beep/shell-config/raw/main/configs/terminal/settings.json -OutFile $TerminalSettingsPath
    Write-Host "Warning: These settings may cause issues with Windows Terminal. Please check the settings.json file in $TerminalSettingsPath. If you encounter any issues, please open an issue on GitHub."

    Write-Host "Installing the oh-my-posh theme for Clink..."
    if (-not (Test-Path $ompConfig)) {
        New-Item -Path $ompConfig -Force 
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/omp/theme.json -OutFile $ompConfig
    }
    Invoke-WebRequest -Uri https://github.com/luke-beep/shell-config/raw/main/configs/clink/oh-my-posh.lua -OutFile $ClinkThemePath

    Write-Host "Installing the $ShellType configuration..."
    Invoke-WebRequest -Uri https://github.com/luke-beep/shell-config/raw/main/configs/pwsh/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE
    if ($ShellType -eq "PowerShell") {
        pwsh -Command "Invoke-WebRequest -Uri https://github.com/luke-beep/shell-config/raw/main/configs/pwsh/Microsoft.PowerShell_profile.ps1 -OutFile `$PROFILE"
    }
    else {
        powershell -Command "Invoke-WebRequest -Uri https://github.com/luke-beep/shell-config/raw/main/configs/pwsh/Microsoft.PowerShell_profile.ps1 -OutFile `$PROFILE"
    }

    Write-Host "Installation complete. Please restart your shell."
}

# ----------------------------------------
# End
# ----------------------------------------