# ----------------------------------------
# Header
# ----------------------------------------

# Author: LukeHjo (Azrael)
# Description: Installs the shell configuration for Windows Terminal & subshells.
# Version: 1.2.3
# Date: 2024-01-04

# ----------------------------------------
# Variables
# ----------------------------------------

$installationKey = "HKCU:\Software\Azrael\Packages"

# ----------------------------------------
# Admin
# ----------------------------------------

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator. Exiting..."
    exit
}

# ----------------------------------------
# Functions
# ----------------------------------------

function InstallScoopPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageName
    )

    if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host "Scoop is not installed. Installing..."
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    }

    Write-Host "Installing $PackageName..."
    scoop install $PackageName
}

function InstallChocolateyPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PackageName
    )

    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Chocolatey is not installed. Installing..."
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')
    }

    Write-Host "Installing $PackageName..."
    choco install $PackageName -y
}

if ((Get-ItemProperty -Path $installationKey -Name Installed).Installed -eq 1) {
    Write-Host "Packages are already installed. Exiting..."
}
else {
    Write-Host "Packages are not installed. Installing..."
    if (-not (Test-Path $installationKey)) {
        New-Item -Path $installationKey -Force
    }
    New-ItemProperty -Path $installationKey -Name Installed -Value 1 -PropertyType DWORD -Force

    Write-Host "Microsoft Windows [Version $($KernelVersion)]" # Fun. I like it.
    Write-Host "(c) Microsoft Corporation. All rights reserved.`n"
    Write-Host "Copyright (c) 2023-2024 Azrael"
    Write-Host "https://github.com/luke-beep/shell-config/`n"
    
    Write-Host "This script doesn't cover Winget packages. Please install them manually."

    InstallScoopPackage 7zip
    InstallScoopPackage btop
    InstallScoopPackage dark
    InstallScoopPackage fastfetch
    InstallScoopPackage gh
    InstallScoopPackage git
    InstallScoopPackage git-crypt
    InstallScoopPackage git-lfs
    InstallScoopPackage git-quick-stats
    InstallScoopPackage neofetch
    InstallScoopPackage nvm
    InstallScoopPackage ntop
    InstallScoopPackage oh-my-posh
    InstallScoopPackage posh-git
    InstallScoopPackage python
    InstallScoopPackage scoop-search
    InstallScoopPackage starship
    InstallScoopPackage touch
    InstallScoopPackage vim
    InstallScoopPackage neovim
    InstallScoopPackage winget
    InstallScoopPackage zip
    InstallScoopPackage clink

    InstallChocolateyPackage firefox
    InstallChocolateyPackage gimp
    InstallChocolateyPackage libreoffice
    InstallChocolateyPackage librewolf
    InstallChocolateyPackage sysinternals
    InstallChocolateyPackage ripgrep

    Write-Host "Packages are now installed."
}

# ----------------------------------------
# Footer
# ----------------------------------------