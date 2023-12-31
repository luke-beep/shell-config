# ----------------------------------------
# Start of Azrael's PowerShell/Pwsh Profile
# ----------------------------------------

# Author: LukeHjo (Azrael)
# Description: This is my PowerShell profile. It contains features that I use on a daily basis.
# Version: 1.2.8
# Date: 2024-01-09

# ----------------------------------------
# Transcription
# ----------------------------------------

$CurrentDate = Get-Date -Format "yyyy-MM-dd"
$CurrentTime = Get-Date -Format "HH-mm-ss"
$ProfilePath = $PROFILE | Split-Path
$TranscriptPath = "$ProfilePath\Transcripts"
$TranscriptFile = "$TranscriptPath\$CurrentDate\$CurrentTime.txt"

if (-not (Test-Path -Path $TranscriptPath)) {
  New-Item -ItemType Directory -Force -Path "$TranscriptPath\$CurrentDate"
} # Semi-redundant but it's needed to create the directory for compatibility reasons.

Start-Transcript -Path $TranscriptFile -Append

# ----------------------------------------
# Event Log
# ----------------------------------------

$LogName = "Azrael"
$SourceName = "Azrael"

if (-not (Get-EventLog -LogName $LogName -Source $sourceName -ErrorAction SilentlyContinue)) {
  New-EventLog -LogName $logName -Source $sourceName
}

function Write-InformationEvent {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$Message
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-EventLog -LogName $LogName -Source $SourceName -EntryType Information -EventId 1 -Message $Message
  }
}

function Write-WarningEvent {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$Message
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-EventLog -LogName $LogName -Source $SourceName -EntryType Warning -EventId 2 -Message $Message
  }
}

function Write-ErrorEvent {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$Message
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-EventLog -LogName $LogName -Source $SourceName -EntryType Error -EventId 3 -Message $Message
  }
}

# Write errors to the event log - non-redundant because it's needed for logging errors in the profile. Only catches profile errors, not errors in the shell environment.
TRAP {
  Write-ErrorEvent $_.Exception.Message
  continue
}


# ----------------------------------------
# Import Modules
# ----------------------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Management.Automation

if (-not (Get-Module -ListAvailable -Name PSReadLine -ErrorAction SilentlyContinue)) {
  Install-Module -Name PSReadLine -Force -Scope CurrentUser
}
Import-Module PSReadLine

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer -ErrorAction SilentlyContinue)) {
  Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser
}
Import-Module PSScriptAnalyzer

# ----------------------------------------
# Nord Color Palette
# ----------------------------------------

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord0")]
$Nord0 = [System.Drawing.ColorTranslator]::FromHtml("#2E3440") # Polar Night
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord1")]
$Nord1 = [System.Drawing.ColorTranslator]::FromHtml("#3B4252")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord2")]
$Nord2 = [System.Drawing.ColorTranslator]::FromHtml("#434C5E")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord3")]
$Nord3 = [System.Drawing.ColorTranslator]::FromHtml("#4C566A")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord4")]
$Nord4 = [System.Drawing.ColorTranslator]::FromHtml("#D8DEE9") # Snow Storm
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord5")]
$Nord5 = [System.Drawing.ColorTranslator]::FromHtml("#E5E9F0")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord6")]
$Nord6 = [System.Drawing.ColorTranslator]::FromHtml("#ECEFF4")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord7")]
$Nord7 = [System.Drawing.ColorTranslator]::FromHtml("#8FBCBB") # Frost
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord8")]
$Nord8 = [System.Drawing.ColorTranslator]::FromHtml("#88C0D0")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord9")]
$Nord9 = [System.Drawing.ColorTranslator]::FromHtml("#81A1C1")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord10")]
$Nord10 = [System.Drawing.ColorTranslator]::FromHtml("#5E81AC")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord11")]
$Nord11 = [System.Drawing.ColorTranslator]::FromHtml("#BF616A") # Aurora
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord12")]
$Nord12 = [System.Drawing.ColorTranslator]::FromHtml("#D08770")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord13")]
$Nord13 = [System.Drawing.ColorTranslator]::FromHtml("#EBCB8B")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord14")]
$Nord14 = [System.Drawing.ColorTranslator]::FromHtml("#A3BE8C")
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Nord15")]
$Nord15 = [System.Drawing.ColorTranslator]::FromHtml("#B48EAD")

# ----------------------------------------
# Global Variables (Usable in the shell environment)
# ----------------------------------------

# Profile Variables
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "ShellIconURL")]
$ShellIconURL = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "ShellIconData")]
$ShellIconData = Invoke-WebRequest -Uri $ShellIconURL -UseBasicParsing
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "ShellIconStream")]
$ShellIconStream = [System.IO.MemoryStream]::new($ShellIconData.Content)
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "ShellIcon")]
$ShellIcon = [System.Drawing.Icon]::new($ShellIconStream)
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "ShellType")]
$ShellType = if ($host.Version.Major -ge 7) { "Pwsh" } else { "PowerShell" }
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "Bitness")]
$Bitness = if ([Environment]::Is64BitProcess) { "64-bit" } else { "32-bit" }

# Shell Variables
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "ShellVersion")]
$KeyPath = if ($ShellType -eq "Pwsh") { 'HKCU:\Software\Azrael\Pwsh' } else { 'HKCU:\Software\Azrael\PowerShell' }
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "ToolsKeyPath")]
$ToolsKeyPath = 'HKCU:\Software\Azrael\Tools'

# Operating System Variables
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "KernelVersion")]
$KernelVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Version

# Profile Version
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "VersionKey")]
$VersionKey = Get-ItemProperty -Path $KeyPath -Name 'Version' -ErrorAction SilentlyContinue 
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "CurrentVersion")]
$CurrentVersion = if ($null -eq $VersionKey) { $null } else { $VersionKey.Version }
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Suppressing warning for this variable", Target = "LatestVersion")]
$LatestVersion = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/version'

# Environment Variables
$SystemDrive = $env:SystemDrive
$UserName = $env:UserName
$ComputerName = $env:ComputerName
$UserDomain = $env:UserDomain
$UserProfile = $env:UserProfile
$HomeDrive = $env:HomeDrive
$HomePath = $env:HomePath
$Path = $env:Path

# Theme (Nord)
$themeKey = Get-ItemProperty -Path $KeyPath -Name 'LightMode' -ErrorAction SilentlyContinue
if ($null -eq $themeKey) {
  New-ItemProperty -Path $KeyPath -Name 'LightMode' -Value 0 -PropertyType DWORD -Force
}

if ($themeKey.LightMode -eq 1) {
  $PrimaryBackgroundColor = $Nord4
  $SecondaryBackgroundColor = $Nord0
  $PrimaryForegroundColor = $Nord0
  $SecondaryForegroundColor = $Nord4
  $AccentColor = $Nord0
}
else {
  $PrimaryBackgroundColor = $Nord0
  $SecondaryBackgroundColor = $Nord3
  $PrimaryForegroundColor = $Nord4
  $SecondaryForegroundColor = $Nord6
  $AccentColor = $Nord3
}

# ----------------------------------------
# Start of Profile
# ----------------------------------------

<#
.SYNOPSIS
  Restarts the shell
.DESCRIPTION
  This function restarts the shell
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Restart-Shell {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters
  
  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    . $PROFILE
    if ($ShellType -eq "Pwsh") {
      pwsh
    }
    else {
      powershell
    }
    Stop-Process -Id $PID
  }
}

<#
.SYNOPSIS
  Optimizes PowerShell assemblies
.DESCRIPTION
  This function optimizes PowerShell assemblies
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Optimize-PowerShell {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($ShellType -eq "PowerShell") {
      Update-Help -Force -ErrorAction SilentlyContinue
      Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/ps-optimize-assemblies/main/optimize-assemblies.ps1" | Invoke-Expression
    }
    else {
      Update-Help -Force -ErrorAction SilentlyContinue
    }
  }
}

<#
.SYNOPSIS
  Writes a timestamped information message
.DESCRIPTION
  This function writes a timestamped information message
.PARAMETER Output
  The message to write
.EXAMPLE
  Write-TimestampedInformation "This is an information message" > [2023-12-28 12:00:00] This is an information message
.OUTPUTS
  A timestamped information message
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Write-TimestampedInformation {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$Output
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-Host ("[{0}] {1}" -f (Get-Date), $Output)
  }
}

<#
.SYNOPSIS
  Writes a timestamped warning message  
.DESCRIPTION
  This function writes a timestamped warning message
.EXAMPLE
  Write-TimestampedWarning "This is a warning message" > [2023-12-28 12:00:00] This is a warning message
.PARAMETER WarningMessage
  The message to write
.OUTPUTS
  A timestamped warning message
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Write-TimestampedWarning {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$WarningMessage
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-Warning ("[{0}] {1}" -f (Get-Date), $WarningMessage)
  }
}

<#
.SYNOPSIS
  Writes a timestamped error message
.DESCRIPTION
  This function writes a timestamped error message
.EXAMPLE
  Write-TimestampedError "This is an error message" > [2023-12-28 12:00:00] This is an error message
.PARAMETER ErrorMessage
  The message to write
.OUTPUTS
  A timestamped error message
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Write-TimestampedError {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$ErrorMessage
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-Error ("[{0}] {1}" -f (Get-Date), $ErrorMessage)
  }
}

<#
.SYNOPSIS
  Writes a colored text
.DESCRIPTION
  This function writes a colored text
.PARAMETER Color
  The color of the text
.PARAMETER SpaceCount
  The number of spaces to write
.PARAMETER LineCount
  The number of lines to write
.PARAMETER NewLine
  Whether to write a new line
.EXAMPLE
  Write-Color -Color Red -SpaceCount 10 -LineCount 1 -NewLine $true
.OUTPUTS
  A colored blank text
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Write-Color {
  PARAM (
    [Parameter(Mandatory = $true)]
    [System.ConsoleColor]$Color,

    [Parameter(Mandatory = $true)]
    [int]$SpaceCount,

    [Parameter(Mandatory = $false)]
    [int]$LineCount = 1,

    [Parameter(Mandatory = $false)]
    [bool]$NewLine = $true
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $spaces = " " * $SpaceCount
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    for ($i = 0; $i -lt $LineCount; $i++) {
      Write-Host $spaces -ForegroundColor $Color -BackgroundColor $Color -NoNewline # Write-Host is needed to change the background color
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($NewLine) {
      Write-Host ""
    }
  }
}

function Import-Functions {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $newFunctionsFilePath = Join-Path (Split-Path -Parent $PROFILE) "custom-functions.ps1"
    $newFunctionsFileUrl = "https://github.com/luke-beep/shell-config/raw/main/configs/pwsh/custom-functions.ps1"
  }  

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if (-not (Test-Path $newFunctionsFilePath)) {
      Invoke-WebRequest -Uri $newFunctionsFileUrl -OutFile $newFunctionsFilePath
    }
    . $newFunctionsFilePath
  }
}

function Import-Variables {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $newVariablesFilePath = Join-Path (Split-Path -Parent $PROFILE) "custom-variables.ps1"
    $newVariablesFileUrl = "https://github.com/luke-beep/shell-config/raw/main/configs/pwsh/custom-variables.ps1"
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if (-not (Test-Path $newVariablesFilePath)) {
      Invoke-WebRequest -Uri $newVariablesFileUrl -OutFile $newVariablesFilePath
    }
    . $newVariablesFilePath
  }
}

function Update-Profile {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)][switch]$Silent,
    [Parameter(Mandatory = $false)][switch]$Force
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-InformationEvent "Checking for updates"
    # Check for registry key
    if (-not (Test-Path $KeyPath)) {
      New-Item -Path $KeyPath -Force 
    }
    if (-not (Test-Path $ToolsKeyPath)) {
      New-Item -Path $ToolsKeyPath -Force 
    }

    # Check for the first run key
    $firstRun = Get-ItemProperty -Path $KeyPath -Name 'FirstRun' -ErrorAction SilentlyContinue

    # Check if the profile should be updated automatically
    $autoUpdate = Get-ItemProperty -Path $KeyPath -Name 'AutoUpdate' -ErrorAction SilentlyContinue

    # Create the form
    $updateForm = New-Object System.Windows.Forms.Form
    $updateForm.Text = "Update Available"
    $updateForm.BackColor = $PrimaryBackgroundColor
    $updateForm.ForeColor = $PrimaryForegroundColor
    $updateForm.Font = New-Object System.Drawing.Font("Arial", 10)
    $updateForm.StartPosition = 'CenterScreen'
    $updateForm.Size = New-Object System.Drawing.Size(400, 200)
    $updateForm.FormBorderStyle = 'FixedDialog'
    $updateForm.MaximizeBox = $false
    $updateForm.MinimizeBox = $false
    $updateForm.Icon = $ShellIcon
    
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "A new version of the profile is available. Would you like to update?"
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Size = New-Object System.Drawing.Size(380, 80)
    $label.ForeColor = $PrimaryForegroundColor
    
    $yesButton = New-Object System.Windows.Forms.Button
    $yesButton.BackColor = $SecondaryBackgroundColor
    $yesButton.ForeColor = $SecondaryForegroundColor
    $yesButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $yesButton.FlatAppearance.BorderSize = 1
    $yesButton.FlatAppearance.BorderColor = $AccentColor
    $yesButton.Location = New-Object System.Drawing.Point(100, 120)
    $yesButton.Size = New-Object System.Drawing.Size(75, 23)
    $yesButton.Text = "Yes"
    $yesButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes
    
    $noButton = New-Object System.Windows.Forms.Button
    $noButton.BackColor = $SecondaryBackgroundColor
    $noButton.ForeColor = $SecondaryForegroundColor
    $noButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $noButton.FlatAppearance.BorderSize = 1
    $noButton.FlatAppearance.BorderColor = $AccentColor
    $noButton.Location = New-Object System.Drawing.Point(200, 120)
    $noButton.Size = New-Object System.Drawing.Size(75, 23)
    $noButton.Text = "No"
    $noButton.DialogResult = [System.Windows.Forms.DialogResult]::No
    
    $updateForm.Controls.Add($label)
    $updateForm.Controls.Add($yesButton)
    $updateForm.Controls.Add($noButton)
    $updateForm.AcceptButton = $yesButton
    $updateForm.CancelButton = $noButton
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($null -eq $firstRun.FirstRun) {
      $form = New-Object System.Windows.Forms.Form
      $form.Text = "Auto Update"
      $form.BackColor = $PrimaryBackgroundColor
      $form.ForeColor = $PrimaryForegroundColor
      $form.Font = New-Object System.Drawing.Font("Arial", 10)
      $form.StartPosition = 'CenterScreen'
      $form.Size = New-Object System.Drawing.Size(400, 200)
      $form.FormBorderStyle = 'FixedDialog'
      $form.MaximizeBox = $false
      $form.MinimizeBox = $false
      $form.Icon = $ShellIcon
      

      $label = New-Object System.Windows.Forms.Label
      $label.Text = "Would you like to update the profile automatically in the future?"
      $label.Location = New-Object System.Drawing.Point(10, 10)
      $label.Size = New-Object System.Drawing.Size(380, 80)
      $label.ForeColor = $PrimaryForegroundColor

      $yesButton = New-Object System.Windows.Forms.Button
      $yesButton.BackColor = $SecondaryBackgroundColor
      $yesButton.ForeColor = $SecondaryForegroundColor
      $yesButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
      $yesButton.FlatAppearance.BorderSize = 1
      $yesButton.FlatAppearance.BorderColor = $AccentColor
      $yesButton.Location = New-Object System.Drawing.Point(100, 120)
      $yesButton.Size = New-Object System.Drawing.Size(75, 23)
      $yesButton.Text = "Yes"
      $yesButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes

      $noButton = New-Object System.Windows.Forms.Button
      $noButton.BackColor = $SecondaryBackgroundColor
      $noButton.ForeColor = $SecondaryForegroundColor
      $noButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
      $noButton.FlatAppearance.BorderSize = 1
      $noButton.FlatAppearance.BorderColor = $AccentColor
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
        New-ItemProperty -Path $KeyPath -Name 'AutoUpdate' -Value 1 -PropertyType 'DWord' -Force 
      }
      else {
        New-ItemProperty -Path $KeyPath -Name 'AutoUpdate' -Value 0 -PropertyType 'DWord' -Force 
      }

      $form.Dispose()
      Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
      New-ItemProperty -Path $KeyPath -Name 'Version' -Value $LatestVersion -PropertyType 'String' -Force 
      New-ItemProperty -Path $KeyPath -Name 'FirstRun' -Value 1 -PropertyType 'DWord' -Force 
      Restart-Shell
    }
    if ($Force) {
      $result = $updateForm.ShowDialog()
      if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        $updateForm.Dispose()
        Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
        New-ItemProperty -Path $KeyPath -Name 'Version' -Value $LatestVersion -PropertyType 'String' -Force 
        Restart-Shell 
      }
    }
    elseif ($CurrentVersion -ne $LatestVersion) {
      if ($autoUpdate.AutoUpdate -eq 1 -or $Silent) {
        Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
        New-ItemProperty -Path $KeyPath -Name 'Version' -Value $LatestVersion -PropertyType 'String' -Force 
        Restart-Shell
      }
      else {
        $result = $updateForm.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
          $updateForm.Dispose()
          Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
          New-ItemProperty -Path $KeyPath -Name 'Version' -Value $LatestVersion -PropertyType 'String' -Force 
          Restart-Shell 
        }
      }
    }
  }
}

function Set-PSReadlineConfiguration {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab -Function Complete
    Set-PSReadLineKeyHandler -Chord Enter -Function ValidateAndAcceptLine

    Set-PSReadlineOption -BellStyle Visual
    Set-PSReadlineOption -ShowToolTips
    Set-PSReadlineOption -HistoryNoDuplicates
    Set-PSReadLineOption -PredictionViewStyle InlineView
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -ContinuationPrompt '>> '
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -TerminateOrphanedConsoleApps
    Set-PSReadLineOption -Colors @{
      Command                = '#5E81AC'  # Blue for Commands
      Number                 = '#EBCB8B'  # Yellow for Numbers
      Member                 = '#BF616A'  # Red for Member Properties and Methods
      Operator               = '#ECEFF4'  # Light Grey for Operators
      Type                   = '#B48EAD'  # Purple for Types
      Variable               = '#88C0D0'  # Light Blue for Variables
      Parameter              = '#EBCB8B'  # Yellow for Parameters
      ContinuationPrompt     = '#B48EAD'  # Purple for Continuation Prompt
      Default                = '#88C0D0'  # Light Blue for Default Text
      Error                  = '#BF616A'  # Red for Errors
      Emphasis               = '#BF616A'  # Red for Emphasis
      Selection              = '#ECEFF4'  # Light Grey for Selection
      Comment                = '#A3BE8C'  # Light Green for Comments
      Keyword                = '#BF616A'  # Red for Keywords
      String                 = '#A3BE8C'  # Light Green for Strings
      InlinePrediction       = '#ECEFF4'  # Light Grey for Inline Prediction
      ListPrediction         = '#B48EAD'  # Purple for List Prediction
      ListPredictionSelected = '#5E81AC'  # Blue for Selected List Prediction
    }
  }
}

function Initialize-Profile {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    Write-InformationEvent "Initializing $($ShellType) Profile"
    # Set the execution policy
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        
    # Check for updates
    Update-Profile

    # Check for Scoop and install it if it's not installed
    $scoop = Get-Command -Name scoop -ErrorAction SilentlyContinue

    # Check for Chocolatey and install it if it's not installed
    $choco = Get-Command -Name choco -ErrorAction SilentlyContinue

    # Check for Winget and install it if it's not installed
    $winget = Get-Command -Name winget -ErrorAction SilentlyContinue

    # Check if dotnet is installed
    $dotnet = Get-Command -Name dotnet -ErrorAction SilentlyContinue

    # Check for oh-my-posh and install it if it's not installed
    $omp = Get-Command -Name oh-my-posh -ErrorAction SilentlyContinue

    # Check for starship and install it if it's not installed
    $starship = Get-Command -Name starship -ErrorAction SilentlyContinue

    # Check for the Nerd Fonts registry key
    $nerdfontKey = Get-ItemProperty -Path $ToolsKeyPath -Name 'NerdFontInstalled' -ErrorAction SilentlyContinue

    # Check for the Sysinternals registry key
    $sysinternalsKey = Get-ItemProperty -Path $ToolsKeyPath -Name 'SysinternalsInstalled' -ErrorAction SilentlyContinue

    # Check for CSharpRepl tools registry key
    $csharpKey = Get-ItemProperty -Path $ToolsKeyPath -Name 'CSharpReplInstalled' -ErrorAction SilentlyContinue

    # Key that determines whether or not the starship prompt is enabled (Disabled by default)
    $starShipKey = Get-ItemProperty -Path $KeyPath -Name 'Starship' -ErrorAction SilentlyContinue

    # Path to the oh-my-posh config file
    $ompConfig = "$UserProfile\.config\omp.json"

    # Path to the starship config file
    $starshipConfig = "$UserProfile\.config\starship.toml"

    # Check for the FirstRun key
    $firstRunKey = Get-ItemProperty -Path $KeyPath -Name 'FirstRun' -ErrorAction SilentlyContinue

    $loginMessageKey = Get-ItemProperty -Path $KeyPath -Name 'LoginMessage' -ErrorAction SilentlyContinue
    if ($null -eq $loginMessageKey) {
      New-ItemProperty -Path $KeyPath -Name 'LoginMessage' -Value 1 -PropertyType 'DWord' -Force 
    }
    
    # Check for the random tip key
    $randomTipKey = Get-ItemProperty -Path $KeyPath -Name 'RandomTip' -ErrorAction SilentlyContinue
    if ($null -eq $randomTipKey) {
      New-ItemProperty -Path $KeyPath -Name 'RandomTip' -Value 1 -PropertyType 'DWord' -Force 
    }

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Welcome to Azrael's $($ShellType) Profile!"
    $form.BackColor = $PrimaryBackgroundColor
    $form.ForeColor = $PrimaryForegroundColor
    $form.Font = New-Object System.Drawing.Font("Arial", 10)
    $form.StartPosition = 'CenterScreen'
    $form.Size = New-Object System.Drawing.Size(400, 200)
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.Icon = $ShellIcon
    
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Hello, $UserName! Welcome to $($ShellType). For more information, please type 'help' or 'tips' for more information."
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Size = New-Object System.Drawing.Size(380, 80)
    $label.ForeColor = $PrimaryForegroundColor
    
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.BackColor = $SecondaryBackgroundColor
    $okButton.ForeColor = $SecondaryForegroundColor
    $okButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $okButton.FlatAppearance.BorderSize = 1
    $okButton.FlatAppearance.BorderColor = $AccentColor
    $okButton.Location = New-Object System.Drawing.Point(160, 120)
    $okButton.Size = New-Object System.Drawing.Size(75, 23)
    $okButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    
    $form.Controls.Add($label)
    $form.Controls.Add($okButton)
    $form.AcceptButton = $okButton
  }

  PROCESS {
    # Check if the necessary tools are installed and install them if they're not
    if (-not $scoop) {
      Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    }

    if (-not $choco) {
      Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')
    }

    # Some users may not have winget installed so we'll install it if it's not installed
    if (-not $winget) {
      scoop install winget
    }

    # Check if dotnet is installed and install it if it's not
    if (-not $dotnet) {
      Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.ps1')
    }

    # Install oh-my-posh and starship if they're not installed
    if (-not $omp) {
      scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
    }
    if (-not $starShip) {
      scoop install starship
    }

    # Check for the oh-my-posh config file and download it if it's not there
    if (-not (Test-Path $ompConfig)) {
      New-Item -Path $ompConfig -Force 
      Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/omp/theme.json' -OutFile $ompConfig
    }

    # Check for the starship config file and download it if it's not there
    if (-not (Test-Path $starshipConfig)) {
      New-Item -Path $starshipConfig -Force 
      Invoke-WebRequest -Uri 'https://starship.rs/presets/toml/tokyo-night.toml' -OutFile $starshipConfig
    }

    # Check for the Starship registry key
    if ($null -eq $starShipKey) {
      New-ItemProperty -Path $KeyPath -Name 'Starship' -Value 0 -PropertyType 'String' -Force 
    }
  
    # Check if the starship prompt is enabled otherwise enable oh-my-posh (Disabled by default)
    if ($starShipKey.Starship -eq 0) {
      oh-my-posh init pwsh --config $ompConfig | Invoke-Expression
    }
    elseif ($starShipKey.Starship -eq 1) {
      Invoke-Expression (&starship init powershell)
    }

    # Check if the necessary tools are installed and install them if they're not
    if ($null -eq $sysinternalsKey) {
      New-ItemProperty -Path $ToolsKeyPath -Name 'SysinternalsInstalled' -Value 1 -PropertyType 'DWord' -Force
      choco install sysinternals -y
    }
    if ($null -eq $nerdfontKey) {
      New-ItemProperty -Path $ToolsKeyPath -Name 'NerdFontInstalled' -Value 1 -PropertyType 'DWord' -Force 
      oh-my-posh font install
    }
    if ($null -eq $csharpKey) {
      New-ItemProperty -Path $ToolsKeyPath -Name 'CSharpReplInstalled' -Value 1 -PropertyType 'DWord' -Force 
      dotnet tool install -g csharprepl
    }

    # Check if the profile has been run before
    if ($firstRunKey.FirstRun -eq 1) {
      if (-not (Test-Path $KeyPath)) {
        New-Item -Path $KeyPath -Force 
      }
      New-ItemProperty -Path $KeyPath -Name 'FirstRun' -Value 0 -PropertyType 'DWord' -Force 
      
      Write-TimestampedInformation "Optimizing your shell for the first time. This may take a few minutes..."
      if ($ShellType -eq "PowerShell") {
        Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/ps-optimize-assemblies/main/optimize-assemblies.ps1" | Invoke-Expression
      }
      Write-TimestampedInformation "Done!"

      $form.ShowDialog()
    }
  }

  END {
    $form.Dispose() # Dispose of the form

    Set-PSReadlineConfiguration # Set the PSReadline configuration

    Import-Functions # Import custom functions

    Import-Variables # Import custom variables

    Clear-Host # Clear the host

    # Display the login message if it's enabled
    if ($loginMessageKey.LoginMessage) {
      Write-Host "Microsoft Windows [Version $($KernelVersion)]"
      Write-Host "(c) Microsoft Corporation. All rights reserved.`n"
    
      Write-Host "Azrael's $($ShellType) v$($CurrentVersion.Trim())"
      Write-Host "Copyright (c) 2023-2024 Azrael"
      Write-Host "https://github.com/luke-beep/shell-config/`n"
    }

    if ($randomTipKey.RandomTip) {
      $tips = (Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/random-tips.txt') -split "`n"
      $tip = Get-Random -InputObject $tips
      Write-Host "Randomized terminal tip: $tip`n"
    }
  }
}
Initialize-Profile

function Manage-Functions {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $newFunctionsFilePath = Join-Path (Split-Path -Parent $PROFILE) "custom-functions.ps1"
    $newFunctionsFileUrl = "https://github.com/luke-beep/shell-config/raw/main/configs/pwsh/custom-functions.ps1"
    if (-not (Test-Path $newFunctionsFilePath)) {
      Invoke-WebRequest -Uri $newFunctionsFileUrl -OutFile $newFunctionsFilePath
    }
    
    $PanelWidth = 900
    $PanelHeight = 500

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Manage Custom Functions"
    $form.BackColor = $PrimaryBackgroundColor
    $form.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.Icon = $ShellIcon

    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 2
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
    $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $tableLayoutPanel.BackColor = $PrimaryBackgroundColor
    $tableLayoutPanel.ForeColor = $PrimaryForegroundColor

    $richTextBox = New-Object System.Windows.Forms.RichTextBox
    $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $richTextBox.Text = (Get-Content $newFunctionsFilePath | Out-String)
    $richTextBox.BackColor = $PrimaryBackgroundColor
    $richTextBox.ForeColor = $PrimaryForegroundColor
    $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
    $richTextBox.ReadOnly = $false
    $richTextBox.BorderStyle = 'None'
    $richTextBox.ScrollBars = 'Vertical'

    $button = New-Object System.Windows.Forms.Button
    $button.Size = New-Object System.Drawing.Size($PanelWidth, 30)
    $button.Text = "Save Functions"
    $button.Dock = [System.Windows.Forms.DockStyle]::Fill
    $button.BackColor = $SecondaryBackgroundColor
    $button.ForeColor = $SecondaryForegroundColor
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderColor = $AccentColor
    $button.FlatAppearance.BorderSize = 1
    $button.Add_Click({
        $richTextBox.SaveFile($newFunctionsFilePath, 'PlainText')
        . $newFunctionsFilePath
        [System.Windows.Forms.MessageBox]::Show("Functions saved.", "Success")
      })

    $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)
    $tableLayoutPanel.Controls.Add($button, 0, 1)

    $form.Controls.Add($tableLayoutPanel)

  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.ShowDialog()
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.Dispose()
  }
}

function Preview-Functions {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [Alias('c')]
    [switch]$ShowInConsole = $false
  )  

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if (-not ($ShowInConsole)) {
      $PanelWidth = 900

      $form = New-Object System.Windows.Forms.Form
      $form.Text = "Preview Functions"
      $form.BackColor = $PrimaryBackgroundColor
      $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
      $form.StartPosition = 'CenterScreen'
      $form.FormBorderStyle = 'FixedDialog'
      $form.Icon = $ShellIcon
      

      $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
      $tableLayoutPanel.RowCount = 1
      $tableLayoutPanel.ColumnCount = 1
      $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
      $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
      $tableLayoutPanel.RowStyles.Clear()
      $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
      $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
      $tableLayoutPanel.BackColor = $PrimaryBackgroundColor
      $tableLayoutPanel.ForeColor = $PrimaryForegroundColor

      $richTextBox = New-Object System.Windows.Forms.RichTextBox
      $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, 500)
      $richTextBox.Text = (Get-Command -CommandType Function | Out-String)
      $richTextBox.BackColor = $PrimaryBackgroundColor
      $richTextBox.ForeColor = $PrimaryForegroundColor
      $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
      $richTextBox.ReadOnly = $true
      $richTextBox.BorderStyle = 'None'
      $richTextBox.ScrollBars = 'Vertical'

      $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)

      $form.Controls.Add($tableLayoutPanel)
    }
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($ShowInConsole) {
      Get-Command -CommandType Function
    }
    else {
      $form.ShowDialog()
    }
  }
  
  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if (-not ($ShowInConsole)) {
      $form.Dispose()
    }
  }
}

function Manage-Variables {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters
  
  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $newVariablesFilePath = Join-Path (Split-Path -Parent $PROFILE) "custom-variables.ps1"
    $newVariablesFileUrl = "https://github.com/luke-beep/shell-config/raw/main/configs/pwsh/custom-variables.ps1"

    if (-not (Test-Path $newVariablesFilePath)) {
      Invoke-WebRequest -Uri $newVariablesFileUrl -OutFile $newVariablesFilePath
    }
    
    $PanelWidth = 900
    $PanelHeight = 500

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Manage Custom Variables"
    $form.BackColor = $PrimaryBackgroundColor
    $form.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.Icon = $ShellIcon
    

    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 2
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
    $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $tableLayoutPanel.BackColor = $PrimaryBackgroundColor
    $tableLayoutPanel.ForeColor = $PrimaryForegroundColor

    $richTextBox = New-Object System.Windows.Forms.RichTextBox
    $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $richTextBox.Text = (Get-Content $newVariablesFilePath | Out-String)
    $richTextBox.BackColor = $PrimaryBackgroundColor
    $richTextBox.ForeColor = $PrimaryForegroundColor
    $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
    $richTextBox.ReadOnly = $false
    $richTextBox.BorderStyle = 'None'
    $richTextBox.ScrollBars = 'Vertical'

    $button = New-Object System.Windows.Forms.Button
    $button.Size = New-Object System.Drawing.Size($PanelWidth, 30)
    $button.Text = "Save Variables"
    $button.Dock = [System.Windows.Forms.DockStyle]::Fill
    $button.BackColor = $SecondaryBackgroundColor
    $button.ForeColor = $SecondaryForegroundColor
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderColor = $AccentColor
    $button.FlatAppearance.BorderSize = 1
    $button.Add_Click({
        $richTextBox.SaveFile($newVariablesFilePath, 'PlainText')
        . $newVariablesFilePath
        [System.Windows.Forms.MessageBox]::Show("Variables saved.", "Success")
      })

    $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)
    $tableLayoutPanel.Controls.Add($button, 0, 1)
    $form.Controls.Add($tableLayoutPanel)
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.ShowDialog()
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.Dispose()
  }
}

function Preview-Variables {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [Alias('c')]
    [switch]$ShowInConsole = $false
  )  

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if (-not ($ShowInConsole)) {
      $PanelWidth = 900

      $form = New-Object System.Windows.Forms.Form
      $form.Text = "Preview Variables"
      $form.BackColor = $PrimaryBackgroundColor
      $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
      $form.StartPosition = 'CenterScreen'
      $form.FormBorderStyle = 'FixedDialog'
      $form.Icon = $ShellIcon

      $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
      $tableLayoutPanel.RowCount = 1
      $tableLayoutPanel.ColumnCount = 1
      $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
      $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
      $tableLayoutPanel.RowStyles.Clear()
      $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
      $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
      $tableLayoutPanel.BackColor = $PrimaryBackgroundColor
      $tableLayoutPanel.ForeColor = $PrimaryForegroundColor

      $richTextBox = New-Object System.Windows.Forms.RichTextBox
      $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, 500)
      $richTextBox.Text = (Get-Variable -Scope Global | Out-String)
      $richTextBox.BackColor = $PrimaryBackgroundColor
      $richTextBox.ForeColor = $PrimaryForegroundColor
      $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
      $richTextBox.ReadOnly = $true
      $richTextBox.BorderStyle = 'None'
      $richTextBox.ScrollBars = 'Vertical'

      $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)
      $form.Controls.Add($tableLayoutPanel)
    }
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($ShowInConsole) {
      Get-Variable -Scope Global
    }
    else {
      $form.ShowDialog()
    }
  }
  
  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if (-not ($ShowInConsole)) {
      $form.Dispose()
    }
  }
}

function Set-ProfileSettings {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters
  
  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $PanelWidth = 1000
    $PanelHeight = 500

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "$($ShellType) Profile Settings"
    $form.BackColor = $PrimaryBackgroundColor
    $form.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.Icon = $ShellIcon

    $keys = Get-ItemProperty -Path $KeyPath -ErrorAction SilentlyContinue | Select-Object -ExcludeProperty PSPath, PSParentPath, PSChildName, PSDrive, PSProvider
    
    $dataTable = New-Object System.Data.DataTable

    $dataTable.Columns.Add("Name", [string])
    $dataTable.Columns.Add("Value", [string])

    $keys.PSObject.Properties | ForEach-Object {
      $row = $dataTable.NewRow()
      $row["Name"] = $_.Name
      $row["Value"] = $_.Value
      $dataTable.Rows.Add($row)
    }

    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 2
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
    $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $tableLayoutPanel.BackColor = $PrimaryBackgroundColor
    $tableLayoutPanel.ForeColor = $PrimaryForegroundColor

    $dataGridView = New-Object System.Windows.Forms.DataGridView
    $dataGridView.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $dataGridView.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
    $dataGridView.AutoGenerateColumns = $true
    $dataGridView.RowHeadersVisible = $false
    $dataGridView.BackgroundColor = $PrimaryBackgroundColor
    $dataGridView.ForeColor = $PrimaryForegroundColor
    $dataGridView.GridColor = $PrimaryBackgroundColor
    $dataGridView.DefaultCellStyle.BackColor = $PrimaryBackgroundColor
    $dataGridView.DefaultCellStyle.ForeColor = $PrimaryForegroundColor
    $dataGridView.ColumnHeadersDefaultCellStyle.BackColor = $SecondaryBackgroundColor
    $dataGridView.ColumnHeadersDefaultCellStyle.ForeColor = $PrimaryForegroundColor
    $dataGridView.RowHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
    $dataGridView.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
    $dataGridView.DefaultCellStyle.SelectionBackColor = $SecondaryBackgroundColor
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

    $dataGridView.DataSource = $dataTable

    $tableLayoutPanel.Controls.Add($dataGridView, 0, 0)
  
    $button = New-Object System.Windows.Forms.Button
    $button.Size = New-Object System.Drawing.Size($PanelWidth, 30)
    $button.Text = "Save Configuration"
    $button.Dock = [System.Windows.Forms.DockStyle]::Fill
    $button.BackColor = $SecondaryBackgroundColor
    $button.ForeColor = $SecondaryForegroundColor
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderColor = $AccentColor
    $button.FlatAppearance.BorderSize = 1
    $button.Add_Click({
        $dataGridView.Rows | ForEach-Object {
          if (-not $_.IsNewRow) {
            $row = $_.DataBoundItem
            $name = $row["Name"]
            $value = $row["Value"]
            if ([string]::IsNullOrEmpty($value)) {
              Remove-ItemProperty -Path $KeyPath -Name $name
            }
            else {
              Set-ItemProperty -Path $KeyPath -Name $name -Value $value
            }
          }
        }

        $deletedRows | ForEach-Object {
          Remove-ItemProperty -Path $KeyPath -Name $_
          $deletedRows.Remove($_)
        }
        [System.Windows.Forms.MessageBox]::Show("Profile settings saved.", "Success")
      })
    $tableLayoutPanel.Controls.Add($button, 0, 1)

    $form.Controls.Add($tableLayoutPanel)
  }
  
  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.ShowDialog()
  }
  
  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.Dispose()
  }
}

<#
.SYNOPSIS
  Allows you to manage your entire profile
.DESCRIPTION 
  This function allows you to manage your profile
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Manage-Profile {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters
  
  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $PanelWidth = 905

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Manage $($ShellType) Profile"
    $form.BackColor = $PrimaryBackgroundColor
    $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.Icon = $ShellIcon
    

    $buttonPanel2 = New-Object System.Windows.Forms.Panel # 7 buttons
    $buttonPanel2.Dock = 'Top'
    $buttonPanel2.Height = 50
    $buttonPanel2.Width = $PanelWidth

    $buttonPanel = New-Object System.Windows.Forms.Panel # 7 buttons
    $buttonPanel.Dock = 'Top'
    $buttonPanel.Height = 50
    $buttonPanel.Width = $PanelWidth

    $button1 = New-Object System.Windows.Forms.Button
    $button1.Text = "Update Profile"
    $button1.Width = 100
    $button1.Height = 30
    $button1.Location = New-Object System.Drawing.Point(10, 10)
    $button1.BackColor = $SecondaryBackgroundColor
    $button1.ForeColor = $SecondaryForegroundColor
    $button1.FlatStyle = 'Flat'
    $button1.FlatAppearance.BorderSize = 1
    $button1.FlatAppearance.BorderColor = $AccentColor
    $button1.Add_Click({
        $form.Dispose()
        Update-Profile -Force
      })
    $buttonPanel.Controls.Add($button1)

    $updateAliasesButton = New-Object System.Windows.Forms.Button
    $updateAliasesButton.Text = "Update Aliases"
    $updateAliasesButton.Width = 100
    $updateAliasesButton.Height = 30
    $updateAliasesButton.Location = New-Object System.Drawing.Point(120, 10)
    $updateAliasesButton.BackColor = $SecondaryBackgroundColor
    $updateAliasesButton.ForeColor = $SecondaryForegroundColor
    $updateAliasesButton.FlatStyle = 'Flat'
    $updateAliasesButton.FlatAppearance.BorderSize = 1
    $updateAliasesButton.FlatAppearance.BorderColor = $AccentColor
    $updateAliasesButton.Add_Click({
        Import-Aliases -Force
      })

    $buttonPanel.Controls.Add($updateAliasesButton)

    $button2 = New-Object System.Windows.Forms.Button
    $button2.Text = "Change Theme"
    $button2.Width = 100
    $button2.Height = 30
    $button2.Location = New-Object System.Drawing.Point(230, 10)
    $button2.BackColor = $SecondaryBackgroundColor
    $button2.ForeColor = $SecondaryForegroundColor
    $button2.FlatStyle = 'Flat'
    $button2.FlatAppearance.BorderSize = 1
    $button2.FlatAppearance.BorderColor = $AccentColor
    $button2.Add_Click({
        Set-ShellTheme
      })
    $buttonPanel.Controls.Add($button2)

    $button3 = New-Object System.Windows.Forms.Button
    $button3.Text = "Settings"
    $button3.Width = 100
    $button3.Height = 30
    $button3.Location = New-Object System.Drawing.Point(340, 10)
    $button3.BackColor = $SecondaryBackgroundColor
    $button3.ForeColor = $SecondaryForegroundColor
    $button3.FlatStyle = 'Flat'
    $button3.FlatAppearance.BorderSize = 1
    $button3.FlatAppearance.BorderColor = $AccentColor
    $button3.Add_Click({
        Set-ProfileSettings
      })
    $buttonPanel.Controls.Add($button3)

    $button4 = New-Object System.Windows.Forms.Button
    $button4.Text = "Add Alias"
    $button4.Width = 100
    $button4.Height = 30
    $button4.Location = New-Object System.Drawing.Point(450, 10)
    $button4.BackColor = $SecondaryBackgroundColor
    $button4.ForeColor = $SecondaryForegroundColor
    $button4.FlatStyle = 'Flat'
    $button4.FlatAppearance.BorderSize = 1
    $button4.FlatAppearance.BorderColor = $AccentColor
    $button4.Add_Click({
        Add-Aliases
      })
    $buttonPanel.Controls.Add($button4)

    $button5 = New-Object System.Windows.Forms.Button
    $button5.Text = "Remove Alias"
    $button5.Width = 100
    $button5.Height = 30
    $button5.Location = New-Object System.Drawing.Point(560, 10)
    $button5.BackColor = $SecondaryBackgroundColor
    $button5.ForeColor = $SecondaryForegroundColor
    $button5.FlatStyle = 'Flat'
    $button5.FlatAppearance.BorderSize = 1
    $button5.FlatAppearance.BorderColor = $AccentColor
    $button5.Add_Click({
        Remove-Aliases
      })
    $buttonPanel.Controls.Add($button5)

    $button6 = New-Object System.Windows.Forms.Button
    $button6.Text = "Profile Help"
    $button6.Width = 100
    $button6.Height = 30
    $button6.Location = New-Object System.Drawing.Point(670, 10)
    $button6.BackColor = $SecondaryBackgroundColor
    $button6.ForeColor = $SecondaryForegroundColor
    $button6.FlatStyle = 'Flat'
    $button6.FlatAppearance.BorderSize = 1
    $button6.FlatAppearance.BorderColor = $AccentColor
    $button6.Add_Click({
        Get-ProfileHelp -ShowInGUI
      })
    $buttonPanel.Controls.Add($button6)

    $button7 = New-Object System.Windows.Forms.Button
    $button7.Text = "Profile Tips"
    $button7.Width = 100
    $button7.Height = 30
    $button7.Location = New-Object System.Drawing.Point(780, 10)
    $button7.BackColor = $SecondaryBackgroundColor
    $button7.ForeColor = $SecondaryForegroundColor
    $button7.FlatStyle = 'Flat'
    $button7.FlatAppearance.BorderSize = 1
    $button7.FlatAppearance.BorderColor = $AccentColor
    $button7.Add_Click({
        Get-ShellTips
      })
    $buttonPanel.Controls.Add($button7)

    $button8 = New-Object System.Windows.Forms.Button
    $button8.Text = "Check Health"
    $button8.Width = 100
    $button8.Height = 30
    $button8.Location = New-Object System.Drawing.Point(10, 0)
    $button8.BackColor = $SecondaryBackgroundColor
    $button8.ForeColor = $SecondaryForegroundColor
    $button8.FlatStyle = 'Flat'
    $button8.FlatAppearance.BorderSize = 1
    $button8.FlatAppearance.BorderColor = $AccentColor
    $button8.Add_Click({
        Analyze-Profile -GUI
      })
    $buttonPanel2.Controls.Add($button8)

    $button9 = New-Object System.Windows.Forms.Button
    $button9.Text = "Functions"
    $button9.Width = 100
    $button9.Height = 30
    $button9.Location = New-Object System.Drawing.Point(120, 0)
    $button9.BackColor = $SecondaryBackgroundColor
    $button9.ForeColor = $SecondaryForegroundColor
    $button9.FlatStyle = 'Flat'
    $button9.FlatAppearance.BorderSize = 1
    $button9.FlatAppearance.BorderColor = $AccentColor
    $button9.Add_Click({
        Manage-Functions
      })
    $buttonPanel2.Controls.Add($button9)

    $button10 = New-Object System.Windows.Forms.Button
    $button10.Text = "Preview Function"
    $button10.Width = 100
    $button10.Height = 30
    $button10.Location = New-Object System.Drawing.Point(230, 0)
    $button10.BackColor = $SecondaryBackgroundColor
    $button10.ForeColor = $SecondaryForegroundColor
    $button10.FlatStyle = 'Flat'
    $button10.FlatAppearance.BorderSize = 1
    $button10.FlatAppearance.BorderColor = $AccentColor
    $button10.Add_Click({
        Preview-Functions
      })
    $buttonPanel2.Controls.Add($button10)

    $button11 = New-Object System.Windows.Forms.Button
    $button11.Text = "Variables"
    $button11.Width = 100
    $button11.Height = 30
    $button11.Location = New-Object System.Drawing.Point(340, 0)
    $button11.BackColor = $SecondaryBackgroundColor
    $button11.ForeColor = $SecondaryForegroundColor
    $button11.FlatStyle = 'Flat'
    $button11.FlatAppearance.BorderSize = 1
    $button11.FlatAppearance.BorderColor = $AccentColor
    $button11.Add_Click({
        Manage-Variables
      })
    $buttonPanel2.Controls.Add($button11)

    $button12 = New-Object System.Windows.Forms.Button
    $button12.Text = "Preview Variables"
    $button12.Width = 100
    $button12.Height = 30
    $button12.Location = New-Object System.Drawing.Point(450, 0)
    $button12.BackColor = $SecondaryBackgroundColor
    $button12.ForeColor = $SecondaryForegroundColor
    $button12.FlatStyle = 'Flat'
    $button12.FlatAppearance.BorderSize = 1
    $button12.FlatAppearance.BorderColor = $AccentColor
    $button12.Add_Click({
        Preview-Variables
      })
    $buttonPanel2.Controls.Add($button12)

    $button13 = New-Object System.Windows.Forms.Button
    $button13.Text = "Profile Directory"
    $button13.Width = 100
    $button13.Height = 30
    $button13.Location = New-Object System.Drawing.Point(560, 0)
    $button13.BackColor = $SecondaryBackgroundColor
    $button13.ForeColor = $SecondaryForegroundColor
    $button13.FlatStyle = 'Flat'
    $button13.FlatAppearance.BorderSize = 1
    $button13.FlatAppearance.BorderColor = $AccentColor
    $button13.Add_Click({
        Start-Process -FilePath (Split-Path -Parent $PROFILE)
      })
    $buttonPanel2.Controls.Add($button13)

    $button14 = New-Object System.Windows.Forms.Button
    $button14.Text = "History"
    $button14.Width = 100
    $button14.Height = 30
    $button14.Location = New-Object System.Drawing.Point(670, 0)
    $button14.BackColor = $SecondaryBackgroundColor
    $button14.ForeColor = $SecondaryForegroundColor
    $button14.FlatStyle = 'Flat'
    $button14.FlatAppearance.BorderSize = 1
    $button14.FlatAppearance.BorderColor = $AccentColor
    $button14.Add_Click({
        Start-Process -FilePath "$UserProfile\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine"
      })
    $buttonPanel2.Controls.Add($button14)

    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 3
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))

    $richTextBox = New-Object System.Windows.Forms.RichTextBox
    $richTextBox.Location = New-Object System.Drawing.Point(0, 100)
    $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, 500)
    $richTextBox.Text = (Get-Content $profile | Out-String)
    $richTextBox.BackColor = $PrimaryBackgroundColor
    $richTextBox.ForeColor = $PrimaryForegroundColor
    $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
    $richTextBox.ReadOnly = $true
    $richTextBox.BorderStyle = 'None'
    $richTextBox.ScrollBars = 'Vertical'

    $tableLayoutPanel.Controls.Add($buttonPanel, 0, 0)
    $tableLayoutPanel.Controls.Add($buttonPanel2, 0, 1)
    $tableLayoutPanel.Controls.Add($richTextBox, 0, 2)

    $form.Controls.Add($tableLayoutPanel)
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.ShowDialog()
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.Dispose()
  }
}

<#
.SYNOPSIS
  Gets all of the available packages
.DESCRIPTION 
  This function gets all of the available packages
.PARAMETER Install 
  If this parameter is specified, the packages will be updated
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-Packages {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [string]$Install
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $scoop = Get-Command -Name scoop -ErrorAction SilentlyContinue
    $winget = Get-Command -Name winget -ErrorAction SilentlyContinue
    $choco = Get-Command -Name choco -ErrorAction SilentlyContinue
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    # Check if scoop is installed
    if ($scoop) {
      scoop list
    }
    # Check if winget is installed
    if ($winget) {
      winget list
    }
    # Check if choco is installed
    if ($choco) {
      choco list
    }
    if ($Install) {
      # Check if scoop is installed
      if ($scoop) {
        # Update scoop
        scoop update *
      }
      # Check if winget is installed
      if ($winget) {
        # Update winget
        winget upgrade --all
      }
      # Check if choco is installed
      if ($choco) {
        # Update choco
        choco upgrade all -y
      }
    }
  }
}

<#
.SYNOPSIS
  Lists all directories and files at a given path or in the current directory if no path is provided.
.DESCRIPTION
  This function lists all directories and files at a given path. If no path is provided, it lists directories and files in the current directory.
.PARAMETER Path 
  The path where to list the directories and files. If not provided, the current directory is used.
.PARAMETER Recurse 
  If this parameter is specified, the function will list all directories and files recursively.
.PARAMETER ShowHidden
  If this parameter is specified, the function will show hidden directories and files.
.EXAMPLE
  List-Directories -Path "C:\Users\" -Recurse
.EXAMPLE
  List-Directories -Path "C:\Users\" -ShowHidden
.EXAMPLE
  List-Directories -Path "C:\Users\" -Recurse -ShowHidden
.OUTPUTS
  A list of directories and files at the given path or in the current directory if no path is provided.
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function List-Directories {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [string]$Path = ".",

    [Parameter(Mandatory = $false)]
    [Alias("R")]
    [switch]$Recurse = $false,

    [Parameter(Mandatory = $false)]
    [Alias("a")]
    [switch]$ShowHidden = $false
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($Recurse) {
      Get-ChildItem -Path $Path -Recurse -Force:$ShowHidden | Format-Table -AutoSize
    }
    else {
      Get-ChildItem -Path $Path -Force:$ShowHidden | Format-Table -AutoSize
    }
  }
}
<#
.SYNOPSIS
  Prints the current working directory
.DESCRIPTION
  This function prints the current working directory
.EXAMPLE
  Print-Working-Directory
.OUTPUTS
  The current working directory, e.g. C:\Users\
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Print-Working-Directory {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $CurrentDirectory = Get-Location
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $CurrentDirectory.Path
  }
}

<#
.SYNOPSIS
  Navigates to a directory
.DESCRIPTION
  This function allows you to navigate to a directory
.PARAMETER Path
  The path of the directory
.EXAMPLE
  Change-Directory -Path "C:\Users\"
.EXAMPLE
  Change-Directory -
.EXAMPLE
  Change-Directory ..
.OUTPUTS
  A list of directories and files in the current directory
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Change-Directory {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [string]$Path,

    [Parameter(Mandatory = $false)]
    [Alias("s")]
    [switch]$Silent = $false
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($Path) {
      Push-Location -Path $Path
    }
    if ($Silent -eq $false) {
      List-Directories
    }
  }
}

<#
.SYNOPSIS
  Creates one or more directories
.DESCRIPTION
  This function creates one or more directories
.PARAMETER Path
  The path of the directory
.PARAMETER Verbose
  If this parameter is specified, the function will print each directory that is created
.EXAMPLE
  Make-Directory -Path "C:\Users\"
.EXAMPLE
  Make-Directory -Path "C:\Users\", "C:\Users\Public" -Verbose
.EXAMPLE
  Make-Directory -Path "C:\Users\", "C:\Users\Public" -Verbose -Permission "W"
.OUTPUTS
  A list of directories that were created if the Verbose parameter is specified, otherwise nothing
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Make-Directory {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string[]]$Path,
    
    [Parameter(Mandatory = $false)]
    [Alias("m")]
    [string]$Permission
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $Path | ForEach-Object {
      New-Item -Path $_ -ItemType Directory -Force
      if ($Permission) {
        icacls $_ /grant "$($UserName):$Permission" /c /q
      }
    }
  }
}

<#
.SYNOPSIS
  Removes one or more directories
.DESCRIPTION
  This function removes one or more directories
.PARAMETER Path
  The path of the directory
.PARAMETER Recurse
  If this parameter is specified, the function will remove all directories and files recursively
.EXAMPLE
  Remove-Directory -Path "C:\Users\"
.EXAMPLE
  Remove-Directory -Path "C:\Users\", "C:\Users\Public" -Recurse
.OUTPUTS
  A list of directories that were removed
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Remove-Directory {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [Alias("p")]
    [switch]$Recurse,

    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $Path | ForEach-Object {
      if ($Recurse) {
        Remove-Item -Path $_ -Recurse -Force
      }
      else {
        Remove-Item -Path $_
      }
    }
  }
}

<#
.SYNOPSIS
  Deletes one or more files
.DESCRIPTION
  This function deletes one or more files
.PARAMETER Path
  The path of the file
.PARAMETER Prompt
  If this parameter is specified, the function will prompt you before deleting the file
.PARAMETER Force
  If this parameter is specified, the function will delete the file without prompting you
.PARAMETER Recurse
  If this parameter is specified, the function will delete all files and directories recursively
.EXAMPLE
  Remove-File -Path "C:\Users\file.txt"
.EXAMPLE
  Remove-File -Path "C:\Users\file.txt", "C:\Users\file2.txt"
.OUTPUTS
  A list of files that were deleted
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Remove-File {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (  
    [Parameter(Mandatory = $true)]
    [string[]]$Path,
  
    [Parameter(Mandatory = $false)]
    [Alias("i")]
    [switch]$Prompt,

    [Parameter(Mandatory = $false)]
    [Alias("f")]
    [switch]$Force,

    [Parameter(Mandatory = $false)]
    [Alias("r")]
    [switch]$Recurse
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $Path | ForEach-Object {
      if ($Prompt) {
        $result = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete $_?", "Delete File", [System.Windows.Forms.MessageBoxButtons]::YesNo)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
          Remove-Item -Path $_ -Force:$Force -Recurse:$Recurse
        }
      }
      else {
        Remove-Item -Path $_ -Force:$Force -Recurse:$Recurse
      }
    }
  }
}

<#
.SYNOPSIS
  Copies one or more files or folders to a destination
.DESCRIPTION
  This function copies one or more files or folders to a destination
.PARAMETER Recurse
  If this parameter is specified, the function will copy all files and directories recursively
.PARAMETER Source
  The source of the file or folder
.PARAMETER Destination
  The destination of the file or folder
.EXAMPLE
  Copy-Item -Source "C:\Users\file.txt" -Destination "C:\Users\Documents\"
.EXAMPLE
  Copy-Item -Source "C:\Users\file.txt", "C:\Users\file2.txt" -Destination "C:\Users\Documents\"
.EXAMPLE
  Copy-Item -Source "C:\Users\folder" -Destination "C:\Users\Documents\" -Recurse
.OUTPUTS
  Nothing.
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Copy-Folder-File {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (  
    [Parameter(Mandatory = $true)]
    [string[]]$Source,

    [Parameter(Mandatory = $true)]
    [string]$Destination,

    [Parameter(Mandatory = $false)]
    [Alias("R")]
    [Switch]$Recurse
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($item in $Source) {
      Copy-Item $item $Destination -Recurse:$Recurse
    }
  }
}

<#
.SYNOPSIS
  Moves one or more files or folders to a destination
.DESCRIPTION
  This function moves one or more files or folders to a destination
.PARAMETER Source
  The source of the file or folder
.PARAMETER Destination
  The destination of the file or folder
.EXAMPLE
  Move-Item -Source "C:\Users\file.txt" -Destination "C:\Users\Documents\"
.EXAMPLE
  Move-Item -Source "C:\Users\file.txt", "C:\Users\file2.txt" -Destination "C:\Users\Documents\"
.EXAMPLE
  Move-Item -Source "C:\Users\folder" -Destination "C:\Users\Documents\"
.OUTPUTS
  Nothing.
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Move-Folder-File {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string[]]$Source,

    [Parameter(Mandatory = $true)]
    [string]$Destination
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($item in $Source) {
      Move-Item $item $Destination
    }
  }
}

<#
.SYNOPSIS
  Creates one or more files
.DESCRIPTION
  This function creates one or more files
.PARAMETER Path
  The path of the file(s)
.EXAMPLE
  Create-File -Path "C:\Users\file.txt"
.EXAMPLE
  Create-File -Path "C:\Users\file.txt", "C:\Users\file2.txt"
.OUTPUTS
  Nothing.
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Create-File {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($item in $Path) {
      if (!(Test-Path $item)) {
        New-Item -ItemType File -Path $item -Force
      }
      else {
          (Get-Item -Path $item).LastWriteTime = Get-Date
      }
    }
  }
}

<#
.SYNOPSIS
  Lets you check a file's type
.DESCRIPTION
  This function lets you check a file's type
.PARAMETER Path
  The path of the file
.EXAMPLE
  File-Type -Path "C:\Users\file.txt"
.EXAMPLE
  File-Type -Path "C:\Users\file.txt", "C:\Users\file2.txt"
.OUTPUTS
  The file's type. E.g. "C:\Users\file.txt" -> ".txt"
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function File-Type {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($item in $Path) {
      if (Test-Path $item) {
        $file = Get-Item -Path $item
        $file.Extension
      }
    }
  }
}

<#
.SYNOPSIS
  Lets you read a file
.DESCRIPTION
  This function lets you read a file, and if the file doesn't exist, it creates it
.PARAMETER Path
  The path of the file
.EXAMPLE
  Read-File -Path "C:\Users\file.txt"
.EXAMPLE
  Read-File -Path "C:\Users\file.txt", "C:\Users\file2.txt"
.OUTPUTS
  The file's contents
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Read-File {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($item in $Path) {
      if (Test-Path $item) {
        $file = Get-Item -Path $item
        Get-Content $file
      }
      else {
        New-Item -ItemType File -Path $item -Force
      }
    }
  }
}

<#
.SYNOPSIS
  Lets you read a file in reverse
.DESCRIPTION
  This function lets you read a file in reverse
.PARAMETER Path
  The path of the file
.EXAMPLE
  Read-File-Reverse -Path "C:\Users\file.txt"
.EXAMPLE
  Read-File-Reverse -Path "C:\Users\file.txt", "C:\Users\file2.txt"
.OUTPUTS
  The file's contents in reverse
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Read-File-Reverse {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($item in $Path) {
      $content = Get-Content $item -ReadCount 0
      [array]::Reverse($content)
      $content
    }
  }
}

<#
.SYNOPSIS
  Grab the first few lines of a file
.DESCRIPTION
  This function grabs the first few lines of a file
.PARAMETER Path
  The path of the file
.PARAMETER Lines
  The number of lines to grab
.EXAMPLE
  Head-File -Path "C:\Users\file.txt"
.EXAMPLE
  Head-File -Path "C:\Users\file.txt", "C:\Users\file2.txt"
.EXAMPLE
  Head-File -Path "C:\Users\file.txt" -Lines 5
.OUTPUTS
  The first few lines of the file (default is 10)
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Head-File {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (      
    [Parameter(Mandatory = $true)]
    [string[]]$Path,

    [Parameter(Mandatory = $false)]
    [Alias("n")]
    [int]$Lines = 10
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($item in $Path) {
      Get-Content $item -TotalCount $Lines
    }
  }
}

<#
.SYNOPSIS
  Grab the last few lines of a file
.DESCRIPTION
  This function grabs the last few lines of a file
.PARAMETER Path
  The path of the file
.PARAMETER Lines
  The number of lines to grab
.EXAMPLE
  Tail-File -Path "C:\Users\file.txt"
.EXAMPLE
  Tail-File -Path "C:\Users\file.txt", "C:\Users\file2.txt"
.EXAMPLE
  Tail-File -Path "C:\Users\file.txt" -Lines 5
.OUTPUTS
  The last few lines of the file (default is 10)
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Tail-File {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (    
    [Parameter(Mandatory = $true)]
    [string[]]$Path,

    [Parameter(Mandatory = $false)]
    [Alias("n")]
    [int]$Lines = 10
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($item in $Path) {
      $content = Get-Content $item
      $content[ - $Lines..-1]
    }
  }
}

<#
.SYNOPSIS
  Lets you compare two files
.DESCRIPTION
  This function lets you compare two files
.PARAMETER Path
  The path of the file
.EXAMPLE
  Compare-File -Path "C:\Users\file.txt", "C:\Users\file2.txt"
.OUTPUTS
  The differences between the two files
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Differential-File {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($item in $Path) {
      Compare-Object -ReferenceObject (Get-Content $item) -DifferenceObject (Get-Content $item)
    }
  }
}

<#
.SYNOPSIS
  Lets you write the input to shell and files
.DESCRIPTION
  This function lets you write the input to shell and files
.PARAMETER InputObject
  The input to write to shell and files
.PARAMETER FilePath
  The path of the file(s)
.EXAMPLE
  "Hello, World!" | Write-OutputAndFile -FilePath "C:\Users\file.txt"
.EXAMPLE
  "Hello, World!" | Write-OutputAndFile -FilePath "C:\Users\file.txt", "C:\Users\file2.txt"
.OUTPUTS
  The input written to shell and files
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Write-OutputAndFile {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$InputObject,

    [Parameter(Mandatory = $true)]
    [string[]]$FilePath
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($file in $FilePath) {
      $InputObject | Tee-Object -FilePath $file -Append
    }
  }
}

<#
.SYNOPSIS
  This command lets you find a file in a directory. 
.DESCRIPTION
  This command lets you find a file in a directory.
.PARAMETER Pattern
  The pattern to search for
.EXAMPLE
  Locate-File -Pattern "file"
.EXAMPLE
  Locate-File -Pattern "file*anotherfile"
.EXAMPLE
  Locate-File -Pattern "file" | Select-Object FullName
.OUTPUTS
  The file(s) that match the pattern
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Locate-File {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string]$Pattern
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $currentLocation = Get-Location
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Get-ChildItem -Path $currentLocation -Filter "*$Pattern*" -File -Recurse -ErrorAction SilentlyContinue | Select-Object FullName
  }
}

<#
.SYNOPSIS
  Searches for files or directories with a specific name in a given path.

.DESCRIPTION
  The Find-Item function uses the Get-ChildItem cmdlet to search for items (files or directories) with a specific name in a given path and its subdirectories. 
  If the path is not provided, it defaults to the current location. 
  The type of the items to search for can be specified with the ItemType parameter ("f" for files, "d" for directories). 
  If the ItemType parameter is not provided, it defaults to "f" (files).

.PARAMETER Path
  The path in which to search for the item. If not provided, the current location is used.

.PARAMETER ItemName
  The name of the item to search for.

.PARAMETER ItemType
  The type of the item to search for ("f" for files, "d" for directories). If not provided, it defaults to "f" (files).

.EXAMPLE
  Find-Item -ItemName "file1.txt"
  This command will return the full paths of all files named "file1.txt" in the current directory and its subdirectories.

.EXAMPLE
  Find-Item -Path "C:\" -ItemName "directoryname" -ItemType "d"
  This command will return the full paths of all directories named "directoryname" in the `C:\` directory and its subdirectories.

.OUTPUTS
  The full paths of the items that match the specified name and type.
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Find-Item {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [string]$Path = (Get-Location),

    [Parameter(Mandatory = $true)]
    [Alias("name")]
    [string]$ItemName,

    [Parameter(Mandatory = $false)]
    [ValidateSet("f", "d")]
    [Alias("type")]
    [string]$ItemType = "f"
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($ItemType -eq "f") {
      Get-ChildItem -Path $Path -Filter $ItemName -File -Recurse -ErrorAction SilentlyContinue | Select-Object FullName
    }
    else {
      Get-ChildItem -Path $Path -Filter $ItemName -Directory -Recurse -ErrorAction SilentlyContinue | Select-Object FullName
    }
  }
}

<#
.SYNOPSIS
  Retrieves detailed information about the disk usage of the drives on your system.
.DESCRIPTION
  The Get-DiskUsage function provides detailed information about the disk usage of the drives on your system. It can be customized with several optional parameters to specify a particular drive and the unit of measurement for the disk usage information.
.PARAMETER Drive
  Specify a particular drive to get information about. If not provided, the function will return information about all fixed drives.
.PARAMETER Megabytes
  If this switch is provided, the disk usage information will be displayed in megabytes.
.PARAMETER Kilobytes
  If this switch is provided, the disk usage information will be displayed in kilobytes.
.PARAMETER FilesystemType
  This switch filters the output by file system type.
.EXAMPLE
  Get-DiskUsage -Drive "C" This command will return the disk usage information for the C: drive, in gigabytes.
.EXAMPLE
  Get-DiskUsage -Megabytes This command will return the disk usage information for all fixed drives, in megabytes.
.OUTPUTS
  A custom object for each drive.
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-DiskUsage {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [string]$Drive,

    [Parameter(Mandatory = $false)]
    [Alias("m")]
    [switch]$Megabytes,

    [Parameter(Mandatory = $false)]
    [Alias("k")]
    [switch]$Kilobytes,

    [Parameter(Mandatory = $false)]
    [Alias("T")]
    [switch]$FilesystemType
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $sizeType = "GB"
    if ($Megabytes) {
      $sizeType = "MB"
    }
    elseif ($Kilobytes) {
      $sizeType = "KB"
    }
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($Drive) {
      $vol = Get-Volume -DriveLetter $Drive
      $vol | Format-Table -AutoSize
    }
    else {
      Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' } | ForEach-Object {
        $used = ($_.Size - $_.SizeRemaining) / ("1$($sizeType)")
        $total = $_.Size / ("1$($sizeType)")
        $free = $_.SizeRemaining / ("1$($sizeType)")
        if ($FilesystemType) {
          $fileSystem = $_.FileSystem
          [PSCustomObject]@{
            Name                 = $_.FileSystemLabel
            'Drive Letter'       = $_.DriveLetter
            'Used'               = [Math]::Round($used, 2)
            'Free'               = [Math]::Round($free, 2)
            'Total'              = [Math]::Round($total, 2)
            'File System'        = $fileSystem
            'Health Status'      = $_.HealthStatus
            'Operational Status' = $_.OperationalStatus
            'Unit'               = $sizeType
          }
        }
        else {
          [PSCustomObject]@{
            Name                 = $_.FileSystemLabel
            'Drive Letter'       = $_.DriveLetter
            'Used'               = [Math]::Round($used, 2)
            'Free'               = [Math]::Round($free, 2)
            'Total'              = [Math]::Round($total, 2)
            'Health Status'      = $_.HealthStatus
            'Operational Status' = $_.OperationalStatus
            'Unit'               = $sizeType
          }      
        }
      }
    }
  }
}

<#
.SYNOPSIS
  Retrieves the size of a directory and its subdirectories.
.DESCRIPTION
  The Get-DirectorySize function calculates the total size of all files in a specified directory and its subdirectories. The size is returned in gigabytes by default, but can be returned in megabytes or kilobytes if the -Megabytes or -Kilobytes switch is provided, respectively. If the -LastModified switch is provided, the function will also return the last modification date of the most recently modified file in the directory.
.PARAMETER Path
  The path to the directory for which to calculate the size.
.PARAMETER Megabytes
  If this switch is provided, the size will be returned in megabytes.
.PARAMETER Kilobytes
  If this switch is provided, the size will be returned in kilobytes.
.PARAMETER LastModified
  If this switch is provided, the function will return the last modification date of the most recently modified file in the directory.
.EXAMPLE
  Get-DirectorySize -Path "C:\Users\username\Documents" This command will return the total size of all files in the "C:\Users\username\Documents" directory and its subdirectories, in gigabytes.
.EXAMPLE
  Get-DirectorySize -Path "C:\Users\username\Documents" -Megabytes -LastModified This command will return the total size of all files in the "C:\Users\username\Documents" directory and its subdirectories, in megabytes, as well as the last modification date of the most recently modified file in the directory.
.OUTPUTS
  A custom object with the following properties: Path, Size, Unit, Last Modified (if the -LastModified switch is provided).
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-DirectorySize {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string]$Path,

    [Parameter(Mandatory = $false)]
    [Alias("m")]
    [switch]$Megabytes,

    [Parameter(Mandatory = $false)]
    [Alias("k")]
    [switch]$Kilobytes,

    [Parameter(Mandatory = $false)]
    [Alias("h")]
    [switch]$LastModified
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $items = Get-ChildItem $Path -Recurse -File
    $size = ($items | Measure-Object -Property Length -Sum).Sum
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($Megabytes) {
      $size = $size / 1MB
      $unit = "MB"
    }
    elseif ($Kilobytes) {
      $size = $size / 1KB
      $unit = "KB"
    }
    else {
      $size = $size / 1GB
      $unit = "GB"
    }
  
    $output = [PSCustomObject]@{
      Path = $Path
      Size = [Math]::Round($size, 2)
      Unit = $unit
    }
  
    if ($LastModified) {
      $lastModified = $items | Sort-Object LastWriteTime -Descending | Select-Object -First 1
      $output | Add-Member -Type NoteProperty -Name "Last Modified" -Value $lastModified.LastWriteTime
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    return $output
  }
}

<#
.SYNOPSIS
  Prints information about the current system.
.DESCRIPTION
  The Get-SystemInfo function prints information about the current system. It can be customized with the -KernelName and -NodeHostName switches to return only the kernel version and the hostname, respectively.
.PARAMETER KernelName
  If this switch is provided, the function will return the kernel version.
.PARAMETER NodeHostName
  If this switch is provided, the function will return the hostname.
.EXAMPLE
  Get-SystemInfo -KernelName
.EXAMPLE
  Get-SystemInfo -NodeHostName
.OUTPUTS
  A custom object with the following properties: KernelName, NodeHostName.
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-SystemInfo {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [Alias("s")]
    [switch]$KernelName,

    [Parameter(Mandatory = $false)]
    [Alias("n")]
    [switch]$NodeHostName
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($KernelName) {
      $output = [PSCustomObject]@{
        'Kernel version' = (Get-CimInstance -ClassName Win32_OperatingSystem).Version
      }
    }
    elseif ($NodeHostName) {
      $output = [PSCustomObject]@{
        'Hostname' = [System.Net.Dns]::GetHostName()
      }
    }
    else {
      $output = [PSCustomObject]@{
        OS               = (Get-CimInstance -ClassName CIM_OperatingSystem).Caption
        'Hostname'       = [System.Net.Dns]::GetHostName()
        Version          = [System.Environment]::OSVersion.Version
        'Kernel version' = (Get-CimInstance -ClassName Win32_OperatingSystem).Version
        Time             = Get-Date -Format "HH:mm:ss"
      }
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    return $output
  }
}

<#
.SYNOPSIS
  Prints information about the current user.
.DESCRIPTION 
  Prints information about the current user.
.PARAMETER Alias
  If this switch is provided, the function will return the hostname as an alias.
.PARAMETER FQDN
  If this switch is provided, the function will return the fully qualified domain name (FQDN).
.PARAMETER IPAddress
  If this switch is provided, the function will return the IP address of the host.
.EXAMPLE
  Get-HostNameInfo -Alias
.EXAMPLE
  Get-HostNameInfo -FQD
.OUTPUTS
  A custom object with the following properties: Alias, FQDN, IPAddress.
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-HostNameInfo {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [Alias("a")]
    [switch]$Alias,

    [Parameter(Mandatory = $false)]
    [Alias("f")]
    [switch]$FQDN,

    [Parameter(Mandatory = $false)]
    [Alias("i")]
    [switch]$IPAddress
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($Alias) {
      $output = [PSCustomObject]@{
        Alias = [System.Net.Dns]::GetHostName()
      }
    }
    elseif ($FQDN) {
      $output = [PSCustomObject]@{
        FQDN = "$username@$([System.Net.Dns]::GetHostName())"
      }
    }
    elseif ($IPAddress) {
      $output = [PSCustomObject]@{
        IPAddress = ([System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) | Where-Object { $_.AddressFamily -eq 'InterNetwork' })[0].IPAddressToString
      }
    }
    else {
      $output = [PSCustomObject]@{
        'Hostname' = [System.Net.Dns]::GetHostName()
      }
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    return $output
  }
}

<#
.SYNOPSIS
  Times the execution of a script block.
.DESCRIPTION
  The Measure-ExecutionTime function times the execution of a script block. It can be customized with the -Verbose switch to print the execution time.
.PARAMETER ScriptBlock
  The script block containing the commands to be measured.
.EXAMPLE
  Capture-Commands { cd 'C:\'; New-Item -ItemType file -Name "bashscript.sh"; }
.OUTPUTS
  A custom object with the following property: ExecutionTime.
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Measure-ExecutionTime {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [scriptblock]$ScriptBlock
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $result = Measure-Command -Expression $ScriptBlock
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $output = [PSCustomObject]@{
      'Execution Time (ms)' = $result.TotalMilliseconds
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    return $output
  }
}

<#
.SYNOPSIS
  Prints the active session jobs.
.DESCRIPTION
  The Get-Jobs function prints the active session jobs. 
.PARAMETER List
  If this switch is provided, the function will print all the properties of the jobs.
.PARAMETER Status
  If this switch is provided, the function will only print those whose statuses have changed since the last notification.
.PARAMETER ProcessId
  If this switch is provided, the function will print the process IDs of the jobs.
.EXAMPLE
  Get-Jobs -List
.EXAMPLE
  Get-Jobs -Status
.EXAMPLE
  Get-Jobs -ProcessId
.OUTPUTS
  A list of jobs.
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-Jobs {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [Alias("l")]
    [switch]$List,

    [Parameter(Mandatory = $false)]
    [Alias("n")]
    [switch]$Status,

    [Parameter(Mandatory = $false)]
    [Alias("p")]
    [switch]$ProcessId
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($ProcessId) {
      Get-Job | ForEach-Object { $_.Id }
    }
    elseif ($List) {
      Get-Job | Format-List -Property *
    }
    elseif ($Status) {
      Get-Job | Where-Object { $_.HasMoreData -eq $true }
    }
    else {
      Get-Job
    }
  }
}

<#
.SYNOPSIS
  Kills a process
.DESCRIPTION
  This function kills a process    
.PARAMETER ProcessId
  The ID of the process, can be retrieved with Get-Process
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Kill-Process {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string]$ProcessId
  )
  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Stop-Process -Id $ProcessId
  }
}

<#
.SYNOPSIS
  Allows you to gather DNS information about a domain
.DESCRIPTION
  This function allows you to gather DNS information about a domain
.PARAMETER Domain
  The domain to gather information about
.PARAMETER Type
  The type of DNS record to gather information about
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Find-DNSRecord {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string]$Domain,

    [Parameter(Mandatory = $true)]
    [string]$Type
  )
  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Resolve-DnsName -Name $Domain -Type $Type
  }
}

<#
.SYNOPSIS
  Allows you to manipulate the shell history
.DESCRIPTION
  This function allows you to manipulate the shell history
.PARAMETER Clear
  Clears the shell history
.PARAMETER Save
  Saves the shell history to a file
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Shell-History {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [Alias("c")]
    [switch]$Clear,

    [Parameter(Mandatory = $false)]
    [Alias("s")]
    [string]$Save
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($Clear) {
      Clear-History
    }

    if ($Save) {
      Get-History | Out-File $Save
    }

    Get-History
  }
}

<#
.SYNOPSIS
  Finds a process
.DESCRIPTION
  This function finds a process
.PARAMETER Name 
  The name of the process
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Find-Process {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)][string]$Name
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Get-Process | Where-Object { $_.Name -like "*$Name*" } | Format-Table `
    @{Label = "NPM(K)"; Expression = { [int]($_.NPM / 1024) } },
    @{Label = "PM(K)"; Expression = { [int]($_.PM / 1024) } },
    @{Label = "WS(K)"; Expression = { [int]($_.WS / 1024) } },
    @{Label = "VM(M)"; Expression = { [int]($_.VM / 1MB) } },
    @{Label = "CPU(s)"; Expression = { if ($_.CPU) { $_.CPU.ToString("N") } } },
    Id, ProcessName, StartTime, mainWindowTitle
  }
}

<#
.SYNOPSIS
  Retrieves the currently installed updates
.DESCRIPTION
  This function retrieves the currently installed updates
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-Updates {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $updates = Get-CimInstance -ClassName Win32_QuickFixEngineering
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $updates | Format-Table `
    @{Label = "InstalledOn"; Expression = { if ($_.InstalledOn) { $_.InstalledOn.ToString("yyyy-MM-dd") } } },
    Description, HotFixID, InstalledBy
  }
}

<#
.SYNOPSIS
  Generates a system report
.DESCRIPTION
  This function generates a system report
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-SystemReport {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/GSR/main/GenerateSystemReport.ps1" | Invoke-Expression
  }
}

<#
.SYNOPSIS
  Activates Windows using MAS
.DESCRIPTION 
  This function activates Windows using MAS
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Activate-Windows {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Invoke-RestMethod https://massgrave.dev/get | Invoke-Expression
  }
}

<#
.SYNOPSIS
  Download object(s)
.DESCRIPTION 
  This function downloads object(s) to the specified path or the current directory
.PARAMETER Url 
  The URL of the object
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Invoke-DownloadObject {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)][string[]]$Url,
    [Parameter(Mandatory = $false)][string[]]$ObjectName,
    [Parameter(Mandatory = $false)][string]$ObjectPath,
    [Parameter(Mandatory = $false)][switch]$Overwrite,
    [Parameter(Mandatory = $false)][switch]$Silent
  )
  
  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $downloadDirectory = if ($ObjectPath) { $ObjectPath } else { Get-Location }
    $downloadedObjects = @()
    $jobs = @()
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    } 
    for ($i = 0; $i -lt $Url.Length; $i++) {
      $actualObjectName = if ($ObjectName.Length -gt $i) { $ObjectName[$i] } else { [System.IO.Path]::GetFileName($Url[$i]) }
      $destinationPath = Join-Path $downloadDirectory $actualObjectName
      if ($Overwrite -and (Test-Path $destinationPath)) {
        if (-not $Silent) {
          Write-Host "Removing $destinationPath"
        }
        Remove-Item $destinationPath -Force
      }

      $scriptBlock = {
        PARAM ($url, $destinationPath, $overwrite, $silent)
        $curlCommand = "curl -o `"$destinationPath`" -L `"$url`" -s"
        if ($overwrite) {
          $curlCommand += " -O"
        }
        Invoke-Expression $curlCommand 2>&1 
      }

      $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList $Url[$i], $destinationPath, $Overwrite, $Silent
      $jobs += $job

      $downloadedObjects += $destinationPath
    }
    $jobs | Wait-Job

    $jobs | ForEach-Object {
      Receive-Job -Job $_
      Remove-Job -Job $_
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if (-not $Silent) {
      Invoke-Item -Path $downloadDirectory  
    }
    return $downloadedObjects
  }
}

<#
.SYNOPSIS
  Allows for pipeline execution
.DESCRIPTION 
  This function allows for pipeline execution
.PARAMETER Objects 
  The object paths
.EXAMPLE 
  Invoke-DownloadObject -Url "http://example.com/file1.zip", "http://example.com/file2.zip" | Invoke-Object
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Invoke-Object {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(ValueFromPipeline = $true)]
    [string[]]$Objects
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    foreach ($object in $Objects) {
      if (Test-Path $object) {
        Start-Process $object
      }
    }
  }
}

<#
.SYNOPSIS
  Gets the status of all services
.DESCRIPTION 
  This function gets the status of all services
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-Services {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Get-Service | ForEach-Object {
      $status = $_.Status
      $name = $_.Name
      $displayName = $_.DisplayName
      Write-Host ("{0} ({1}): {2}" -f $displayName, $name, $status)
    }
  }
}

<#
.SYNOPSIS
  Hacks a target
.DESCRIPTION
  This function hacks a target
.PARAMETER Target 
  The target
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Invoke-TargetHack {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)][string]$Target
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $progress = 0
    $progressMax = 100
    $progressStep = 10
    $progressBar = [char]0x2588
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
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
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-Host "Hacking complete!"
    Write-Host "Target: $Target"
    Write-Host "Status: $($job.State)"
  }
}

<#
.SYNOPSIS
  Gets a programming joke
.DESCRIPTION 
  This function gets a programming joke
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-ProgrammingJoke {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $response = Invoke-RestMethod -Uri 'https://official-joke-api.appspot.com/jokes/programming/random'
    $joke = $response[0]
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-Host ("{0} {1}" -f $joke.setup, $joke.punchline) 
  }
}

<#
.SYNOPSIS
  Allows you to emulate the Matrix rain effect
.DESCRIPTION 
  This function allows you to emulate the Matrix rain effect
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Start-MatrixRain {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $width = $host.UI.RawUI.BufferSize.Width
    $height = $host.UI.RawUI.BufferSize.Height
    $streams = 1..($width * 200) | ForEach-Object { @{ Position = Get-Random -Minimum 0 -Maximum $height; Speed = Get-Random -Minimum 1 -Maximum 2 } }
    $host.UI.RawUI.CursorSize = 0
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
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

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Clear-Host
  }
}

<#
.SYNOPSIS
  Searches DuckDuckGo
.DESCRIPTION 
  This function searches DuckDuckGo
.PARAMETER Query 
  The query to search for
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Search-DuckDuckGo {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [string]$Query
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $encodedQuery = [System.Web.HttpUtility]::UrlEncode($Query)
    $url = "https://duckduckgo.com/?q=$encodedQuery&t=h_&ia=web"
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Start-Process $url
  }
}

<#
.SYNOPSIS
  Scans an IP address
.DESCRIPTION
  This function scans an IP address
.PARAMETER IP 
  The IP address
.PARAMETER Extended
  Whether to show extended information
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Test-IP {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)][string]$IP,
    [Parameter(Mandatory = $false)][switch]$Extended
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $info = Invoke-RestMethod -Uri "http://ip-api.com/json/$($IP)"
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-Host "IP: $($IP)"
    Write-Host "Country: $($info.country)"
    Write-Host "Region: $($info.regionName)"
    Write-Host "City: $($info.city)"
    Write-Host "ISP: $($info.isp)"
  }
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
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Test-Ports {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)][string]$IP,
    [Parameter(Mandatory = $true)][int]$StartPort,
    [Parameter(Mandatory = $true)][int]$EndPort
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
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
}

<#
.SYNOPSIS
  Allows you to manage your hosts file
.DESCRIPTION 
  This function allows you to manage your hosts file
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Edit-Hosts {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/HostEntryManager.ps1" | Invoke-Expression
  }
}

<#
.SYNOPSIS
  Allows you to manage your DNS settings
.DESCRIPTION 
  This function allows you to manage your DNS settings
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Set-DNS {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/DNSChanger.ps1" | Invoke-Expression
  }
}

<#
.SYNOPSIS
  Allows you to manage your network adapters
.DESCRIPTION 
  This function allows you to manage your network adapters
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Set-NetworkAdapter {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters
  
  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/NetworkAdapterManager.ps1" | Invoke-Expression
  }
}

<# 
.SYNOPSIS
  Disables Nagles algorithm
.DESCRIPTION 
  This function disables Nagles algorithm
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Set-Nagles {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters
  
  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/NaglesAlgorithm.ps1" | Invoke-Expression
  }
}

<#
.SYNOPSIS
  Empties the recycle bin
.DESCRIPTION
  This function empties the recycle bin
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Empty-RecycleBin {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Clear-RecycleBin -Force
  }
}

<#  
.SYNOPSIS
  Copies the current path to the clipboard
.DESCRIPTION
  This function copies the current path to the clipboard
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Copy-Path {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $path = (Get-Location).Path
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Set-Clipboard $path
  }
}

<#
.SYNOPSIS
  Backs up the current workspace to a specified directory
.DESCRIPTION
  This function backs up the current workspace to a specified directory
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Take-Snapshot {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $BackupDirectory = "$SystemDrive\Snapshots"
    $currentDirectory = Get-Location
    $backupPath = Join-Path -Path $BackupDirectory -ChildPath (Get-Date -Format "yyyy-MM-dd_HH-mm-ss") + "_" + (Split-Path -Leaf $currentDirectory.Provider)
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if (!(Test-Path -Path $backupPath)) {
      New-Item -ItemType Directory -Path $backupPath 
    }
  
    Copy-Item -Path "$currentDirectory\*" -Destination $backupPath -Recurse -Force
  }
}

<#
.SYNOPSIS
  Tips & tricks for using this profile
.DESCRIPTION 
  This function displays tips & tricks for using this profile
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-ShellTips {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $PanelWidth = 1000

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "$($ShellType) Profile Tips"
    $form.BackColor = $PrimaryBackgroundColor
    $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.Icon = $ShellIcon
  
    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 1
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
  
    $guideText = Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/tips.md"
  
    $richTextBox = New-Object System.Windows.Forms.RichTextBox
    $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, 500)
    $richTextBox.Text = $guideText
    $richTextBox.BackColor = $PrimaryBackgroundColor
    $richTextBox.ForeColor = $PrimaryForegroundColor
    $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
    $richTextBox.ReadOnly = $true
    $richTextBox.BorderStyle = 'None'
    $richTextBox.ScrollBars = 'Vertical'

    $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)

    $form.Controls.Add($tableLayoutPanel)
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.ShowDialog()
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.Dispose()
  }
}

<#
.SYNOPSIS
  Allows you to configure your theme
.DESCRIPTION 
  This function allows you to configure your theme
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Set-ShellTheme {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $ompConfig = "$UserProfile\.config\omp.json"
    $starshipConfig = "$UserProfile\.config\starship.toml"
    $starShip = Get-ItemProperty -Path $KeyPath -Name 'Starship' -ErrorAction SilentlyContinue
  
    $PanelWidth = 400
    $PanelHeight = 200

    if ($starShip.Starship -eq 1) {
      $form = New-Object System.Windows.Forms.Form
      $form.Text = "Starship Theme Configuration"
      $form.BackColor = $PrimaryBackgroundColor
      $form.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
      $form.StartPosition = 'CenterScreen'
      $form.FormBorderStyle = 'FixedDialog'
      $form.Icon = $ShellIcon
      $form.MinimizeBox = $false
      $form.MaximizeBox = $false
  
      $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
      $tableLayoutPanel.RowCount = 2
      $tableLayoutPanel.ColumnCount = 1
      $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
      $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
      $tableLayoutPanel.RowStyles.Clear()
      $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
      $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
  
      $richTextBox = New-Object System.Windows.Forms.RichTextBox
      $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
      $richTextBox.Text = "Enter the URL of the theme you want to use. E.g. https://starship.rs/presets/toml/tokyo-night.toml"
      $richTextBox.BackColor = $PrimaryBackgroundColor
      $richTextBox.ForeColor = $PrimaryForegroundColor
      $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
      $richTextBox.BorderStyle = 'None'
      $richTextBox.ScrollBars = 'Vertical'
  
      $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)
  
      $saveButton = New-Object System.Windows.Forms.Button
      $saveButton.Size = New-Object System.Drawing.Size($PanelWidth, 30)
      $saveButton.Dock = [System.Windows.Forms.DockStyle]::Fill
      $saveButton.Text = "Save"
      $saveButton.BackColor = $SecondaryBackgroundColor
      $saveButton.ForeColor = $SecondaryForegroundColor
      $saveButton.FlatStyle = 'Flat'
      $saveButton.FlatAppearance.BorderSize = 1
      $saveButton.FlatAppearance.BorderColor = $AccentColor
      $saveButton.Add_Click({
          $url = $richTextBox.Text
          $urlContent = Invoke-RestMethod $url
          $urlContent | Out-File $starshipConfig
  
          [System.Windows.Forms.MessageBox]::Show("Starship theme successfully changed.", "Success")
        })
  
      $tableLayoutPanel.Controls.Add($saveButton, 0, 1)
      
      $form.Controls.Add($tableLayoutPanel)
    }
    else {
      $form = New-Object System.Windows.Forms.Form
      $form.Text = "Oh-my-posh Theme Configuration"
      $form.BackColor = $PrimaryBackgroundColor
      $form.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
      $form.StartPosition = 'CenterScreen'
      $form.FormBorderStyle = 'FixedDialog'
      $form.Icon = $ShellIcon
      $form.MinimizeBox = $false
      $form.MaximizeBox = $false
  
      $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
      $tableLayoutPanel.RowCount = 2
      $tableLayoutPanel.ColumnCount = 1
      $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
      $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
      $tableLayoutPanel.RowStyles.Clear()
      $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
      $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
  
      $richTextBox = New-Object System.Windows.Forms.RichTextBox
      $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
      $richTextBox.Text = "Enter the URL of the theme you want to use. E.g. https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/1_shell.omp.json"
      $richTextBox.BackColor = $PrimaryBackgroundColor
      $richTextBox.ForeColor = $PrimaryForegroundColor
      $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
      $richTextBox.BorderStyle = 'None'
      $richTextBox.ScrollBars = 'Vertical'
  
      $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)
  
      $saveButton = New-Object System.Windows.Forms.Button
      $saveButton.Size = New-Object System.Drawing.Size($PanelWidth, 30)
      $saveButton.Dock = [System.Windows.Forms.DockStyle]::Fill
      $saveButton.Text = "Save"
      $saveButton.BackColor = $SecondaryBackgroundColor
      $saveButton.ForeColor = $SecondaryForegroundColor
      $saveButton.FlatStyle = 'Flat'
      $saveButton.FlatAppearance.BorderSize = 1
      $saveButton.FlatAppearance.BorderColor = $AccentColor
      $saveButton.Add_Click({
          $url = $richTextBox.Text
          $urlContent = Invoke-WebRequest $url
          $urlContent.Content | Out-File $ompConfig
  
          [System.Windows.Forms.MessageBox]::Show("Oh-my-posh theme successfully changed.", "Success")
        })
      
      $tableLayoutPanel.Controls.Add($saveButton, 0, 1)

      $form.Controls.Add($tableLayoutPanel)
    }
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.ShowDialog()
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.Dispose()
  }
}

<#
.SYNOPSIS
  Allows you to get the manual for a command
.DESCRIPTION
  This function allows you to get the manual for a command
.PARAMETER Name
  The name of the command
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Find-Manual {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [Parameter(Mandatory = $false)]
    [switch]$GUI
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    # Assuming that aliases are in lowercase
    if ($Name -cmatch "[A-Z]") {
      $Name = Get-ReverseAlias $Name
    }

    $ManualText = Get-Help -Name $Name -Full | Out-String

    if ($GUI) {
      $PanelWidth = 750
      $PanelHeight = 500
  
      $form = New-Object System.Windows.Forms.Form
      $form.Text = "Manual for $Name"
      $form.BackColor = $PrimaryBackgroundColor
      $form.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
      $form.StartPosition = 'CenterScreen'
      $form.FormBorderStyle = 'FixedDialog'
      $form.Icon = $ShellIcon
      
      $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
      $tableLayoutPanel.RowCount = 1
      $tableLayoutPanel.ColumnCount = 1
      $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
      $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
      $tableLayoutPanel.RowStyles.Clear()
      $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
      $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
      $tableLayoutPanel.BackColor = $PrimaryBackgroundColor
      $tableLayoutPanel.ForeColor = $PrimaryForegroundColor

      $richTextBox = New-Object System.Windows.Forms.RichTextBox
      $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
      $richTextBox.Text = $ManualText
      $richTextBox.BackColor = $PrimaryBackgroundColor
      $richTextBox.ForeColor = $PrimaryForegroundColor
      $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
      $richTextBox.ReadOnly = $true
      $richTextBox.BorderStyle = 'None'
      $richTextBox.ScrollBars = 'Vertical'

      $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)

      $form.Controls.Add($tableLayoutPanel)
    }
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($GUI) {
      $form.ShowDialog()
    }
    else {
      $ManualText
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($GUI) {
      $form.Dispose()
    }
  }
}

<#
.SYNOPSIS
  Allows you to get the manual for a command
.DESCRIPTION
  This function allows you to get the command information for a command
.PARAMETER Name
  The name of the command
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Find-Command {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$Name
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $Command = Get-Command -Name $Name -ErrorAction SilentlyContinue

    if ($Command) {
      Write-Host "Command: $($Command.Name)"
      Write-Host "Module: $($Command.ModuleName)"
      Write-Host "Path: $($Command.Path)"
    }
    else {
      Write-Error "Command not found"
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $Command
  }
}

<#
.SYNOPSIS
  Loads aliases
.DESCRIPTION 
  This function loads aliases
.PARAMETER Force 
  Forces the loading of aliases
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Import-Aliases {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)][switch]$Force
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $newAliasFilePath = Join-Path (Split-Path -Parent $PROFILE) "new-aliases.json"
    $oldAliasFilePath = Join-Path (Split-Path -Parent $PROFILE) "old-aliases.json"  
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    # Force loading of aliases
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

      # Remove old aliases
      if (Test-Path $oldAliasFilePath) {
        $oldAliases = Get-Content $oldAliasFilePath | ConvertFrom-Json
  
        foreach ($alias in $oldAliases) {
          if (Get-Alias -Name $alias -ErrorAction SilentlyContinue) {
            if ($ShellType -eq "Pwsh") {
              Remove-Alias $alias -Force -Scope Global 
            }
            else {
              Remove-Item alias:$alias -Force
            }
          }
        }
      }
  
      # Set new aliases
      if (Test-Path $newAliasFilePath) {
        $newAliases = Get-Content $newAliasFilePath | ConvertFrom-Json
  
        foreach ($alias in $newAliases.PSObject.Properties) {
          Set-Alias -Name $alias.Name -Value $alias.Value -Scope Global -Option AllScope -Force
        }  
      }
    }
  }
}

<#
.SYNOPSIS
  Adds aliases through a GUI
.DESCRIPTION 
  This function allows you to add aliases through a GUI
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Add-Aliases {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters
  
  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    
    $AliasConfigFile = "new-aliases.json"
    $aliasConfigFilePath = Join-Path (Split-Path -Parent $PROFILE) $AliasConfigFile

    if (-not (Test-Path $aliasConfigFilePath)) {
      $aliasConfigFileUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/$AliasConfigFile"
      Invoke-WebRequest -Uri $aliasConfigFileUrl -OutFile $aliasConfigFilePath
    }

    $aliasConfig = Get-Content $aliasConfigFilePath | ConvertFrom-Json

    
    $dataTable = New-Object System.Data.DataTable

    $dataTable.Columns.Add("Name", [string])
    $dataTable.Columns.Add("Value", [string])

    $aliasConfig.PSObject.Properties | ForEach-Object {
      $row = $dataTable.NewRow()
      $row["Name"] = $_.Name
      $row["Value"] = $_.Value
      $dataTable.Rows.Add($row)
    }

    $PanelWidth = 400
    $PanelHeight = 300

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Alias Configuration"
    $form.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = $PrimaryBackgroundColor
    $form.ForeColor = $PrimaryForegroundColor
    $form.FormBorderStyle = "FixedDialog"
    $form.Icon = $ShellIcon

    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 2
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
    $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $tableLayoutPanel.BackColor = $PrimaryBackgroundColor
    $tableLayoutPanel.ForeColor = $PrimaryForegroundColor

    $dataGridView = New-Object System.Windows.Forms.DataGridView
    $dataGridView.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $dataGridView.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
    $dataGridView.AutoGenerateColumns = $true
    $dataGridView.RowHeadersVisible = $false
    $dataGridView.BackgroundColor = $PrimaryBackgroundColor
    $dataGridView.ForeColor = $PrimaryForegroundColor
    $dataGridView.GridColor = $PrimaryBackgroundColor
    $dataGridView.DefaultCellStyle.BackColor = $PrimaryBackgroundColor
    $dataGridView.DefaultCellStyle.ForeColor = $PrimaryForegroundColor
    $dataGridView.ColumnHeadersDefaultCellStyle.BackColor = $SecondaryBackgroundColor
    $dataGridView.ColumnHeadersDefaultCellStyle.ForeColor = $PrimaryForegroundColor
    $dataGridView.RowHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
    $dataGridView.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
    $dataGridView.DefaultCellStyle.SelectionBackColor = $SecondaryBackgroundColor
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

    $dataGridView.DataSource = $dataTable

    $tableLayoutPanel.Controls.Add($dataGridView, 0, 0)

    $button = New-Object System.Windows.Forms.Button
    $button.Size = New-Object System.Drawing.Size($PanelWidth, 30)
    $button.Text = "Save Configuration"
    $button.Dock = [System.Windows.Forms.DockStyle]::Fill
    $button.BackColor = $SecondaryBackgroundColor
    $button.ForeColor = $SecondaryForegroundColor
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderColor = $AccentColor
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
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.ShowDialog()
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.Dispose()
  }
}

<#
.SYNOPSIS
  Removes aliases through a GUI
.DESCRIPTION  
  This function allows you to remove aliases through a GUI
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Remove-Aliases {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
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

    $PanelWidth = 400
    $PanelHeight = 300
  
    $form = New-Object System.Windows.Forms.Form
    $form.Width = $PanelWidth
    $form.Height = $PanelHeight
    $form.Text = "Alias Configuration"
    $form.StartPosition = "CenterScreen"
    $form.BackColor = $PrimaryBackgroundColor
    $form.ForeColor = $PrimaryForegroundColor
    $form.FormBorderStyle = "FixedDialog"
    $form.Icon = $ShellIcon
    
    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.Width = $PanelWidth
    $tableLayoutPanel.RowCount = 2
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
    $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  
    $dataGridView = New-Object System.Windows.Forms.DataGridView
    $dataGridView.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $dataGridView.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
    $dataGridView.Dock = [System.Windows.Forms.DockStyle]::Fill
    $dataGridView.AutoGenerateColumns = $true
    $dataGridView.RowHeadersVisible = $false
    $dataGridView.BackgroundColor = $PrimaryBackgroundColor
    $dataGridView.ForeColor = $PrimaryForegroundColor
    $dataGridView.GridColor = $PrimaryBackgroundColor
    $dataGridView.DefaultCellStyle.BackColor = $PrimaryBackgroundColor
    $dataGridView.DefaultCellStyle.ForeColor = $PrimaryForegroundColor
    $dataGridView.ColumnHeadersDefaultCellStyle.BackColor = $SecondaryBackgroundColor
    $dataGridView.ColumnHeadersDefaultCellStyle.ForeColor = $PrimaryForegroundColor
    $dataGridView.RowHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
    $dataGridView.ColumnHeadersBorderStyle = [System.Windows.Forms.DataGridViewHeaderBorderStyle]::None
    $dataGridView.DefaultCellStyle.SelectionBackColor = $SecondaryBackgroundColor
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
    $button.Size = New-Object System.Drawing.Size($PanelWidth, 30)
    $button.Text = "Save Configuration"
    $button.BackColor = $SecondaryBackgroundColor
    $button.ForeColor = $SecondaryForegroundColor
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderColor = $AccentColor
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
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.ShowDialog()
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.Dispose()
  }
}

function Get-ReverseAlias {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)][string]$Command
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $aliases = Get-Alias | Where-Object { $_.Definition -eq $Command }
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($aliases) {
      $aliases.Name
    }
  }
}

<#
.SYNOPSIS
  Displays the help menu
.DESCRIPTION 
  This function displays the help menu
.PARAMETER ShowInGUI
  Displays the help menu in the GUI
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-ProfileHelp {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [Alias('g')]
    [switch]$ShowInGUI = $false
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $excludedNames = 'A:', 'B:', 'C:', 'D:', 'E:', 'F:', 'G:', 'H:', 'I:', 'J:', 'K:', 'L:', 'M:', 'N:', 'O:', 'P:', 'Q:', 'R:', 'S:', 'T:', 'U:', 'V:', 'W:', 'X:', 'Y:', 'Z:'
    $commands = Get-Command -CommandType Function | Where-Object { $_.Source -eq "" -and $_.Name -notin $excludedNames } | ForEach-Object {
      $help = Get-Help $_.Name -ErrorAction SilentlyContinue
      $alias = (Get-ReverseAlias -Command $_.Name -ErrorAction SilentlyContinue | Out-String) -replace "`r`n", ', ' -replace ', $', ''
      $description = ($help.Synopsis).Trim()
      $parameters = (($help.Parameters.Parameter | ForEach-Object { $_.Name }) -join ', ').Trim()
  
      if ($description -and $alias) {
        [PSCustomObject] @{
          Name        = "$($_.Name) ($alias)"
          Description = $description
          Parameters  = $parameters
        }
      }
    } | Sort-Object -Property Name
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if (-not $ShowInGUI) {
      $commandString = "For more information about a command, type 'Get-Help <command-name>'`n" + ($commands | Out-String)
      $commandString
    }
    else {
      $commandsOutput = $commands | Format-Table -Wrap -AutoSize | Out-String
      Show-Help -Output $commandsOutput -Introduction "For more information about a command, type 'Get-Help <command-name>'"
    }
  }
}

function Show-Help {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true)][string]$Output,
    [Parameter(Mandatory = $true)][string]$Introduction
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $PanelWidth = 1000

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "$($ShellType) Profile Help"
    $form.BackColor = $PrimaryBackgroundColor
    $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.Icon = $ShellIcon
    
    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 1
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))

    $richTextBox = New-Object System.Windows.Forms.RichTextBox
    $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, 500)
    $richTextBox.Text = $Introduction + "`n" + $Output
    $richTextBox.BackColor = $PrimaryBackgroundColor
    $richTextBox.ForeColor = $PrimaryForegroundColor
    $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
    $richTextBox.ReadOnly = $true
    $richTextBox.BorderStyle = 'None'
    $richTextBox.ScrollBars = 'Vertical'

    $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)
    
    $form.Controls.Add($tableLayoutPanel)
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.ShowDialog()
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $form.Dispose()
  }
}

<#
.SYNOPSIS
  Simple calendar
.DESCRIPTION
  This function displays a simple calendar
.PARAMETER Month
  The month
.PARAMETER Year
  The year
.EXAMPLE
  Calendar 12 2020
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Calendar {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Position = 0)]
    [int]$Month = (Get-Date).Month,
    [Parameter(Position = 1)]
    [int]$Year = (Get-Date).Year
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $daysInMonth = [DateTime]::DaysInMonth($Year, $Month)
    $date = New-Object DateTime $Year, $Month, 1
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-Host ("    {0} {1}" -f $date.ToString('MMMM'), $Year)
    Write-Host "Su Mo Tu We Th Fr Sa"

    if ($date.Month -eq (Get-Date).Month -and $date.Year -eq (Get-Date).Year) {
      $today = (Get-Date).Day
    }
    else {
      $today = 0
    }

    1..$date.DayOfWeek.value__ | ForEach-Object { Write-Host "   " -NoNewline }
    1..$daysInMonth | ForEach-Object {
      $day = $_
      $date = New-Object DateTime $Year, $Month, $day
      if ($day -lt 10) { 
        if ($day -eq $today) {
          Write-Host " $day" -NoNewline -ForegroundColor Red 
        }
        else {
          Write-Host " $day" -NoNewline
        } 
      }
      else {
        if ($day -eq $today) {
          Write-Host "$day" -NoNewline -ForegroundColor Red 
        } 
        else {
          Write-Host "$day" -NoNewline
        }
      }
      if ($date.DayOfWeek.value__ -eq 6) { Write-Host "" }
      else { Write-Host " " -NoNewline }
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-Host ""
  }
}

<#
.SYNOPSIS
  Gets the current shell information
.DESCRIPTION
  This function gets the current shell information
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-ShellInfo {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $name = $host.Name
    $version = $host.Version
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Write-Host "Profile Path: $PROFILE"
    Write-Host "Host Name: $($name)"
    Write-Host "Host Version: $($version) -> $($ShellType) ($Bitness)"
  }
}

<#
.SYNOPSIS
  Searches for a text pattern, please use RipGrep instead
.DESCRIPTION
  This function searches for a text pattern, similar to the Unix grep command
.PARAMETER Pattern
  The pattern to search for
.PARAMETER Content
  The content to search
.EXAMPLE
  Pattern-Match "Hello" "Hello World"
.EXAMPLE
  "Hello World" | Pattern-Match "Hello"
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Pattern-Match {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Pattern,

    [Parameter(ValueFromPipeline = $true)]
    [string]$Content
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $Content | Select-String -Pattern $Pattern
  }
}

<#
.SYNOPSIS
  Replaces a text pattern, similar to the Unix sed command
.DESCRIPTION
  This function replaces a text pattern, similar to the Unix sed command
.PARAMETER Pattern
  The pattern to search for
.PARAMETER Replacement
  The replacement text
.PARAMETER Object
  The object to search
.EXAMPLE
  "Hello World" | Pattern-Replace "Hello" "Hi"
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Pattern-Replace {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Pattern,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Replacement,

    [Parameter(ValueFromPipeline = $true)]
    [string]$Object
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $Object | ForEach-Object {
      $content = Get-Content $_ -ErrorAction SilentlyContinue
      if (-not $content) {
        $_ | ForEach-Object {
          $replacedContent = $_ -replace $Pattern, $Replacement
          Write-Host $replacedContent
        }
      }
      else {
        $content | ForEach-Object {
          $replacedContent = $_ -replace $Pattern, $Replacement
          Write-Host $replacedContent
        }
      }
    }
  }
}

<#
.SYNOPSIS
  Analyzes a script
.DESCRIPTION
  This function analyzes a script
.PARAMETER Content
  The content to analyze
.EXAMPLE
  Analyze-Script "Write-Host 'Hello World'"
.LINK 
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Analyze-Script {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Content
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Invoke-ScriptAnalyzer -ScriptDefinition $Content
  }
}

<#
.SYNOPSIS
  Analyzes the profile
.DESCRIPTION
  This function analyzes the profile
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Analyze-Profile {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false)]
    [switch]$GUI = $false
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $profileContent = Get-Content $PROFILE
    $profileContentString = $profileContent | Out-String

    $PanelWidth = 1000
    $PanelHeight = 500

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Profile Analysis"
    $form.BackColor = $PrimaryBackgroundColor
    $form.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.Icon = $ShellIcon
    
    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 1
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
  
    $richTextBox = New-Object System.Windows.Forms.RichTextBox
    $richTextBox.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $richTextBox.BackColor = $PrimaryBackgroundColor
    $richTextBox.ForeColor = $PrimaryForegroundColor
    $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
    $richTextBox.ReadOnly = $true
    $richTextBox.BorderStyle = 'None'
    $richTextBox.ScrollBars = 'Vertical'

    $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)

    $form.Controls.Add($tableLayoutPanel)
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($GUI) {
      $analysis = Analyze-Script -Content $profileContentString
      $richTextBox.Text = $analysis | Out-String
      $form.ShowDialog()
    }
    else {
      $analysis = Analyze-Script -Content $profileContentString
      $analysis | Out-String
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($GUI) {
      $form.Dispose() 
    }
  }
}

<#
.SYNOPSIS
  Displays the color palette in the console
.DESCRIPTION
  This function displays the color palette in the console
.EXAMPLE
  Color-Palette
.OUTPUTS
  The color palette, displayed in the console
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Get-ColorPalette {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( ) # No parameters

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $colors = [System.Enum]::GetValues([System.ConsoleColor])
    $colors = $colors | Sort-Object
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    for ($i = 0; $i -lt $colors.Length; $i += 8) {
      for ($j = 0; $j -lt 1; $j++) {
        for ($k = 0; $k -lt 8; $k++) {
          if ($i + $k -lt $colors.Length) {
            $color = $colors[$i + $k]
            Write-Color -Color $color -SpaceCount 3 -LineCount 1 -NewLine $false
          }
        }
        Write-Host " "
      }
    }
  }
}

<#
.SYNOPSIS
  Simplified version of ConvertTo-Json, with minified parameters
.DESCRIPTION
  This function is a simplified version of ConvertTo-Json, with minified parameters. Can be used in a pipeline and together with From-Json.
.PARAMETER Pipe
  The input object
.PARAMETER Depth
  The depth of the conversion
.EXAMPLE
  "Hello World" | To-Json
.EXAMPLE
  "Hello World" | To-Json -Depth 3
.OUTPUTS
  The converted object
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function To-Json {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [Alias("p")]
    [string]$Pipe,
      
    [Parameter(Mandatory = $false)]
    [Alias("d")]
    [int]$Depth = 2
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    return $Pipe | ConvertTo-Json -Depth $Depth
  }
}

<#
.SYNOPSIS
  Simplified version of ConvertFrom-Json, with minified parameters
.DESCRIPTION
  This function is a simplified version of ConvertFrom-Json, with minified parameters. Can be used in a pipeline and together with To-Json.
.PARAMETER Pipe
  The input object
.PARAMETER AsHashTable
  Converts the input object to a hash table
.EXAMPLE
  '{"Name": "Azrael"}' | From-Json
.EXAMPLE
  '{"Name": "Azrael"}' | From-Json -AsHashTable
.OUTPUTS
  The converted object
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function From-Json {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [Alias("p")]
    [string]$Pipe,

    [Parameter(Mandatory = $false)]
    [Alias("a")]
    [switch]$AsHashTable = $false
  )

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    return $Pipe | ConvertFrom-Json -AsHashTable:$AsHashTable
  }
}

<#
.SYNOPSIS
  Unique select
.DESCRIPTION
  This function selects unique lines
.PARAMETER Pipe
  The input object
.EXAMPLE
  "Hello World" | Select-Unique
.OUTPUTS
  The unique lines
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Select-Unique {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM (
    [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
    [Alias("p")]
    [string]$Pipe
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $uniqueLines = @()
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($Pipe) {
      $uniqueLines += $Pipe
    }
  }

  END {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    $uniqueLines | Select-Object -Unique
  }
}

<#
.SYNOPSIS
  A simplified version of CSharpRepl, with minified parameters
.DESCRIPTION
  This function is a simplified version of CSharpRepl, with minified parameters
.PARAMETER Theme
  The theme to use
.PARAMETER Framework
  The framework to use
.PARAMETER Using
  The using statements
.PARAMETER Reference
  The reference statements
.PARAMETER AdditionalParameters
  Additional parameters
.PARAMETER Help
  Displays the help menu
.EXAMPLE
  Invoke-CSharp
.EXAMPLE
  Invoke-CSharp -Theme Nord -Framework Microsoft.NETCore.App -Using System -Reference System.dll
.OUTPUTS
  Either the C# REPL or the help menu
.LINK
  https://github.com/luke-beep/shell-config/wiki/Commands
#>
function Invoke-CSharp {
  [CmdletBinding(HelpUri = 'https://github.com/luke-beep/shell-config/wiki/Commands')]
  PARAM ( 
    [Parameter(Mandatory = $false)]
    [Alias("t")]
    [string]$Theme,

    [Parameter(Mandatory = $false)]
    [Alias("f")]
    [string]$Framework,

    [Parameter(Mandatory = $false)]
    [Alias("u")]
    [string[]]$Using,

    [Parameter(Mandatory = $false)]
    [Alias("r")]
    [string[]]$Reference,

    [Parameter(Mandatory = $false)]
    [Alias("c")]
    [string]$AdditionalParameters,

    [Parameter(Mandatory = $false)]
    [Alias("v")]
    [switch]$Help
  )

  BEGIN {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    if ($Help) {
      csharprepl --help
      break
    }
    else {
      $usingString = ""
      if ($Using) {
        $usingString = $Using | ForEach-Object { " -u $_" } | Out-String
      }
  
      $referenceString = ""
      if ($Reference) {
        $referenceString = $Reference | ForEach-Object { " -r $_" } | Out-String
      }
  
      $additionalParametersString = ""
      if ($AdditionalParameters) {
        $additionalParametersString = $AdditionalParameters | ForEach-Object { " $_" } | Out-String
      }
      if ($Theme) {
        $ThemeCommand = " -t $Theme"
      }
      else {
        $ThemeCommand = "--useTerminalPaletteTheme"
      }
      if ($Framework) {
        $FrameworkCommand = " -f $Framework"
      }
      else {
        $FrameworkCommand = " -f Microsoft.NETCore.App"
      }
    }
  }

  PROCESS {
    TRAP {
      Write-ErrorEvent $_.Exception.Message
      continue
    }
    Invoke-Expression "csharprepl $ThemeCommand $FrameworkCommand $usingString $referenceString $additionalParametersString"
  }
}

Import-Aliases # Import aliases

# ----------------------------------------
# End of Azrael's PowerShell/Pwsh Profile
# ----------------------------------------

Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
  Stop-Transcript
} -SupportEvent