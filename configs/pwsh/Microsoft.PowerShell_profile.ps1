# ----------------------------------------
# Profile Information
# ----------------------------------------

# Author: LukeHjo (Azrael)
# Description: This is my PowerShell profile. It contains features that I use on a daily basis.
# Version: 1.1.0
# Date: 2023-12-27

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

<#
.SYNOPSIS
   Check for updates
.DESCRIPTION 
   This function checks for updates
#>
function Update-Profile {
  $keyPath = 'HKCU:\Software\Azrael\PowerShell'
  $version = Get-ItemProperty -Path $keyPath -Name 'Version' -ErrorAction SilentlyContinue
  $currentVersion = $version.Version
  $latestVersion = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/version'
  if ($currentVersion -ne $latestVersion) {

    # Check if the profile should be updated automatically
    $autoUpdate = Get-ItemProperty -Path $keyPath -Name 'AutoUpdate' -ErrorAction SilentlyContinue
    if ($autoUpdate.AutoUpdate -eq 1) {
      Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
      New-ItemProperty -Path $keyPath -Name 'Version' -Value $latestVersion -PropertyType 'String' -Force | Out-Null
      exit
    }
    else {
      # Create the form
      $form = New-Object System.Windows.Forms.Form
      $form.Text = "Update Available"
      $form.BackColor = $nord0
      $form.ForeColor = $nord4
      $form.Font = New-Object System.Drawing.Font("Arial", 10)
      $form.StartPosition = 'CenterScreen'
      $form.Size = New-Object System.Drawing.Size(400, 200)
      $form.FormBorderStyle = 'FixedDialog'
      $form.MaximizeBox = $false
      $form.MinimizeBox = $false

      $icoFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
      $icoFileData = Invoke-WebRequest -Uri $icoFileUrl -UseBasicParsing

      if ($icoFileData.StatusCode -eq 200) {
        $icoFileStream = [System.IO.MemoryStream]::new($icoFileData.Content)
        $icon = [System.Drawing.Icon]::new($icoFileStream)
        $form.Icon = $icon
      }
      else {
        Write-Host "Failed to download the ICO file from the URL."
      }

      $label = New-Object System.Windows.Forms.Label
      $label.Text = "A new version of the profile is available. Would you like to update?"
      $label.Location = New-Object System.Drawing.Point(10, 10)
      $label.Size = New-Object System.Drawing.Size(380, 80)
      $label.ForeColor = $nord6

      $yesButton = New-Object System.Windows.Forms.Button
      $yesButton.BackColor = $nord3
      $yesButton.ForeColor = $nord6
      $yesButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
      $yesButton.FlatAppearance.BorderSize = 0
      $yesButton.Location = New-Object System.Drawing.Point(100, 120)
      $yesButton.Size = New-Object System.Drawing.Size(75, 23)
      $yesButton.Text = "Yes"
      $yesButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes

      $noButton = New-Object System.Windows.Forms.Button
      $noButton.BackColor = $nord3
      $noButton.ForeColor = $nord6
      $noButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
      $noButton.FlatAppearance.BorderSize = 0
      $noButton.Location = New-Object System.Drawing.Point(200, 120)
      $noButton.Size = New-Object System.Drawing.Size(75, 23)
      $noButton.Text = "No"
      $noButton.DialogResult = [System.Windows.Forms.DialogResult]::No

      $form.Controls.Add($label)
      $form.Controls.Add($yesButton)
      $form.Controls.Add($noButton)
      $form.AcceptButton = $yesButton
      $form.CancelButton = $noButton

      $result = $form.ShowDialog()

      if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
        New-ItemProperty -Path $keyPath -Name 'Version' -Value $latestVersion -PropertyType 'String' -Force | Out-Null
        exit
      }
      
      $autoUpdate = Get-ItemProperty -Path $keyPath -Name 'AutoUpdate' -ErrorAction SilentlyContinue
      if ($null -eq $autoUpdate) {
        # Create the form
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Auto Update"
        $form.BackColor = $nord0
        $form.ForeColor = $nord4
        $form.Font = New-Object System.Drawing.Font("Arial", 10)
        $form.StartPosition = 'CenterScreen'
        $form.Size = New-Object System.Drawing.Size(400, 200)
        $form.FormBorderStyle = 'FixedDialog'
        $form.MaximizeBox = $false
        $form.MinimizeBox = $false

        $icoFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
        $icoFileData = Invoke-WebRequest -Uri $icoFileUrl -UseBasicParsing
        
        if ($icoFileData.StatusCode -eq 200) {
          $icoFileStream = [System.IO.MemoryStream]::new($icoFileData.Content)
          $icon = [System.Drawing.Icon]::new($icoFileStream)
          $form.Icon = $icon
        }
        else {
          Write-Host "Failed to download the ICO file from the URL."
        }

        $label = New-Object System.Windows.Forms.Label
        $label.Text = "Would you like to update the profile automatically in the future?"
        $label.Location = New-Object System.Drawing.Point(10, 10)
        $label.Size = New-Object System.Drawing.Size(380, 80)
        $label.ForeColor = $nord6

        $yesButton = New-Object System.Windows.Forms.Button
        $yesButton.BackColor = $nord3
        $yesButton.ForeColor = $nord6
        $yesButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $yesButton.FlatAppearance.BorderSize = 0
        $yesButton.Location = New-Object System.Drawing.Point(100, 120)
        $yesButton.Size = New-Object System.Drawing.Size(75, 23)
        $yesButton.Text = "Yes"
        $yesButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes

        $noButton = New-Object System.Windows.Forms.Button
        $noButton.BackColor = $nord3
        $noButton.ForeColor = $nord6
        $noButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $noButton.FlatAppearance.BorderSize = 0
        $noButton.Location = New-Object System.Drawing.Point(200, 120)
        $noButton.Size = New-Object System.Drawing.Size(75, 23)
        $noButton.Text = "No"
        $noButton.DialogResult = [System.Windows.Forms.DialogResult]::No

        $form.Controls.Add($label)
        $form.Controls.Add($yesButton)
        $form.Controls.Add($noButton)
        $form.AcceptButton = $yesButton
        $form.CancelButton = $noButton

        $result = $form.ShowDialog()

        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
          New-ItemProperty -Path $keyPath -Name 'AutoUpdate' -Value 1 -PropertyType 'DWord' -Force | Out-Null
        }
        else {
          New-ItemProperty -Path $keyPath -Name 'AutoUpdate' -Value 0 -PropertyType 'DWord' -Force | Out-Null
        }
      }
    }
  }
}

function Init {
  # Check for updates
  Update-Profile

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

  # Debugging
  # Remove-ItemProperty -Path $keyPath -Name 'FirstRun' -Force | Out-Null

  $userName = $env:UserName
  $pVersion = $host.Version.Major
  $shellType = if ($pVersion -ge 7) { "Pwsh" } else { "PowerShell" }
  $kernelVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Version

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

    $icoFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
    $icoFileData = Invoke-WebRequest -Uri $icoFileUrl -UseBasicParsing
  
    if ($icoFileData.StatusCode -eq 200) {
      $icoFileStream = [System.IO.MemoryStream]::new($icoFileData.Content)
      $icon = [System.Drawing.Icon]::new($icoFileStream)
      $form.Icon = $icon
    }
    else {
      Write-Host "Failed to download the ICO file from the URL."
    }
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Hello, $userName! Welcome to $($shellType). For more information, please type 'help'."
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
  $keyPath = 'HKCU:\Software\Azrael\PowerShell'
  $key = Get-ItemProperty -Path $keyPath -Name 'Version' -ErrorAction SilentlyContinue
  $version = ($key.Version).Trim()

  Write-Host "Microsoft Windows [Version $($kernelVersion)]"
  Write-Host "(c) Microsoft Corporation. All rights reserved.`n"

  Write-Host "Azrael's $($shellType) v$($version)"
  Write-Host "Copyright (c) 2023-2024 Azrael"
  Write-Host "https://github.com/luke-beep/shell-config/`n"
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
  # Prompt the user to confirm the deletion
  Write-Host "Are you sure you want to delete the current directory? (Y/N)"
  $input = Read-Host
  if ($input -eq "Y") {
    $currentDirectory = Get-Location
    Set-Location -Path ..
    Remove-Item -Path $currentDirectory -Recurse -Force
  }
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

  $icoFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
  $icoFileData = Invoke-WebRequest -Uri $icoFileUrl -UseBasicParsing

  if ($icoFileData.StatusCode -eq 200) {
    $icoFileStream = [System.IO.MemoryStream]::new($icoFileData.Content)
    $icon = [System.Drawing.Icon]::new($icoFileStream)
    $form.Icon = $icon
  }
  else {
    Write-Host "Failed to download the ICO file from the URL."
  }
  
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

<#
.SYNOPSIS
   Allows you to manage your profile
.DESCRIPTION 
   This function allows you to manage your profile
#>
function Preview-Profile {
  $PanelWidth = 1000

  $form = New-Object System.Windows.Forms.Form
  $form.Text = "Preview Profile"
  $form.BackColor = $nord0
  $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
  $form.StartPosition = 'CenterScreen'
  $form.FormBorderStyle = 'FixedDialog'

  $icoFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
  $icoFileData = Invoke-WebRequest -Uri $icoFileUrl -UseBasicParsing

  if ($icoFileData.StatusCode -eq 200) {
    $icoFileStream = [System.IO.MemoryStream]::new($icoFileData.Content)
    $icon = [System.Drawing.Icon]::new($icoFileStream)
    $form.Icon = $icon
  }
  else {
    Write-Host "Failed to download the ICO file from the URL."
  }

  $panel = New-Object System.Windows.Forms.Panel
  $panel.Dock = 'Fill'
  $panel.AutoScroll = $false

  $richTextBox = New-Object System.Windows.Forms.RichTextBox
  $richTextBox.Location = New-Object System.Drawing.Point(0, 0)
  $richTextBox.Size = New-Object System.Drawing.Size(($PanelWidth + 20), 490)
  $richTextBox.Text = "Profile Version: $(Profile-Version)`n`n" + (Get-Content $profile | Out-String)
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

<#
.SYNOPSIS
   Download object(s)
.DESCRIPTION 
   This function downloads object(s) to the specified path or the current directory
.PARAMETER Url 
   The URL of the object
#>
function Download-Object {
  param (
    [Parameter(Mandatory = $true)][string[]]$Url,
    [Parameter(Mandatory = $false)][string[]]$ObjectName,
    [Parameter(Mandatory = $false)][string]$ObjectPath,
    [Parameter(Mandatory = $false)][switch]$Overwrite,
    [Parameter(Mandatory = $false)][switch]$Silent
  )

  $downloadDirectory = if ($ObjectPath) { $ObjectPath } else { Get-Location }
  $downloadedObjects = @()

  $jobs = @()
  for ($i = 0; $i -lt $Url.Length; $i++) {
    try {
      $actualObjectName = if ($ObjectName.Length -gt $i) { $ObjectName[$i] } else { [System.IO.Path]::GetFileName($Url[$i]) }
      $destinationPath = Join-Path $downloadDirectory $actualObjectName
      if ($Overwrite -and (Test-Path $destinationPath)) {
        if (-not $Silent) {
          Write-Host "Removing $destinationPath"
        }
        Remove-Item $destinationPath -Force
      }

      $scriptBlock = {
        param ($url, $destinationPath, $overwrite, $silent)
        $curlCommand = "curl -o `"$destinationPath`" -L `"$url`" -s"
        if ($overwrite) {
          $curlCommand += " -O"
        }
        Invoke-Expression $curlCommand 2>&1 | Out-Null
      }

      $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $Url[$i], $destinationPath, $Overwrite, $Silent
      $jobs += $job

      $downloadedObjects += $destinationPath
    }
    catch {
      if (-not $Silent) {
        Write-Error "An error occurred: $_"
      }
    }
  }
  $jobs | Wait-Job

  $jobs | ForEach-Object {
    Receive-Job -Job $_
    Remove-Job -Job $_
  }

  if (-not $Silent) {
    Invoke-Item -Path $downloadDirectory  
  }
  return $downloadedObjects
}

<#
.SYNOPSIS
   Allows for pipeline execution
.DESCRIPTION 
   This function allows for pipeline execution
.PARAMETER Objects 
   The object paths
.EXAMPLE 
   Download-Object -Url "http://example.com/file1.zip", "http://example.com/file2.zip" | Execute-Object
#>
function Execute-Object {
  param (
    [Parameter(ValueFromPipeline = $true)]
    [string[]]$Objects
  )

  Process {
    foreach ($object in $Objects) {
      if (Test-Path $object) {
        Start-Process $object
      }
    }
  }
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

<#
.SYNOPSIS
  Gets the aliases for a command through a reverse lookup
.DESCRIPTION 
  This function gets the aliases for a command through a reverse lookup
.PARAMETER Command
  The command
#>
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

  $icoFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
  $icoFileData = Invoke-WebRequest -Uri $icoFileUrl -UseBasicParsing

  if ($icoFileData.StatusCode -eq 200) {
    $icoFileStream = [System.IO.MemoryStream]::new($icoFileData.Content)
    $icon = [System.Drawing.Icon]::new($icoFileStream)
    $form.Icon = $icon
  }
  else {
    Write-Host "Failed to download the ICO file from the URL."
  }

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

<#
.SYNOPSIS
  Configure Profile Settings
.DESCRIPTION 
  This function configures profile settings
#>
function Configure-ProfileSettings {
  $PanelWidth = 1000

  $form = New-Object System.Windows.Forms.Form
  $form.Text = "Profile Settings"
  $form.BackColor = $nord0
  $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
  $form.StartPosition = 'CenterScreen'
  $form.FormBorderStyle = 'FixedDialog'

  $icoFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
  $icoFileData = Invoke-WebRequest -Uri $icoFileUrl -UseBasicParsing

  if ($icoFileData.StatusCode -eq 200) {
    $icoFileStream = [System.IO.MemoryStream]::new($icoFileData.Content)
    $icon = [System.Drawing.Icon]::new($icoFileStream)
    $form.Icon = $icon
  }
  else {
    Write-Host "Failed to download the ICO file from the URL."
  }

  $keyPath = 'HKCU:\Software\Azrael\PowerShell'
  $keys = Get-ItemProperty -Path $keyPath -ErrorAction SilentlyContinue
  
  $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
  $tableLayoutPanel.RowCount = 1
  $tableLayoutPanel.ColumnCount = 1
  $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
  $tableLayoutPanel.RowStyles.Clear()
  $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
  $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $tableLayoutPanel.BackColor = $nord0
  $tableLayoutPanel.ForeColor = $nord4

  $dataGridView = New-Object System.Windows.Forms.DataGridView
  $dataGridView.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $dataGridView.Location = New-Object System.Drawing.Point(10, 10)
  $dataGridView.Size = New-Object System.Drawing.Size(360, 200)
  $dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
  $dataGridView.AutoGenerateColumns = $true
  $dataGridView.RowHeadersVisible = $false
  $dataGridView.BackgroundColor = $nord0
  $dataGridView.ForeColor = $nord6
  $dataGridView.GridColor = $nord3
  $dataGridView.DefaultCellStyle.BackColor = $nord0
  $dataGridView.DefaultCellStyle.ForeColor = $nord6
  $dataGridView.ColumnHeadersDefaultCellStyle.BackColor = $nord3
  $dataGridView.ColumnHeadersDefaultCellStyle.ForeColor = $nord6
  $dataGridView.RowHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
  $dataGridView.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
  $dataGridView.DefaultCellStyle.SelectionBackColor = $nord3
  $dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill

  $deletedRows = New-Object System.Collections.Generic.List[string]

  $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
  $deleteMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
  $deleteMenuItem.Text = "Delete"
  $deleteMenuItem.add_Click({
      if ($dataGridView.SelectedCells.Count -gt 0) {
        $selectedRowIndex = $dataGridView.SelectedCells[0].RowIndex
        $name = $dataGridView.Rows[$selectedRowIndex].Cells[0].Value
        $deletedRows.Add($name)
        $dataGridView.Rows.RemoveAt($selectedRowIndex)
      }
    })
  $contextMenu.Items.Add($deleteMenuItem)
  
  $dataGridView.ContextMenuStrip = $contextMenu

  $nameColumn = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
  $nameColumn.HeaderText = "Name"
  $nameColumn.DataPropertyName = "Name"
  $valueColumn = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
  $valueColumn.HeaderText = "Value"
  $valueColumn.DataPropertyName = "Value"

  $dataGridView.Columns.Add($nameColumn)
  $dataGridView.Columns.Add($valueColumn)

  $dataTable = New-Object System.Data.DataTable

  $dataTable.Columns.Add("Name", [string])
  $dataTable.Columns.Add("Value", [string])

  $keys.PSObject.Properties | ForEach-Object {
    $row = $dataTable.NewRow()
    $row["Name"] = $_.Name
    $row["Value"] = $_.Value
    $dataTable.Rows.Add($row)
  }

  $dataGridView.DataSource = $dataTable

  $tableLayoutPanel.Controls.Add($dataGridView, 0, 0)
  
  $button = New-Object System.Windows.Forms.Button
  $button.Location = New-Object System.Drawing.Point(10, 220)
  $button.Size = New-Object System.Drawing.Size(150, 30)
  $button.Text = "Save Configuration"
  $button.Dock = [System.Windows.Forms.DockStyle]::Fill
  $button.BackColor = $nord3
  $button.ForeColor = $nord6
  $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
  $button.FlatAppearance.BorderColor = $nord3
  $button.FlatAppearance.BorderSize = 1
  $button.Add_Click({
      $dataGridView.Rows | ForEach-Object {
        if (-not $_.IsNewRow) {
          $row = $_.DataBoundItem
          $name = $row["Name"]
          $value = $row["Value"]
          if ([string]::IsNullOrEmpty($value)) {
            Remove-ItemProperty -Path $keyPath -Name $name
          }
          else {
            Set-ItemProperty -Path $keyPath -Name $name -Value $value
          }
        }
      }

      $deletedRows | ForEach-Object {
        Remove-ItemProperty -Path $keyPath -Name $_
        $deletedRows.Remove($_)
      }
      [System.Windows.Forms.MessageBox]::Show("Profile settings saved.", "Success")
    })
  $tableLayoutPanel.Controls.Add($button, 0, 1)

  $form.Controls.Add($tableLayoutPanel)

  $form.ShowDialog()

  $form.Dispose()
}

# ----------------------------------------
# Aliases
# ----------------------------------------

<#
.SYNOPSIS
  Loads aliases
.DESCRIPTION 
  This function loads aliases
#>
function Load-Aliases {
  param (
    [Parameter(Mandatory = $false)][switch]$Force
  )

  $newAliasFilePath = Join-Path (Split-Path -Parent $PROFILE) "new-aliases.json"
  $oldAliasFilePath = Join-Path (Split-Path -Parent $PROFILE) "old-aliases.json"

  if ($Force) {
    Remove-Item $oldAliasFilePath -Force
    $oldAliasFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/old-aliases.json"
    Invoke-WebRequest -Uri $oldAliasFileUrl -OutFile $oldAliasFilePath

    Remove-Item $newAliasFilePath -Force
    $newAliasFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/new-aliases.json"
    Invoke-WebRequest -Uri $newAliasFileUrl -OutFile $newAliasFilePath
  }
  else {
    if (-not (Test-Path $newAliasFilePath)) {
      $newAliasFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/new-aliases.json"
      Invoke-WebRequest -Uri $newAliasFileUrl -OutFile $newAliasFilePath
    }
  
    if (-not (Test-Path $oldAliasFilePath)) {
      $oldAliasFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/old-aliases.json"
      Invoke-WebRequest -Uri $oldAliasFileUrl -OutFile $oldAliasFilePath
    }  

    if (Test-Path $oldAliasFilePath) {
      $oldAliases = Get-Content $oldAliasFilePath | ConvertFrom-Json
  
      foreach ($alias in $oldAliases) {
        if (Get-Alias -Name $alias -ErrorAction SilentlyContinue) {
          Remove-Alias $alias -Force -Scope Global 
        }
      }
    }
  
    if (Test-Path $newAliasFilePath) {
      $newAliases = Get-Content $newAliasFilePath | ConvertFrom-Json
  
      foreach ($alias in $newAliases.PSObject.Properties) {
        try {
          Set-Alias -Name $alias.Name -Value $alias.Value -Scope Global -Option AllScope -Force
        }
        catch {
          Write-Error "Error setting alias $($alias.Name): $_"
        }
      }  
    }
  }
}
Load-Aliases

function Add-Aliases {
  $AliasConfigFile = "new-aliases.json"
  $aliasConfigFilePath = Join-Path (Split-Path -Parent $PROFILE) $AliasConfigFile

  if (-not (Test-Path $aliasConfigFilePath)) {
    $aliasConfigFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/$AliasConfigFile"
    Invoke-WebRequest -Uri $aliasConfigFileUrl -OutFile $aliasConfigFilePath
  }

  $aliasConfig = Get-Content $aliasConfigFilePath | ConvertFrom-Json
  Write-Host $aliasConfig

  $form = New-Object System.Windows.Forms.Form
  $form.Text = "Alias Configuration"
  $form.Size = New-Object System.Drawing.Size(400, 300)
  $form.StartPosition = "CenterScreen"
  $form.BackColor = $nord0
  $form.ForeColor = $nord4

  $icoFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
  $icoFileData = Invoke-WebRequest -Uri $icoFileUrl -UseBasicParsing

  if ($icoFileData.StatusCode -eq 200) {
    $icoFileStream = [System.IO.MemoryStream]::new($icoFileData.Content)
    $icon = [System.Drawing.Icon]::new($icoFileStream)
    $form.Icon = $icon
  }
  else {
    Write-Host "Failed to download the ICO file from the URL."
  }

  $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
  $tableLayoutPanel.RowCount = 1
  $tableLayoutPanel.ColumnCount = 1
  $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
  $tableLayoutPanel.RowStyles.Clear()
  $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
  $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $tableLayoutPanel.BackColor = $nord0
  $tableLayoutPanel.ForeColor = $nord4

  $dataGridView = New-Object System.Windows.Forms.DataGridView
  $dataGridView.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $dataGridView.Location = New-Object System.Drawing.Point(10, 10)
  $dataGridView.Size = New-Object System.Drawing.Size(360, 200)
  $dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
  $dataGridView.AutoGenerateColumns = $true
  $dataGridView.RowHeadersVisible = $false
  $dataGridView.BackgroundColor = $nord0
  $dataGridView.ForeColor = $nord6
  $dataGridView.GridColor = $nord3
  $dataGridView.DefaultCellStyle.BackColor = $nord0
  $dataGridView.DefaultCellStyle.ForeColor = $nord6
  $dataGridView.ColumnHeadersDefaultCellStyle.BackColor = $nord3
  $dataGridView.ColumnHeadersDefaultCellStyle.ForeColor = $nord6
  $dataGridView.RowHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
  $dataGridView.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
  $dataGridView.DefaultCellStyle.SelectionBackColor = $nord3
  $dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill

  $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
  $deleteMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
  $deleteMenuItem.Text = "Delete"
  $deleteMenuItem.add_Click({
      if ($dataGridView.SelectedCells.Count -gt 0) {
        $selectedRowIndex = $dataGridView.SelectedCells[0].RowIndex
        $dataGridView.Rows.RemoveAt($selectedRowIndex)
      }
    })
  $contextMenu.Items.Add($deleteMenuItem)
  
  $dataGridView.ContextMenuStrip = $contextMenu

  $nameColumn = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
  $nameColumn.HeaderText = "Alias Name"
  $nameColumn.DataPropertyName = "Name"
  $valueColumn = New-Object System.Windows.Forms.DataGridViewTextBoxColumn
  $valueColumn.HeaderText = "Alias Value"
  $valueColumn.DataPropertyName = "Value"

  $dataGridView.Columns.Add($nameColumn)
  $dataGridView.Columns.Add($valueColumn)

  $dataTable = New-Object System.Data.DataTable

  $dataTable.Columns.Add("Name", [string])
  $dataTable.Columns.Add("Value", [string])

  $aliasConfig.PSObject.Properties | ForEach-Object {
    $row = $dataTable.NewRow()
    $row["Name"] = $_.Name
    $row["Value"] = $_.Value
    $dataTable.Rows.Add($row)
  }

  $dataGridView.DataSource = $dataTable

  $tableLayoutPanel.Controls.Add($dataGridView, 0, 0)

  $button = New-Object System.Windows.Forms.Button
  $button.Location = New-Object System.Drawing.Point(10, 220)
  $button.Size = New-Object System.Drawing.Size(150, 30)
  $button.Text = "Save Configuration"
  $button.Dock = [System.Windows.Forms.DockStyle]::Fill
  $button.BackColor = $nord3
  $button.ForeColor = $nord6
  $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
  $button.FlatAppearance.BorderColor = $nord3
  $button.FlatAppearance.BorderSize = 1
  $button.Add_Click({
      $updatedConfig = New-Object PSObject
      $dataGridView.DataSource | ForEach-Object {
        Add-Member -InputObject $updatedConfig -NotePropertyName $_.Name -NotePropertyValue $_.Value
      }

      $updatedConfig | ConvertTo-Json | Set-Content -Path $aliasConfigFilePath -Force

      [System.Windows.Forms.MessageBox]::Show("Alias configuration saved.", "Success")
    })
  $tableLayoutPanel.Controls.Add($button, 0, 1)

  $form.Controls.Add($tableLayoutPanel)

  $form.ShowDialog()

  $form.Dispose()
}

function Remove-Aliases {
  $AliasConfigFile = "old-aliases.json"
  $aliasConfigFilePath = Join-Path (Split-Path -Parent $PROFILE) $AliasConfigFile

  if (-not (Test-Path $aliasConfigFilePath)) {
    $aliasConfigFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/$AliasConfigFile"
    Invoke-WebRequest -Uri $aliasConfigFileUrl -OutFile $aliasConfigFilePath
  }

  $aliasConfig = Get-Content $aliasConfigFilePath | ConvertFrom-Json

  $dataTable = New-Object System.Data.DataTable
  $dataTable.Columns.Add("Name", [string])

  foreach ($alias in $aliasConfig) {
    $row = $dataTable.NewRow()
    $row["Name"] = $alias
    $dataTable.Rows.Add($row)
  }


  $form = New-Object System.Windows.Forms.Form
  $form.Text = "Alias Configuration"
  $form.StartPosition = "CenterScreen"
  $form.BackColor = $nord0
  $form.ForeColor = $nord4

  $icoFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
  $icoFileData = Invoke-WebRequest -Uri $icoFileUrl -UseBasicParsing

  if ($icoFileData.StatusCode -eq 200) {
    $icoFileStream = [System.IO.MemoryStream]::new($icoFileData.Content)
    $icon = [System.Drawing.Icon]::new($icoFileStream)
    $form.Icon = $icon
  }
  else {
    Write-Host "Failed to download the ICO file from the URL."
  }

  $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
  $tableLayoutPanel.RowCount = 1
  $tableLayoutPanel.ColumnCount = 1
  $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
  $tableLayoutPanel.RowStyles.Clear()
  $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
  $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None

  $dataGridView = New-Object System.Windows.Forms.DataGridView
  $dataGridView.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
  $dataGridView.AutoGenerateColumns = $true
  $dataGridView.RowHeadersVisible = $false
  $dataGridView.BackgroundColor = $nord0
  $dataGridView.ForeColor = $nord6
  $dataGridView.GridColor = $nord3
  $dataGridView.DefaultCellStyle.BackColor = $nord0
  $dataGridView.DefaultCellStyle.ForeColor = $nord6
  $dataGridView.ColumnHeadersDefaultCellStyle.BackColor = $nord3
  $dataGridView.ColumnHeadersDefaultCellStyle.ForeColor = $nord6
  $dataGridView.RowHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
  $dataGridView.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
  $dataGridView.DefaultCellStyle.SelectionBackColor = $nord3
  $dataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill

  $dataGridView.DataSource = $dataTable

  $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
  $deleteMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
  $deleteMenuItem.Text = "Delete"
  $deleteMenuItem.add_Click({
      if ($dataGridView.SelectedCells.Count -gt 0) {
        $selectedRowIndex = $dataGridView.SelectedCells[0].RowIndex
        $dataGridView.Rows.RemoveAt($selectedRowIndex)
      }
    })
  $contextMenu.Items.Add($deleteMenuItem)
  
  $dataGridView.ContextMenuStrip = $contextMenu

  $tableLayoutPanel.Controls.Add($dataGridView, 0, 0)

  $button = New-Object System.Windows.Forms.Button
  $button.Dock = [System.Windows.Forms.DockStyle]::Fill
  $button.Text = "Save Configuration"
  $button.BackColor = $nord3
  $button.ForeColor = $nord6
  $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
  $button.FlatAppearance.BorderColor = $nord3
  $button.FlatAppearance.BorderSize = 1
  $button.Add_Click({
      $updatedConfig = $dataGridView.Rows | Where-Object { -not $_.IsNewRow } | ForEach-Object {
        $_.Cells["Name"].Value
      }

      $updatedConfig | ConvertTo-Json | Set-Content -Path $aliasConfigFilePath -Force

      [System.Windows.Forms.MessageBox]::Show("Alias configuration saved.", "Success")
    })

  $tableLayoutPanel.Controls.Add($button, 0, 1)

  $form.Controls.Add($tableLayoutPanel)

  $form.ShowDialog()

  $form.Dispose()
}

# ----------------------------------------
# Profile Completion
# ----------------------------------------
