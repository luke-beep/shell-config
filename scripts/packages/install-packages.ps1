Set-ExecutionPolicy Bypass -Scope Process -Force

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

function InstallAllPackages {
    Write-Host "Microsoft Windows [Version $($KernelVersion)]"
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

    InstallChocolateyPackage firefox
    InstallChocolateyPackage gimp
    InstallChocolateyPackage libreoffice
    InstallChocolateyPackage librewolf
    InstallChocolateyPackage sysinternals
    InstallChocolateyPackage ripgrep

    Write-Host "All packages installed."
}

# Initialize and run
InstallAllPackages
