# ----------------------------------------
# Profile Information
# ----------------------------------------

# Author: LukeHjo (Azrael)
# Description: This is my PowerShell profile. It contains aliases and functions that I use on a daily basis.
# Version: 1.0.0
# Date: 2023-12-26

# ----------------------------------------
# Profile Initialization
# ----------------------------------------
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$nord0 = [System.Drawing.ColorTranslator]::FromHtml("#2E3440") # Polar Night
$nord1 = [System.Drawing.ColorTranslator]::FromHtml("#3B4252")
$nord2 = [System.Drawing.ColorTranslator]::FromHtml("#434C5E")
$nord3 = [System.Drawing.ColorTranslator]::FromHtml("#4C566A")
$nord4 = [System.Drawing.ColorTranslator]::FromHtml("#D8DEE9") # Snow Storm
$nord5 = [System.Drawing.ColorTranslator]::FromHtml("#E5E9F0")
$nord6 = [System.Drawing.ColorTranslator]::FromHtml("#ECEFF4")
$nord7 = [System.Drawing.ColorTranslator]::FromHtml("#8FBCBB") # Frost
$nord8 = [System.Drawing.ColorTranslator]::FromHtml("#88C0D0")
$nord9 = [System.Drawing.ColorTranslator]::FromHtml("#81A1C1")
$nord10 = [System.Drawing.ColorTranslator]::FromHtml("#5E81AC")
$nord11 = [System.Drawing.ColorTranslator]::FromHtml("#BF616A") # Aurora
$nord12 = [System.Drawing.ColorTranslator]::FromHtml("#D08770")
$nord13 = [System.Drawing.ColorTranslator]::FromHtml("#EBCB8B")
$nord14 = [System.Drawing.ColorTranslator]::FromHtml("#A3BE8C")
$nord15 = [System.Drawing.ColorTranslator]::FromHtml("#B48EAD")

function Auto-Update {
  $keyPath = 'HKCU:\Software\Azrael\PowerShell'
  $version = Get-ItemProperty -Path $keyPath -Name 'Version' -ErrorAction SilentlyContinue
  $currentVersion = $version.Version
  $latestVersion = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/version'
  if ($currentVersion -ne $latestVersion) {
    Write-Host "A new version of the profile is available. Would you like to update? (Y/N)"
    $input = Read-Host
    if ($input -eq "Y") {
      Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
      New-ItemProperty -Path $keyPath -Name 'Version' -Value $latestVersion -PropertyType 'String' -Force | Out-Null
      Restart-Shell
    }
  }
}

function Init {
  # Check for updates
  Auto-Update

  # Set the execution policy
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

  # Check for Scoop and install it if it's not installed
  $scoop = Get-Command -Name scoop -ErrorAction SilentlyContinue
  if (-not $scoop) {
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
  }

  # Check for Chocolatey and install it if it's not installed
  $choco = Get-Command -Name choco -ErrorAction SilentlyContinue
  if (-not $choco) {
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')
  }

  # Check for oh-my-posh and install it if it's not installed
  $omp = Get-Command -Name oh-my-posh -ErrorAction SilentlyContinue
  if (-not $omp) {
    scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
  }

  oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/omp/theme.json' | Invoke-Expression
  Clear-Host # Clear the screen

  $keyPath = 'HKCU:\Software\Azrael\PowerShell'
  $key = Get-ItemProperty -Path $keyPath -Name 'FirstRun' -ErrorAction SilentlyContinue

  $userName = $env:UserName
  if ($null -eq $key) {
    if (-not (Test-Path $keyPath)) {
      New-Item -Path $keyPath -Force | Out-Null
    }
    New-ItemProperty -Path $keyPath -Name 'FirstRun' -Value 0 -PropertyType 'DWord' -Force | Out-Null

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Welcome to PowerShell"
    $form.BackColor = $nord0
    $form.ForeColor = $nord4
    $form.Font = New-Object System.Drawing.Font("Arial", 10)
    $form.StartPosition = 'CenterScreen'
    $form.Size = New-Object System.Drawing.Size(400, 200)
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Hello, $userName! Welcome to PowerShell. `n`nFor guidance and to learn about available commands, type 'help'."
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Size = New-Object System.Drawing.Size(380, 80)
    $label.ForeColor = $nord6

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.BackColor = $nord3
    $okButton.ForeColor = $nord6
    $okButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $okButton.FlatAppearance.BorderSize = 0
    $okButton.Location = New-Object System.Drawing.Point(160, 120)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

    $form.Controls.Add($label)
    $form.Controls.Add($okButton)
    $form.AcceptButton = $okButton

    $form.ShowDialog()
  }
  Clear-Host
}
Init # Initialize the profile

# ----------------------------------------
# Functions
# ----------------------------------------

<#
.SYNOPSIS
   Gets all of the available packages
.DESCRIPTION 
   This function gets all of the available packages
#>
function Get-Packages {
  # check if scoop is installed
  $scoop = Get-Command -Name scoop -ErrorAction SilentlyContinue
  if ($scoop) {
    scoop list
  }
  # check if winget is installed
  $winget = Get-Command -Name winget -ErrorAction SilentlyContinue
  if ($winget) {
    winget list
  }
  # check if choco is installed
  $choco = Get-Command -Name choco -ErrorAction SilentlyContinue
  if ($choco) {
    choco list
  }
}

<#
.SYNOPSIS
   Gets the current shell information
.DESCRIPTION
   This function gets the current shell information
#>
function Get-ShellInfo {
  $version = $host.Version.Major
  $shellType = if ($version -ge 7) { "Pwsh" } else { "PowerShell" }
  $bitness = if ([Environment]::Is64BitProcess) { "64-bit" } else { "32-bit" }

  Write-Output "Profile Path: $PROFILE"
  Write-Output "Host Name: $($host.Name)"
  Write-Output "Host Version: $($host.Version) -> $($shellType) ($bitness)"
}

<#
.SYNOPSIS
   Refreshes the shell
.DESCRIPTION
   This function refreshes the shell
#>
function Refresh-Shell {
  pwsh
  refreshenv
  Clear-Host
}

<#
.SYNOPSIS
   Restarts the shell
.DESCRIPTION
   This function restarts the shell
#>
function Restart-Shell {
  $host.SetShouldExit() | Out-Null
  & powershell.exe -NoExit -Command ". '$PROFILE'"
}

<#
.SYNOPSIS
   Deletes a file or folder
.DESCRIPTION
   This function deletes a file or folder
.PARAMETER Path 
   The path of the file or folder
#>
function Trash-Item {
  param (
    [Parameter(Mandatory = $false)][string]$Path
  )

  if ($Path) {
    Remove-Item -Path $Path -Force
    Clear-Host
  }
}

<#
.SYNOPSIS
   Empties the recycle bin
.DESCRIPTION
   This function empties the recycle bin
#>
function Empty-RecycleBin {
  Clear-RecycleBin -Force
}

<#
.SYNOPSIS
   Gets the active processes
.DESCRIPTION
   This function gets the active processes
#>
function Active-Processes {
  Get-Process | Where-Object { $_.mainWindowTitle } | Format-Table `
  @{Label = "NPM(K)"; Expression = { [int]($_.NPM / 1024) } },
  @{Label = "PM(K)"; Expression = { [int]($_.PM / 1024) } },
  @{Label = "WS(K)"; Expression = { [int]($_.WS / 1024) } },
  @{Label = "VM(M)"; Expression = { [int]($_.VM / 1MB) } },
  @{Label = "CPU(s)"; Expression = { if ($_.CPU) { $_.CPU.ToString("N") } } },
  Id, ProcessName, StartTime, mainWindowTitle
}

<#
.SYNOPSIS
   Finds a process
.DESCRIPTION
   This function finds a process
.PARAMETER Name 
   The name of the process
#>
function Find-Process {
  param (
    [Parameter(Mandatory = $true)][string]$Name
  )

  Get-Process | Where-Object { $_.Name -like "*$Name*" } | Format-Table `
  @{Label = "NPM(K)"; Expression = { [int]($_.NPM / 1024) } },
  @{Label = "PM(K)"; Expression = { [int]($_.PM / 1024) } },
  @{Label = "WS(K)"; Expression = { [int]($_.WS / 1024) } },
  @{Label = "VM(M)"; Expression = { [int]($_.VM / 1MB) } },
  @{Label = "CPU(s)"; Expression = { if ($_.CPU) { $_.CPU.ToString("N") } } },
  Id, ProcessName, StartTime, mainWindowTitle
}

<#
.SYNOPSIS
   Kills a process
.DESCRIPTION
   This function kills a process    
.PARAMETER Name
   The name of the process
#>
function Kill-Process {
  param (
    [Parameter(Mandatory = $true)][string]$Name
  )

  Get-Process | Where-Object { $_.Name -like "*$Name*" } | Stop-Process -Force
}

<#
.SYNOPSIS
   Gets the current computer information
.DESCRIPTION
   This function gets the current computer information
#>
function Process-Information {
  Get-Process | Format-Table `
  @{Label = "NPM(K)"; Expression = { [int]($_.NPM / 1024) } },
  @{Label = "PM(K)"; Expression = { [int]($_.PM / 1024) } },
  @{Label = "WS(K)"; Expression = { [int]($_.WS / 1024) } },
  @{Label = "VM(M)"; Expression = { [int]($_.VM / 1MB) } },
  @{Label = "CPU(s)"; Expression = { if ($_.CPU) { $_.CPU.ToString("N") } } },
  Id, ProcessName, StartTime, mainWindowTitle, -AutoSize
}

<#
.SYNOPSIS
   Retrieves the currently installed updates
.DESCRIPTION
   This function retrieves the currently installed updates
#>
function Get-Updates {
  $updates = Get-WmiObject -Class Win32_QuickFixEngineering
  $updates | Format-Table `
  @{Label = "InstalledOn"; Expression = { if ($_.InstalledOn) { $_.InstalledOn.ToString("yyyy-MM-dd") } } },
  Description, HotFixID, InstalledBy, InstalledOn, ServicePackInEffect, Status, -AutoSize
}

<#
.SYNOPSIS
   Hacks a target
.DESCRIPTION
   This function hacks a target
.PARAMETER Target 
   The target
#>
function Hack-Target {
  param (
    [Parameter(Mandatory = $true)][string]$Target
  )

  $progress = 0
  $progressMax = 100
  $progressStep = 10
  $progressBar = [char]0x2588

  $job = Start-Job -ScriptBlock {
    $progress = 0
    $progressMax = 100
    $progressStep = 10

    while ($progress -lt $progressMax) {
      $progress += $progressStep
      Write-Progress -Activity "Hacking $Target" -Status "Progress: $progress%" -PercentComplete $progress
      Start-Sleep -Seconds 1
    }
  } -ArgumentList $Target

  while ($job.State -eq "Running") {
    Write-Host -NoNewline $progressBar
    Start-Sleep -Milliseconds 100
  }

  Write-Host
  Write-Host "Hacking complete!"
  Write-Host
  Write-Host "Target: $Target"
  Write-Host "Status: $($job.State)"
  Write-Host
}

<#
.SYNOPSIS
   Gets the current IP address and additional information
.DESCRIPTION
   This function gets the current IP address and additional information
#>
function Get-Extended-IpInfo {
  $ip = Invoke-RestMethod -Uri "https://api.ipify.org?format=json"
  $info = Invoke-RestMethod -Uri "http://ip-api.com/json/$($ip.ip)"
  Write-Host "IP: $($ip.ip)"
  Write-Host "Country: $($info.country)"
  Write-Host "Region: $($info.regionName)"
  Write-Host "City: $($info.city)"
  Write-Host "ISP: $($info.isp)"
}

<#
.SYNOPSIS
   Gets the current IP address
.DESCRIPTION
   This function gets the current IP address
#>
function Get-IP {
  $ip = Invoke-RestMethod -Uri "https://api.ipify.org?format=json"
  $ip.ip
}

<#
.SYNOPSIS
   Scans an IP address
.DESCRIPTION
   This function scans an IP address
.PARAMETER IP 
   The IP address
#>
function Scan-IP {
  param (
    [Parameter(Mandatory = $true)][string]$IP
  )

  $info = Invoke-RestMethod -Uri "http://ip-api.com/json/$($IP)"
  Write-Host "IP: $($IP)"
  Write-Host "Country: $($info.country)"
  Write-Host "Region: $($info.regionName)"
  Write-Host "City: $($info.city)"
  Write-Host "ISP: $($info.isp)"
}

<#
.SYNOPSIS
   Scans a range of ports
.DESCRIPTION
   This function scans a range of ports
.PARAMETER IP
   The IP address
.PARAMETER StartPort 
   The start port
.PARAMETER EndPort 
   The end port
#>
function Scan-Ports {
  param (
    [Parameter(Mandatory = $true)][string]$IP,
    [Parameter(Mandatory = $true)][int]$StartPort,
    [Parameter(Mandatory = $true)][int]$EndPort
  )

  for ($port = $StartPort; $port -le $EndPort; $port++) {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $success = $tcpClient.ConnectAsync($IP, $port).Wait(1000)
    $tcpClient.Close()
    if ($success) {
      Write-Host "Port $Port is open."
    }
    else {
      Write-Host "Port $Port is closed."
    }
  }
}

<#
.SYNOPSIS
   Deletes a folder
.DESCRIPTION
   This function uses robocopy to delete a folder.
.PARAMETER Destination
   The destination of the folder
#>
function Delete-Folder {
  param (
    [Parameter(Mandatory = $true)][string]$Destination
  )
  $Temp = [System.IO.Path]::GetTempPath()
  Remove-Item $Temp\Empty -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
  New-Item $Temp\Empty -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

  robocopy $Temp\Empty $Destination /mir | Out-Null

  Remove-Item $Destination -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
  Remove-Item $Temp\Empty -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
}

<#
.SYNOPSIS
   Copies a folder from source to destination
.DESCRIPTION
   This function uses robocopy to copy a folder from the source to the destination.
.PARAMETER Source
   The source of the folder
.PARAMETER Destination 
   The destination of the folder
#>
function Copy-Folder {
  param (
    [Parameter(Mandatory = $true)][string]$Source,
    [Parameter(Mandatory = $true)][string]$Destination
  )

  robocopy $Source $Destination /mir | Out-Null
}

<#
.SYNOPSIS
   Moves a folder from source to destination
.DESCRIPTION
   This function uses robocopy to move a folder from the source to the destination. 
   It then removes the source folder.
.PARAMETER Source
   The source folder
.PARAMETER Destination 
   The destination folder
#>
function Move-Folder {
  param (
    [Parameter(Mandatory = $true)][string]$Source,
    [Parameter(Mandatory = $true)][string]$Destination
  )

  robocopy $Source $Destination /mir | Out-Null
  Remove-Item $Source -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
}

<#
.SYNOPSIS
   Gets the size of an object
.DESCRIPTION
    This function gets the size of an object
.PARAMETER Path
    The path of the object
#>
function Object-Size {
  param (
    [Parameter(Mandatory = $true)][string]$Path
  )

  $size = (Get-ChildItem $Path -Recurse | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
  Write-Host "Size: $size bytes"
  Write-Host "Size: $(($size / 1KB)) KB"
  Write-Host "Size: $(($size / 1MB)) MB"
  Write-Host "Size: $(($size / 1GB)) GB"
}


<#
.SYNOPSIS
   Counts the number of files and folders in a folder
.DESCRIPTION
   This function counts the number of files and folders in a folder
.PARAMETER Path
   The path of the folder
#>
function Object-Count {
  param (
    [Parameter(Mandatory = $true)][string]$Path
  )

  $count = (Get-ChildItem $Path -Recurse | Measure-Object -Property Length -ErrorAction SilentlyContinue).Count
  Write-Host "Count: $count"
}

<#  
.SYNOPSIS
  Copies the current path to the clipboard
.DESCRIPTION
  This function copies the current path to the clipboard
#>
function Copy-Path {
  $path = (Get-Location).Path
  Set-Clipboard $path
}

<#
.SYNOPSIS
  Changes the current directory
.DESCRIPTION
  This function changes the current directory
.PARAMETER Path
  The path of the directory
#>
function Change-Directory {
  param (
    [Parameter(Mandatory = $false)][string]$Path
  )
  
  Push-Location $Path
  Get-ChildItem
}

<#
.SYNOPSIS
  Goes back to the previous directory
.DESCRIPTION
  This function goes back to the previous directory
#>
function Go-Back {
  Pop-Location
  Get-ChildItem
}

<#
.SYNOPSIS
  Searches for a specific file or folder in the current directory
.DESCRIPTION
  This function searches for a specific file or folder in the current directory
.PARAMETER ItemName
  The name of the item
#>
function Search-Item {
  param (
    [Parameter(Mandatory = $true)][string]$ItemName
  )
  
  Get-ChildItem -Path . -Recurse | Where-Object { $_.Name -like "*$ItemName*" }
}

<#
.SYNOPSIS
  Creates a new directory and navigates into it
.DESCRIPTION
  This function creates a new directory and navigates into it
  .PARAMETER DirectoryName
    The name of the directory
#>
function New-DirectoryAndNavigate {
  param (
    [Parameter(Mandatory = $true)][string]$DirectoryName
  )
  
  New-Item -ItemType Directory -Path $DirectoryName
  Set-Location -Path $DirectoryName
}

<#
.SYNOPSIS
  Removes the current directory
.DESCRIPTION
  This function removes the current directory
#>
function Remove-CurrentDirectory {
  $currentDirectory = Get-Location
  Set-Location -Path ..
  Remove-Item -Path $currentDirectory -Recurse -Force
}

<#
.SYNOPSIS
  Backs up the current workspace to a specified directory
.DESCRIPTION
  This function backs up the current workspace to a specified directory
#>
function Backup-Workspace {
  $BackupDirectory = "C:\Snapshots"

  $currentDirectory = Get-Location
  $backupPath = Join-Path -Path $BackupDirectory -ChildPath (Get-Date -Format "yyyy-MM-dd_HH-mm-ss")

  if (!(Test-Path -Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath | Out-Null
  }

  Copy-Item -Path "$currentDirectory\*" -Destination $backupPath -Recurse -Force
}

<#
.SYNOPSIS
   Updates all installed packages
.DESCRIPTION 
   This function updates all installed packages
#>
function Update-Packages {
  # check if scoop is installed
  $scoop = Get-Command -Name scoop -ErrorAction SilentlyContinue
  if ($scoop) {
    # update scoop
    scoop update *
  }
  # check if winget is installed
  $winget = Get-Command -Name winget -ErrorAction SilentlyContinue
  if ($winget) {
    winget upgrade --all
  }
  # check if choco is installed
  $choco = Get-Command -Name choco -ErrorAction SilentlyContinue
  if ($choco) {
    choco upgrade all -y
  }
}

<#
.SYNOPSIS
   Generates a system report
.DESCRIPTION
   This function generates a system report
#>
function Generate-System-Report {
  Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/GSR/main/GenerateSystemReport.ps1" | Invoke-Expression
}

<#
.SYNOPSIS
   Optimizes PowerShell assemblies
.DESCRIPTION
   This function optimizes PowerShell assemblies
#>
function Optimize-PowerShell {
  Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/ps-optimize-assemblies/main/optimize-assemblies.ps1" | Invoke-Expression
}

<#
.SYNOPSIS
   Activates Windows using MAS
.DESCRIPTION 
   This function activates Windows using MAS
#>
function Activate-Windows {
  Invoke-RestMethod https://massgrave.dev/get | Invoke-Expression
}

<#
.SYNOPSIS
   Allows you to manage your hosts file
.DESCRIPTION 
   This function allows you to manage your hosts file
#>
function Host-Entry-Manager {
  Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/HostEntryManager.ps1" | Invoke-Expression
}

<#
.SYNOPSIS
   Allows you to manage your DNS settings
.DESCRIPTION 
   This function allows you to manage your DNS settings
#>
function DNS-Changer {
  Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/DNSChanger.ps1" | Invoke-Expression
}

<#
.SYNOPSIS
   Allows you to manage your network adapters
.DESCRIPTION 
   This function allows you to manage your network adapters
#>
function Network-Adapter-Manager {
  Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/NetworkAdapterManager.ps1" | Invoke-Expression
}

<# 
.SYNOPSIS
   Disables Nagles algorithm
.DESCRIPTION 
   This function disables Nagles algorithm
#>
function Nagles {
  Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/NaglesAlgorithm.ps1" | Invoke-Expression
}

<#
.SYNOPSIS
   Allows you to emulate the Matrix rain effect
.DESCRIPTION 
   This function allows you to emulate the Matrix rain effect
#>
function Start-MatrixRain {
  $width = $host.UI.RawUI.BufferSize.Width
  $height = $host.UI.RawUI.BufferSize.Height
  $streams = 1..($width * 200) | ForEach-Object { @{ Position = Get-Random -Minimum 0 -Maximum $height; Speed = Get-Random -Minimum 1 -Maximum 2 } }
  
  $host.UI.RawUI.CursorSize = 0
  try {
    while ($true) {
      Clear-Host
      for ($i = 0; $i -lt $width; $i++) {
        $stream = $streams[$i]
        $stream.Position = ($stream.Position + $stream.Speed) % $height
        $host.UI.RawUI.CursorPosition = New-Object -TypeName System.Management.Automation.Host.Coordinates -ArgumentList $i, $stream.Position
        Write-Host (Get-Random -InputObject ('!'..'/' + ':'..'@' + '['..'`' + '{'..'~' + 0..9)) -NoNewline -ForegroundColor Green
      }
      Start-Sleep -Milliseconds 200
    } 
  }
  finally {
    Clear-Host
  }
}

<#
.SYNOPSIS
   Creates a file
.DESCRIPTION 
   This function creates a file
.PARAMETER Path
   The path of the file
#>
function Create-File {
  param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [Alias('FullName')]
    [string]$Path
  )

  process {
    if (Test-Path $Path) {
          (Get-Item -Path $Path).LastWriteTime = Get-Date
    }
    else {
      New-Item -ItemType File -Path $Path | Out-Null
    }
  }
}

<#
.SYNOPSIS
   Gets a programming joke
.DESCRIPTION 
   This function gets a programming joke
#>
function Get-ProgrammingJoke {
  $response = Invoke-RestMethod -Uri 'https://official-joke-api.appspot.com/jokes/programming/random'
  $joke = $response[0]
  Write-Output ("{0} {1}" -f $joke.setup, $joke.punchline)
}

<#
.SYNOPSIS
   Gets the status of all services
.DESCRIPTION 
   This function gets the status of all services
#>
function Get-ServiceStatus {
  Get-Service | ForEach-Object {
    $status = $_.Status
    $name = $_.Name
    $displayName = $_.DisplayName
    Write-Output ("{0} ({1}): {2}" -f $displayName, $name, $status)
  }
}

<#
.SYNOPSIS
   Searches DuckDuckGo
.DESCRIPTION 
   This function searches DuckDuckGo
.PARAMETER Query 
   The query to search for
#>
function Search-DuckDuckGo {
  param (
    [string]$Query
  )

  $encodedQuery = [System.Web.HttpUtility]::UrlEncode($Query)
  $url = "https://duckduckgo.com/?q=$encodedQuery&t=h_&ia=web"

  Start-Process $url
}

<#
.SYNOPSIS
   Useful links
.DESCRIPTION 
   This function displays useful links
#>
function Get-Links {
  $links = @(
    [PSCustomObject]@{
      Name = "NVIDIA Control Panel"
      Url  = "https://apps.microsoft.com/detail/9NF8H0H7WMLT"
    }
    [PSCustomObject]@{
      Name = "NVCleanstall"
      Url  = "https://www.techpowerup.com/download/techpowerup-nvcleanstall/"
    }
    [PSCustomObject]@{
      Name = "Display Driver Uninstaller"
      Url  = "https://www.guru3d.com/download/display-driver-uninstaller-download"
    }
    [PSCustomObject]@{
      Name = "NVIDIA Profile Inspector"
      Url  = "https://github.com/Orbmu2k/nvidiaProfileInspector/releases"
    }
    [PSCustomObject]@{
      Name = "MSI Afterburner"
      Url  = "https://www.guru3d.com/download/msi-afterburner-beta-download"
    }
    [PSCustomObject]@{
      Name = "MSI Utility V3"
      Url  = "https://www.mediafire.com/file/ewpy1p0rr132thk/MSI_util_v3.zip/file"
    }
    [PSCustomObject]@{
      Name = "Adwcleaner"
      Url  = "https://www.malwarebytes.com/adwcleaner"
    }
    [PSCustomObject]@{
      Name = "Autoruns"
      Url  = "https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns"
    }
    [PSCustomObject]@{
      Name = "BleachBit"
      Url  = "https://www.bleachbit.org/download"
    }
    [PSCustomObject]@{
      Name = "Bloatbox"
      Url  = "https://github.com/builtbybel/bloatbox/releases"
    }
    [PSCustomObject]@{
      Name = "BloatyNosy"
      Url  = "https://github.com/builtbybel/bloatbox/releases"
    }
    [PSCustomObject]@{
      Name = "CapFrameX"
      Url  = "https://www.capframex.com/download"
    }
    [PSCustomObject]@{
      Name = "CrystalDiskMark"
      Url  = "https://crystalmark.info/en/software/crystaldiskmark/"
    }
    [PSCustomObject]@{
      Name = "CTT WinUtil"
      Url  = "https://github.com/ChrisTitusTech/winutil"
    }
    [PSCustomObject]@{
      Name = "Display Driver Uninstaller"
      Url  = "https://www.guru3d.com/download/display-driver-uninstaller-download"
    }
    [PSCustomObject]@{
      Name = "DLSS Swapper"
      Url  = "https://github.com/beeradmoore/dlss-swapper/releases"
    }
    [PSCustomObject]@{
      Name = "HWiNFO"
      Url  = "https://www.hwinfo.com/download/"
    }
    [PSCustomObject]@{
      Name = "JunkCtrl"
      Url  = "https://github.com/builtbybel/JunkCtrl"
    }
    [PSCustomObject]@{
      Name = "OpenRGB"
      Url  = "https://openrgb.org/"
    }
    [PSCustomObject]@{
      Name = "Optimizer"
      Url  = "https://github.com/hellzerg/optimizer/releases"
    }
    [PSCustomObject]@{
      Name = "Park Control"
      Url  = "https://bitsum.com/parkcontrol/"
    }
    [PSCustomObject]@{
      Name = "Process Lasso"
      Url  = "https://bitsum.com/"
    }
    [PSCustomObject]@{
      Name = "Quick CPU"
      Url  = "https://coderbag.com/product/quickcpu"
    }
    [PSCustomObject]@{
      Name = "Rufus"
      Url  = "https://rufus.ie/downloads/"
    }
    [PSCustomObject]@{
      Name = "VCC Redist All-in-One"
      Url  = "https://www.techpowerup.com/download/visual-c-redistributable-runtime-package-all-in-one/"
    }
    [PSCustomObject]@{
      Name = "WizTree"
      Url  = "https://diskanalyzer.com/download"
    }
    [PSCustomObject]@{
      Name = "WPD"
      Url  = "https://wpd.app/"
    }
    [PSCustomObject]@{
      Name = "Intel Drivers"
      Url  = "https://www.intel.com/content/www/us/en/download-center/home.html"
    }
    [PSCustomObject]@{
      Name = "AMD Drivers"
      Url  = "https://www.amd.com/en/support"
    }
    [PSCustomObject]@{
      Name = "NVIDIA Drivers"
      Url  = "https://www.nvidia.com/Download/index.aspx"   
    }
    [PSCustomObject]@{
      Name = "Intel XTU"
      Url  = "https://downloadcenter.intel.com/download/29183/Intel-Extreme-Tuning-Utility-Intel-XTU-"   
    }
    [PSCustomObject]@{
      Name = "Sysinternals Suite"
      Url  = "https://learn.microsoft.com/en-us/sysinternals/downloads/"
    }
    [PSCustomObject]@{
      Name = "Windows 10 Image"
      Url  = "https://www.microsoft.com/en-us/software-download/windows10ISO"
    }
    [PSCustomObject]@{
      Name = "Windows 11 Image"
      Url  = "https://www.microsoft.com/en-us/software-download/windows11"
    }
    [PSCustomObject]@{
      Name = "TechPowerUp GPU-Z"
      Url  = "https://www.techpowerup.com/download/techpowerup-gpu-z/"
    }
    [PSCustomObject]@{
      Name = "TechPowerUp Downloads"
      Url  = "https://www.techpowerup.com/download/"
    }
    [PSCustomObject]@{
      Name = "HoneCTRL"
      Url  = "https://github.com/luke-beep/HoneCtrl"
    }
    [PSCustomObject]@{
      Name = "PowerToys"
      Url  = "https://github.com/microsoft/PowerToys"
    }
    [PSCustomObject]@{
      Name = "Pwsh Profile"
      Url  = "https://github.com/luke-beep/shell-config/blob/main/configs/pwsh/Microsoft.PowerShell_profile.ps1"
    }
    [PSCustomObject]@{
      Name = "Measure Sleep"
      Url  = "https://github.com/luke-beep/MeasureSleep/releases/tag/MeasureSleep"
    }
    [PSCustomObject]@{
      Name = "All About Windows"
      Url  = "https://github.com/luke-beep/all-about-windows"
    }
    [PSCustomObject]@{
      Name = "Zen"
      Url  = "https://github.com/luke-beep/zen"
    }
    ) | Sort-Object -Property Name

  $PanelWidth = 1000

  $form = New-Object System.Windows.Forms.Form
  $form.Text = "Useful Links"
  $form.BackColor = $nord0
  $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
  $form.StartPosition = 'CenterScreen'
  $form.FormBorderStyle = 'FixedDialog'
  
  $dataGridView = New-Object System.Windows.Forms.DataGridView
  $dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
  $dataGridView.BackgroundColor = $nord0
  $dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
  $dataGridView.AutoGenerateColumns = $false
  $dataGridView.ReadOnly = $true
  $dataGridView.AllowUserToAddRows = $false
  $dataGridView.ColumnHeadersVisible = $true
  $dataGridView.RowHeadersVisible = $false
  $dataGridView.GridColor = $nord4

  $dataGridView.ColumnHeadersDefaultCellStyle.BackColor = $nord0
  $dataGridView.ColumnHeadersDefaultCellStyle.ForeColor = $nord4

  $dataGridView.RowHeadersDefaultCellStyle.BackColor = $nord0
  $dataGridView.RowHeadersDefaultCellStyle.ForeColor = $nord4

  $dataGridView.RowsDefaultCellStyle.BackColor = $nord0
  $dataGridView.RowsDefaultCellStyle.ForeColor = $nord4
  $dataGridView.AlternatingRowsDefaultCellStyle.BackColor = $nord0
  $dataGridView.AlternatingRowsDefaultCellStyle.ForeColor = $nord4

  $nameColumn = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
  $nameColumn.HeaderText = 'Name'
  $nameColumn.DataPropertyName = 'Name'
  
  $urlColumn = New-Object System.Windows.Forms.DataGridViewLinkColumn
  $urlColumn.HeaderText = 'URL'
  $urlColumn.DataPropertyName = 'Url'
  $urlColumn.LinkColor = $nord4
  $urlColumn.VisitedLinkColor = $nord4
  $urlColumn.ActiveLinkColor = $nord4
  $urlColumn.LinkBehavior = [System.Windows.Forms.LinkBehavior]::HoverUnderline
  
  $dataGridView.Columns.Add($nameColumn)
  $dataGridView.Columns.Add($urlColumn)
  
  $form.Controls.Add($dataGridView)
  
  $dataGridView.Add_CellContentClick({
      param($sender, $e)
      if ($e.ColumnIndex -eq 1) {
        $url = $dataGridView.Rows[$e.RowIndex].Cells[$e.ColumnIndex].Value
        Start-Process $url
      }
    })

  foreach ($link in $links) {
    $row = $dataGridView.Rows.Add()
    $dataGridView.Rows[$row].Cells[0].Value = $link.Name
    $dataGridView.Rows[$row].Cells[1].Value = $link.Url
  }

  $form.ShowDialog()
}

<#
.SYNOPSIS
   Gets the current profile version
.DESCRIPTION 
   This function gets the current profile version
#>
function Profile-Version {
  $keyPath = 'HKCU:\Software\Azrael\PowerShell'
  $version = Get-ItemProperty -Path $keyPath -Name 'Version' -ErrorAction SilentlyContinue
  $currentVersion = $version.Version
  $currentVersion
}

# ----------------------------------------
# Helper functions
# ----------------------------------------

<#
.SYNOPSIS
  Displays the help menu
.DESCRIPTION 
  This function displays the help menu
.PARAMETER ShowInConsole
  Displays the help menu in the console
#>
function Shell-Help {
  param (
    [bool]$ShowInConsole = $false
  )
  $excludedNames = 'A:', 'B:', 'C:', 'D:', 'E:', 'F:', 'G:', 'H:', 'I:', 'J:', 'K:', 'L:', 'M:', 'N:', 'O:', 'P:', 'Q:', 'R:', 'S:', 'T:', 'U:', 'V:', 'W:', 'X:', 'Y:', 'Z:'
  $commands = Get-Command -CommandType Function | Where-Object { $_.Source -eq "" -and $_.Name -notin $excludedNames } | ForEach-Object {
    $help = Get-Help $_.Name
    $alias = (Get-ReverseAlias -Command $_.Name -ErrorAction SilentlyContinue | Out-String) -replace "`n", ''
    $description = $help.Synopsis
    $parameters = ($help.Parameters.Parameter | ForEach-Object { $_.Name }) -join ', '

    if ($alias -and $description) {
      [PSCustomObject] @{
        Name        = "$($_.Name) ($alias)"
        Description = $description
        Parameters  = $parameters
      }
    }
  } | Sort-Object -Property Name

  if ($ShowInConsole) {
    Clear-Host
    $commandString = "For more information about a command, type 'Get-Help <command-name>'`n" + ($commands | Out-String)
    $commandString
  }
  else {
    $commandsOutput = $commands | Format-Table -Wrap -AutoSize | Out-String
    Show-Help -Output $commandsOutput -Introduction "For more information about a command, type 'Get-Help <command-name>'"
  }

}

function Get-ReverseAlias {
  param (
    [Parameter(Mandatory = $true)][string]$Command
  )

  $aliases = Get-Alias | Where-Object { $_.Definition -eq $Command }
  if ($aliases) {
    $aliases.Name
  }
}

function Show-Help {
  param (
    [Parameter(Mandatory = $true)][string]$Output,
    [Parameter(Mandatory = $true)][string]$Introduction
  )

  $PanelWidth = 1000

  $form = New-Object System.Windows.Forms.Form
  $form.Text = "PowerShell Help"
  $form.BackColor = $nord0
  $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
  $form.StartPosition = 'CenterScreen'
  $form.FormBorderStyle = 'FixedDialog'

  $panel = New-Object System.Windows.Forms.Panel
  $panel.Dock = 'Fill'
  $panel.AutoScroll = $false

  $richTextBox = New-Object System.Windows.Forms.RichTextBox
  $richTextBox.Location = New-Object System.Drawing.Point(0, 0)
  $richTextBox.Size = New-Object System.Drawing.Size(($PanelWidth + 20), 490)
  $richTextBox.Text = $Introduction + "`n" + $Output
  $richTextBox.BackColor = $nord0
  $richTextBox.ForeColor = $nord4
  $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
  $richTextBox.ReadOnly = $true
  $richTextBox.BorderStyle = 'None'
  $richTextBox.ScrollBars = 'Vertical'

  $panel.Controls.Add($richTextBox)

  $form.Controls.Add($panel)

  $form.ShowDialog()
}

# ----------------------------------------
# Aliases
# ----------------------------------------

Remove-Item alias:\del | Out-Null
Remove-Item alias:\cd | Out-Null
Remove-Item alias:\md | Out-Null
Remove-Item alias:\man | Out-Null

Set-Alias -Name del -Value Trash-Item
Set-Alias -Name empty -Value Empty-RecycleBin
Set-Alias -Name time -Value Get-Date
Set-Alias -Name pactive -Value Active-Processes
Set-Alias -Name pfind -Value Find-Process
Set-Alias -Name pkill -Value Kill-Process
Set-Alias -Name pinfo -Value Process-Information
Set-Alias -Name pcinfo -Value Get-ComputerInfo
Set-Alias -Name updates -Value Get-Updates
Set-Alias -Name host -Value Get-Host
Set-Alias -Name hack -Value Hack-Target
Set-Alias -Name eip -Value Get-Extended-IpInfo
Set-Alias -Name ip -Value Get-IP
Set-Alias -Name scanip -Value Scan-IP
Set-Alias -Name scanports -Value Scan-Ports
Set-Alias -Name del -Value Delete-Folder
Set-Alias -Name ocopy -Value Copy-Folder
Set-Alias -Name omove -Value Move-Folder
Set-Alias -Name osize -Value Object-Size
Set-Alias -Name ocount -Value Object-Count
Set-Alias -Name cop -Value Copy-Path
Set-Alias -Name cd -Value Change-Directory
Set-Alias -Name back -Value Go-Back
Set-Alias -Name shell -Value Get-ShellInfo
Set-Alias -Name packages -Value Get-Packages
Set-Alias -Name refresh -Value Refresh-Shell
Set-Alias -Name restart -Value Restart-Shell
Set-Alias -Name help -Value Shell-Help
Set-Alias -Name search -Value Search-Item
Set-Alias -Name mdd -Value New-DirectoryAndNavigate
Set-Alias -Name rmd -Value Remove-CurrentDirectory
Set-Alias -Name backup -Value Backup-Workspace
Set-Alias -Name update -Value Update-Packages
Set-Alias -Name gsr -Value Generate-System-Report
Set-Alias -Name optimize -Value Optimize-PowerShell
Set-Alias -Name activate -Value Activate-Windows
Set-Alias -Name hosts -Value Host-Entry-Manager
Set-Alias -Name dns -Value DNS-Changer
Set-Alias -Name network -Value Network-Adapter-Manager
Set-Alias -Name nagle -Value Nagles
Set-Alias -Name matrix -Value Start-MatrixRain
Set-Alias -Name touch -Value Create-File
Set-Alias -Name joke -Value Get-ProgrammingJoke
Set-Alias -Name services -Value Get-ServiceStatus
Set-Alias -Name ddg -Value Search-DuckDuckGo
Set-Alias -Name links -Value Get-Links

# ----------------------------------------
# Profile Completion
# ----------------------------------------