# ----------------------------------------
# Start of Azrael's PowerShell/Pwsh Profile
# ----------------------------------------

# Author: LukeHjo (Azrael)
# Description: This is my PowerShell profile. It contains features that I use on a daily basis.
# Version: 1.1.9
# Date: 2023-12-28

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

# Variables
$iconUrl = "https://raw.githubusercontent.com/luke-beep/shell-config/main/assets/Azrael.ico"
$iconData = Invoke-WebRequest -Uri $iconUrl -UseBasicParsing
$iconStream = [System.IO.MemoryStream]::new($iconData.Content)
$icon = [System.Drawing.Icon]::new($iconStream)
$shellType = if ($host.Version.Major -ge 7) { "Pwsh" } else { "PowerShell" }
$bitness = if ([Environment]::Is64BitProcess) { "64-bit" } else { "32-bit" }
$keyPath = if ($shellType -eq "Pwsh") { 'HKCU:\Software\Azrael\Pwsh' } else { 'HKCU:\Software\Azrael\PowerShell' }
$userName = $env:UserName
$kernelVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Version
$versionKey = Get-ItemProperty -Path $keyPath -Name 'Version' -ErrorAction SilentlyContinue 
$currentVersion = if ($null -eq $versionKey) { $null } else { $versionKey.Version }
$latestVersion = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/version'
$SystemDrive = $env:SystemDrive

function Update-Profile {
  param (
    [Parameter(Mandatory = $false)][switch]$Silent,
    [Parameter(Mandatory = $false)][switch]$Force
  )

  # Check for registry key
  if (-not (Test-Path $keyPath)) {
    New-Item -Path $keyPath -Force | Out-Null
  }

  # Check for the first run key
  $firstRun = Get-ItemProperty -Path $keyPath -Name 'FirstRun' -ErrorAction SilentlyContinue
  # Run the first run script if it's the first run
  if ($null -eq $firstRun.FirstRun) {
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
    $form.Icon = $icon

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
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
    New-ItemProperty -Path $keyPath -Name 'Version' -Value $latestVersion -PropertyType 'String' -Force | Out-Null
    New-ItemProperty -Path $keyPath -Name 'FirstRun' -Value 1 -PropertyType 'DWord' -Force | Out-Null
    . $PROFILE
    if ($shellType -eq "Pwsh") {
      pwsh
    }
    else {
      powershell
    }
    Stop-Process -Id $PID
  }
  if ($Force) {
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
    $form.Icon = $icon

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
      # Resets the entire shell
      Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
      New-ItemProperty -Path $keyPath -Name 'Version' -Value $latestVersion -PropertyType 'String' -Force | Out-Null
      . $PROFILE
      if ($shellType -eq "Pwsh") {
        pwsh
      }
      else {
        powershell
      }
      Stop-Process -Id $PID    
    }
  }
  elseif ($currentVersion -ne $latestVersion) {
    # Check if the profile should be updated automatically
    $autoUpdate = Get-ItemProperty -Path $keyPath -Name 'AutoUpdate' -ErrorAction SilentlyContinue
    # Update the profile if it should be updated automatically
    if ($autoUpdate.AutoUpdate -eq 1 -or $Silent) {
      # Resets the entire shell
      Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
      New-ItemProperty -Path $keyPath -Name 'Version' -Value $latestVersion -PropertyType 'String' -Force | Out-Null
      . $PROFILE
      if ($shellType -eq "Pwsh") {
        pwsh
      }
      else {
        powershell
      }
      Stop-Process -Id $PID    
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
      $form.Icon = $icon

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

      # Update
      if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        # Resets the entire shell
        Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE
        New-ItemProperty -Path $keyPath -Name 'Version' -Value $latestVersion -PropertyType 'String' -Force | Out-Null
        . $PROFILE
        if ($shellType -eq "Pwsh") {
          pwsh
        }
        else {
          powershell
        }
        Stop-Process -Id $PID
      }
    }
  }
}

function Initialize-Profile {
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
  $nerdfontKey = Get-ItemProperty -Path $keyPath -Name 'NerdFontInstalled' -ErrorAction SilentlyContinue
  if ($null -eq $nerdfontKey) {
    New-ItemProperty -Path $keyPath -Name 'NerdFontInstalled' -Value 0 -PropertyType 'DWord' -Force | Out-Null
    oh-my-posh font install
  }

  $starship = Get-Command -Name starship -ErrorAction SilentlyContinue
  if (-not $starship) {
    scoop install starship
  }

  # Key that determines whether or not the starship prompt is enabled (Disabled by default)
  $starShip = Get-ItemProperty -Path $keyPath -Name 'Starship' -ErrorAction SilentlyContinue
  if ($null -eq $starShip) {
    New-ItemProperty -Path $keyPath -Name 'Starship' -Value 0 -PropertyType 'String' -Force | Out-Null
  }

  $ompConfig = "$env:USERPROFILE\.config\omp.json"
  if (-not (Test-Path $ompConfig)) {
    New-Item -Path $ompConfig -Force | Out-Null
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/omp/theme.json' -OutFile $ompConfig
  }

  $starshipConfig = "$env:USERPROFILE\.config\starship.toml"
  if (-not (Test-Path $starshipConfig)) {
    New-Item -Path $starshipConfig -Force | Out-Null
    Invoke-WebRequest -Uri 'https://starship.rs/presets/toml/tokyo-night.toml' -OutFile $starshipConfig
  }
  
  if ($starShip.Starship -eq 0) {
    oh-my-posh init pwsh --config $ompConfig | Invoke-Expression
  }
  elseif ($starShip.Starship -eq 1) {
    Invoke-Expression (&starship init powershell)
  }

  $key = Get-ItemProperty -Path $keyPath -Name 'FirstRun' -ErrorAction SilentlyContinue
  if ($key.FirstRun -eq 1) {
    if (-not (Test-Path $keyPath)) {
      New-Item -Path $keyPath -Force | Out-Null
    }
    New-ItemProperty -Path $keyPath -Name 'FirstRun' -Value 0 -PropertyType 'DWord' -Force | Out-Null

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Welcome to Azrael's $($shellType) Profile!"
    $form.BackColor = $nord0
    $form.ForeColor = $nord4
    $form.Font = New-Object System.Drawing.Font("Arial", 10)
    $form.StartPosition = 'CenterScreen'
    $form.Size = New-Object System.Drawing.Size(400, 200)
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.Icon = $icon

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Hello, $userName! Welcome to $($shellType). For more information, please type 'help' or 'tips'."
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

  # Check for the login message key
  $loginMessageKey = Get-ItemProperty -Path $keyPath -Name 'LoginMessage' -ErrorAction SilentlyContinue
  # Create the login message key if it doesn't exist
  if ($null -eq $loginMessageKey) {
    New-ItemProperty -Path $keyPath -Name 'LoginMessage' -Value 1 -PropertyType 'DWord' -Force | Out-Null
  }

  # Check for the login message
  $loginMessage = $loginMessageKey.LoginMessage
  # Display the login message if it's enabled
  if ($loginMessage) {
    Write-Host "Microsoft Windows [Version $($kernelVersion)]"
    Write-Host "(c) Microsoft Corporation. All rights reserved.`n"
  
    Write-Host "Azrael's $($shellType) v$($currentVersion.Trim())"
    Write-Host "Copyright (c) 2023-2024 Azrael"
    Write-Host "https://github.com/luke-beep/shell-config/`n"
  }
}
Initialize-Profile

function Set-ProfileSettings {
  $PanelWidth = 1000

  $form = New-Object System.Windows.Forms.Form
  $form.Text = "$($shellType) Profile Settings"
  $form.BackColor = $nord0
  $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
  $form.StartPosition = 'CenterScreen'
  $form.FormBorderStyle = 'FixedDialog'
  $form.Icon = $icon

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

<#
.SYNOPSIS
  Allows you to manage your entire profile
.DESCRIPTION 
  This function allows you to manage your profile
#>
function Manage-Profile {
  $PanelWidth = 1000

  $form = New-Object System.Windows.Forms.Form
  $form.Text = "Manage $($shellType) Profile"
  $form.BackColor = $nord0
  $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
  $form.StartPosition = 'CenterScreen'
  $form.FormBorderStyle = 'FixedDialog'
  $form.Icon = $icon

  $buttonPanel = New-Object System.Windows.Forms.Panel
  $buttonPanel.Dock = 'Top'
  $buttonPanel.Height = 50

  $button1 = New-Object System.Windows.Forms.Button
  $button1.Text = "Update Profile"
  $button1.Width = 100
  $button1.Height = 30
  $button1.Location = New-Object System.Drawing.Point(10, 10)
  $button1.BackColor = $nord1
  $button1.ForeColor = $nord4
  $button1.FlatStyle = 'Flat'
  $button1.FlatAppearance.BorderSize = 0
  $button1.Add_Click({
      Update-Profile -Force
    })
  $buttonPanel.Controls.Add($button1)

  $updateAliasesButton = New-Object System.Windows.Forms.Button
  $updateAliasesButton.Text = "Update Aliases"
  $updateAliasesButton.Width = 100
  $updateAliasesButton.Height = 30
  $updateAliasesButton.Location = New-Object System.Drawing.Point(120, 10)
  $updateAliasesButton.BackColor = $nord1
  $updateAliasesButton.ForeColor = $nord4
  $updateAliasesButton.FlatStyle = 'Flat'
  $updateAliasesButton.FlatAppearance.BorderSize = 0
  $updateAliasesButton.Add_Click({
      Import-Aliases -Force
    })

  $buttonPanel.Controls.Add($updateAliasesButton)

  $button2 = New-Object System.Windows.Forms.Button
  $button2.Text = "Change Theme"
  $button2.Width = 100
  $button2.Height = 30
  $button2.Location = New-Object System.Drawing.Point(230, 10)
  $button2.BackColor = $nord1
  $button2.ForeColor = $nord4
  $button2.FlatStyle = 'Flat'
  $button2.FlatAppearance.BorderSize = 0
  $button2.Add_Click({
      Set-ShellTheme
    })
  $buttonPanel.Controls.Add($button2)

  $button3 = New-Object System.Windows.Forms.Button
  $button3.Text = "Settings"
  $button3.Width = 100
  $button3.Height = 30
  $button3.Location = New-Object System.Drawing.Point(340, 10)
  $button3.BackColor = $nord1
  $button3.ForeColor = $nord4
  $button3.FlatStyle = 'Flat'
  $button3.FlatAppearance.BorderSize = 0
  $button3.Add_Click({
      Set-ProfileSettings
    })
  $buttonPanel.Controls.Add($button3)

  $button4 = New-Object System.Windows.Forms.Button
  $button4.Text = "Add Alias"
  $button4.Width = 100
  $button4.Height = 30
  $button4.Location = New-Object System.Drawing.Point(450, 10)
  $button4.BackColor = $nord1
  $button4.ForeColor = $nord4
  $button4.FlatStyle = 'Flat'
  $button4.FlatAppearance.BorderSize = 0
  $button4.Add_Click({
      Add-Aliases
    })
  $buttonPanel.Controls.Add($button4)

  $button5 = New-Object System.Windows.Forms.Button
  $button5.Text = "Remove Alias"
  $button5.Width = 100
  $button5.Height = 30
  $button5.Location = New-Object System.Drawing.Point(560, 10)
  $button5.BackColor = $nord1
  $button5.ForeColor = $nord4
  $button5.FlatStyle = 'Flat'
  $button5.FlatAppearance.BorderSize = 0
  $button5.Add_Click({
      Remove-Aliases
    })
  $buttonPanel.Controls.Add($button5)

  $button6 = New-Object System.Windows.Forms.Button
  $button6.Text = "Profile Help"
  $button6.Width = 100
  $button6.Height = 30
  $button6.Location = New-Object System.Drawing.Point(670, 10)
  $button6.BackColor = $nord1
  $button6.ForeColor = $nord4
  $button6.FlatStyle = 'Flat'
  $button6.FlatAppearance.BorderSize = 0
  $button6.Add_Click({
      Get-ProfileHelp
    })
  $buttonPanel.Controls.Add($button6)

  $button7 = New-Object System.Windows.Forms.Button
  $button7.Text = "Profile Tips"
  $button7.Width = 100
  $button7.Height = 30
  $button7.Location = New-Object System.Drawing.Point(780, 10)
  $button7.BackColor = $nord1
  $button7.ForeColor = $nord4
  $button7.FlatStyle = 'Flat'
  $button7.FlatAppearance.BorderSize = 0
  $button7.Add_Click({
      Get-ShellTips
    })
  $buttonPanel.Controls.Add($button7)

  $panel = New-Object System.Windows.Forms.Panel
  $panel.Dock = 'Fill'
  $panel.AutoScroll = $false

  $richTextBox = New-Object System.Windows.Forms.RichTextBox
  $richTextBox.Location = New-Object System.Drawing.Point(0, 0)
  $richTextBox.Size = New-Object System.Drawing.Size(($PanelWidth + 20), 490)
  $richTextBox.Text = (Get-Content $profile | Out-String)
  $richTextBox.BackColor = $nord0
  $richTextBox.ForeColor = $nord4
  $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
  $richTextBox.ReadOnly = $true
  $richTextBox.BorderStyle = 'None'
  $richTextBox.ScrollBars = 'Vertical'

  $form.Controls.Add($buttonPanel)

  $panel.Controls.Add($richTextBox)

  $form.Controls.Add($panel)

  $form.ShowDialog()
}

<#
.SYNOPSIS
  Gets all of the available packages
.DESCRIPTION 
  This function gets all of the available packages
.PARAMETER Install 
  If this parameter is specified, the packages will be updated
#>
function Get-Packages {
  param (
    [Parameter(Mandatory = $false)]
    [string]$Install
  )

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
  if ($Install) {
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
#>
function List-Directories {
  param(
    [Parameter(Mandatory = $false)]
    [string]$Path = ".",

    [Parameter(Mandatory = $false)]
    [Alias("R")]
    [switch]$Recurse = $false,

    [Parameter(Mandatory = $false)]
    [Alias("a")]
    [switch]$ShowHidden = $false
  )
  if ($Recurse) {
    Get-ChildItem -Path $Path -Recurse -Force:$ShowHidden | Format-Table -AutoSize
  }
  else {
    Get-ChildItem -Path $Path -Force:$ShowHidden | Format-Table -AutoSize
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
#>
function Print-Working-Directory {
  $CurrentDirectory = Get-Location
  $CurrentDirectory.Path
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
#>
function Change-Directory {
  param (
    [Parameter(Mandatory = $false)]
    [string]$Path
  )
  if ($Path) {
    Set-Location -Path $Path
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
#>
function Make-Directory {
  param (
    [Parameter(Mandatory = $true)]
    [string[]]$Path,

    [Parameter(Mandatory = $false)]
    [Alias("v")]
    [switch]$Verbose,
    
    [Parameter(Mandatory = $false)]
    [Alias("m")]
    [string]$Permission
  )
  $Path | ForEach-Object {
    New-Item -Path $_ -ItemType Directory -Force
    if ($Permission) {
      icacls $_ /grant "$($env:USERNAME):$Permission" /c /q
    }
    if ($Verbose) {
      Write-Host "Created directory $_"
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
#>
function Remove-Directory {
  param (
    [Parameter(Mandatory = $false)]
    [Alias("p")]
    [switch]$Recurse,

    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )
  $Path | ForEach-Object {
    if ($Recurse) {
      Remove-Item -Path $_ -Recurse -Force
    }
    else {
      Remove-Item -Path $_
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
#>
function Remove-File {
  param (  
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
#>
function Copy-Folder-File {
  param(  
    [Parameter(Mandatory = $true)]
    [string[]]$Source,

    [Parameter(Mandatory = $true)]
    [string]$Destination,

    [Parameter(Mandatory = $false)]
    [Alias("R")]
    [Switch]$Recurse
  )

  foreach ($item in $Source) {
    Copy-Item $item $Destination -Recurse:$Recurse
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
#>
function Move-Folder-File {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Source,

    [Parameter(Mandatory = $true)]
    [string]$Destination
  )

  foreach ($item in $Source) {
    Move-Item $item $Destination
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
#>
function Create-File {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

  foreach ($item in $Path) {
    if (!(Test-Path $item)) {
      New-Item -ItemType File -Path $item -Force
    }
    else {
          (Get-Item -Path $item).LastWriteTime = Get-Date
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
#>
function File-Type {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

  foreach ($item in $Path) {
    if (Test-Path $item) {
      $file = Get-Item -Path $item
      $file.Extension
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
#>
function Read-File {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

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
#>
function Read-File-Reverse {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

  foreach ($item in $Path) {
    $content = Get-Content $item -ReadCount 0
    [array]::Reverse($content)
    $content
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
#>
function Head-File {
  param(      
    [Parameter(Mandatory = $true)]
    [string[]]$Path,

    [Parameter(Mandatory = $false)]
    [Alias("n")]
    [int]$Lines = 10
  )

  foreach ($item in $Path) {
    Get-Content $item -TotalCount $Lines
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
#>
function Tail-File {
  param(    
    [Parameter(Mandatory = $true)]
    [string[]]$Path,

    [Parameter(Mandatory = $false)]
    [Alias("n")]
    [int]$Lines = 10
  )

  foreach ($item in $Path) {
    $content = Get-Content $item
    $content[ - $Lines..-1]
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
#>
function Differential-File {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Path
  )

  foreach ($item in $Path) {
    Compare-Object -ReferenceObject (Get-Content $item) -DifferenceObject (Get-Content $item)
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
#>
function Write-OutputAndFile {
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$InputObject,

    [Parameter(Mandatory = $true)]
    [string[]]$FilePath
  )

  process {
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
#>
function Locate-File {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Pattern
  )

  $currentLocation = Get-Location
  Get-ChildItem -Path $currentLocation -Filter "*$Pattern*" -File -Recurse -ErrorAction SilentlyContinue | Select-Object FullName
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
#>
function Find-Item {
  param(
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

  if ($ItemType -eq "f") {
    Get-ChildItem -Path $Path -Filter $ItemName -File -Recurse -ErrorAction SilentlyContinue | Select-Object FullName
  }
  else {
    Get-ChildItem -Path $Path -Filter $ItemName -Directory -Recurse -ErrorAction SilentlyContinue | Select-Object FullName
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
#>
function Get-DiskUsage {
  param(
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

  $sizeType = "GB"
  if ($Megabytes) {
    $sizeType = "MB"
  }
  elseif ($Kilobytes) {
    $sizeType = "KB"
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
#>
function Get-DirectorySize {
  param(
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

  $items = Get-ChildItem $Path -Recurse -File
  $size = ($items | Measure-Object -Property Length -Sum).Sum

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

  return $output
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
#>
function Get-SystemInfo {
  param(
    [Parameter(Mandatory = $false)]
    [Alias("s")]
    [switch]$KernelName,

    [Parameter(Mandatory = $false)]
    [Alias("n")]
    [switch]$NodeHostName
  )

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
      OS               = (Get-WmiObject -Class Win32_OperatingSystem).Caption
      'Hostname'       = [System.Net.Dns]::GetHostName()
      Version          = [System.Environment]::OSVersion.Version
      'Kernel version' = (Get-CimInstance -ClassName Win32_OperatingSystem).Version
      Time             = Get-Date -Format "HH:mm:ss"
    }
  }

  return $output
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
#>
function Get-HostNameInfo {
  param(
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

  return $output
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
#>
function Measure-ExecutionTime {
  param(
    [Parameter(Mandatory = $true)]
    [scriptblock]$ScriptBlock
  )

  $result = Measure-Command -Expression $ScriptBlock

  $output = [PSCustomObject]@{
    'Execution Time (ms)' = $result.TotalMilliseconds
  }

  return $output
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
#>
function Get-Jobs {
  param(
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

<#
.SYNOPSIS
  Kills a process
.DESCRIPTION
  This function kills a process    
.PARAMETER ProcessId
  The ID of the process, can be retrieved with Get-Process
#>
function Kill-Process {
  param (
    [Parameter(Mandatory = $true)]
    [string]$ProcessId
  )

  Stop-Process -Id $ProcessId
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
#>
function Find-DNSRecord {
  param (
    [Parameter(Mandatory = $true)]
    [string]$Domain,

    [Parameter(Mandatory = $true)]
    [string]$Type
  )

  Resolve-DnsName -Name $Domain -Type $Type
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
#>
function Shell-History {
  param (
    [Parameter(Mandatory = $false)]
    [Alias("c")]
    [switch]$Clear,

    [Parameter(Mandatory = $false)]
    [Alias("s")]
    [string]$Save
  )

  if ($Clear) {
    Clear-History
  }

  if ($Save) {
    Get-History | Out-File $Save
  }

  Get-History
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
  Generates a system report
.DESCRIPTION
  This function generates a system report
#>
function Get-SystemReport {
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
  Download object(s)
.DESCRIPTION 
  This function downloads object(s) to the specified path or the current directory
.PARAMETER Url 
  The URL of the object
#>
function Invoke-DownloadObject {
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
  Invoke-DownloadObject -Url "http://example.com/file1.zip", "http://example.com/file2.zip" | Invoke-Object
#>
function Invoke-Object {
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

<#
.SYNOPSIS
  Gets the status of all services
.DESCRIPTION 
  This function gets the status of all services
#>
function Get-Services {
  Get-Service | ForEach-Object {
    $status = $_.Status
    $name = $_.Name
    $displayName = $_.DisplayName
    Write-Output ("{0} ({1}): {2}" -f $displayName, $name, $status)
  }
}

<#
.SYNOPSIS
  Hacks a target
.DESCRIPTION
  This function hacks a target
.PARAMETER Target 
  The target
#>
function Invoke-TargetHack {
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
  Scans an IP address
.DESCRIPTION
  This function scans an IP address
.PARAMETER IP 
  The IP address
.PARAMETER Extended
  Whether to show extended information
#>
function Test-IP {
  param (
    [Parameter(Mandatory = $true)][string]$IP,
    [Parameter(Mandatory = $false)][switch]$Extended
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
function Test-Ports {
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
  Allows you to manage your hosts file
.DESCRIPTION 
  This function allows you to manage your hosts file
#>
function Edit-Hosts {
  Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/HostEntryManager.ps1" | Invoke-Expression
}

<#
.SYNOPSIS
  Allows you to manage your DNS settings
.DESCRIPTION 
  This function allows you to manage your DNS settings
#>
function Set-DNS {
  Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/DNSChanger.ps1" | Invoke-Expression
}

<#
.SYNOPSIS
  Allows you to manage your network adapters
.DESCRIPTION 
  This function allows you to manage your network adapters
#>
function Set-NetworkAdapter {
  Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/NetworkAdapterManager.ps1" | Invoke-Expression
}

<# 
.SYNOPSIS
  Disables Nagles algorithm
.DESCRIPTION 
  This function disables Nagles algorithm
#>
function Set-Nagles {
  Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/all-about-windows/main/scripts/NaglesAlgorithm.ps1" | Invoke-Expression
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
  Backs up the current workspace to a specified directory
.DESCRIPTION
  This function backs up the current workspace to a specified directory
#>
function Take-Snapshot {
  $BackupDirectory = "$SystemDrive\Snapshots"

  $currentDirectory = Get-Location
  $backupPath = Join-Path -Path $BackupDirectory -ChildPath (Get-Date -Format "yyyy-MM-dd_HH-mm-ss") + "_" + (Split-Path -Leaf $currentDirectory.Provider)

  if (!(Test-Path -Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath | Out-Null
  }

  Copy-Item -Path "$currentDirectory\*" -Destination $backupPath -Recurse -Force
}

<#
.SYNOPSIS
  Tips & tricks for using this profile
.DESCRIPTION 
  This function displays tips & tricks for using this profile
#>
function Get-ShellTips {
  $PanelWidth = 1000

  $form = New-Object System.Windows.Forms.Form
  $form.Text = "$($shellType) Profile Tips"
  $form.BackColor = $nord0
  $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
  $form.StartPosition = 'CenterScreen'
  $form.FormBorderStyle = 'FixedDialog'
  $form.Icon = $icon

  $panel = New-Object System.Windows.Forms.Panel
  $panel.Dock = 'Fill'
  $panel.AutoScroll = $false

  $guideText = Invoke-RestMethod "https://raw.githubusercontent.com/luke-beep/shell-config/main/configs/pwsh/tips.md"

  $richTextBox = New-Object System.Windows.Forms.RichTextBox
  $richTextBox.Location = New-Object System.Drawing.Point(0, 0)
  $richTextBox.Size = New-Object System.Drawing.Size(($PanelWidth + 20), 490)
  $richTextBox.Text = $guideText
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
  Allows you to configure your theme
.DESCRIPTION 
  This function allows you to configure your theme
#>
function Set-ShellTheme {
  $ompConfig = "$env:USERPROFILE\.config\omp.json"
  $starshipConfig = "$env:USERPROFILE\.config\starship.toml"
  $starShip = Get-ItemProperty -Path $keyPath -Name 'Starship' -ErrorAction SilentlyContinue

  $PanelWidth = 400
  $PanelHeight = 200

  if ($starShip.Starship -eq 1) {
    Start-Process https://starship.rs/presets/

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Starship Theme Configuration"
    $form.BackColor = $nord0
    $form.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.Icon = $icon
    $form.Topmost = $true
    $form.MinimizeBox = $false
    $form.MaximizeBox = $false

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = 'Fill'
    $panel.AutoScroll = $false

    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 2
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))

    $richTextBox = New-Object System.Windows.Forms.RichTextBox
    $richTextBox.Location = New-Object System.Drawing.Point(0, 0)
    $richTextBox.Size = New-Object System.Drawing.Size(($PanelWidth + 20), ($PanelHeight - 10))
    $richTextBox.Text = "Enter the URL of the theme you want to use. E.g. https://starship.rs/presets/toml/tokyo-night.toml"
    $richTextBox.BackColor = $nord0
    $richTextBox.ForeColor = $nord4
    $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
    $richTextBox.BorderStyle = 'None'
    $richTextBox.ScrollBars = 'Vertical'

    $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)

    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Location = New-Object System.Drawing.Point(0, 0)
    $saveButton.Size = New-Object System.Drawing.Size(($PanelWidth + 20), 30)
    $saveButton.Dock = [System.Windows.Forms.DockStyle]::Fill
    $saveButton.Text = "Save"
    $saveButton.BackColor = $nord0
    $saveButton.ForeColor = $nord4
    $saveButton.FlatStyle = 'Flat'
    $saveButton.FlatAppearance.BorderSize = 0
    $saveButton.Add_Click({
        $url = $richTextBox.Text
        $urlContent = Invoke-RestMethod $url
        $urlContent | Out-File $starshipConfig

        [System.Windows.Forms.MessageBox]::Show("Starship theme successfully changed.", "Success")
      })

    $tableLayoutPanel.Controls.Add($saveButton, 0, 1)

    $panel.Controls.Add($tableLayoutPanel)

    $form.Controls.Add($panel)

    $form.ShowDialog()
  }
  else {
    Start-Process https://ohmyposh.dev/docs/themes
    $PanelWidth = 400
    $PanelHeight = 200

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Oh-my-posh Theme Configuration"
    $form.BackColor = $nord0
    $form.Size = New-Object System.Drawing.Size($PanelWidth, $PanelHeight)
    $form.StartPosition = 'CenterScreen'
    $form.FormBorderStyle = 'FixedDialog'
    $form.Icon = $icon
    $form.Topmost = $true
    $form.MinimizeBox = $false
    $form.MaximizeBox = $false

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = 'Fill'
    $panel.AutoScroll = $false

    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 2
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Clear()
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))

    $richTextBox = New-Object System.Windows.Forms.RichTextBox
    $richTextBox.Location = New-Object System.Drawing.Point(0, 0)
    $richTextBox.Size = New-Object System.Drawing.Size(($PanelWidth + 20), ($PanelHeight - 10))
    $richTextBox.Text = "Enter the URL of the theme you want to use. E.g. https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/1_shell.omp.json"
    $richTextBox.BackColor = $nord0
    $richTextBox.ForeColor = $nord4
    $richTextBox.Font = New-Object System.Drawing.Font("Consolas", 10)
    $richTextBox.BorderStyle = 'None'
    $richTextBox.ScrollBars = 'Vertical'

    

    $tableLayoutPanel.Controls.Add($richTextBox, 0, 0)

    $saveButton = New-Object System.Windows.Forms.Button
    $saveButton.Location = New-Object System.Drawing.Point(0, 0)
    $saveButton.Size = New-Object System.Drawing.Size(($PanelWidth + 20), 30)
    $saveButton.Dock = [System.Windows.Forms.DockStyle]::Fill
    $saveButton.Text = "Save"
    $saveButton.BackColor = $nord0
    $saveButton.ForeColor = $nord4
    $saveButton.FlatStyle = 'Flat'
    $saveButton.FlatAppearance.BorderSize = 0
    $saveButton.Add_Click({
        $url = $richTextBox.Text
        $urlContent = Invoke-WebRequest $url
        $urlContent.Content | Out-File $ompConfig

        [System.Windows.Forms.MessageBox]::Show("Oh-my-posh theme successfully changed.", "Success")
      })
    
    $tableLayoutPanel.Controls.Add($saveButton, 0, 1)

    $panel.Controls.Add($tableLayoutPanel)

    $form.Controls.Add($panel)

    $form.ShowDialog()

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
#>
function Find-Manual {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name
  )

  Get-Help -Name $Name -Full
}

<#
.SYNOPSIS
  Loads aliases
.DESCRIPTION 
  This function loads aliases
.PARAMETER Force 
  Forces the loading of aliases
#>
function Import-Aliases {
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
          if ($shellType -eq "Pwsh") {
            Remove-Alias $alias -Force -Scope Global 
          }
          else {
            Remove-Item alias:$alias -Force
          }
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

<#
.SYNOPSIS
  Adds aliases through a GUI
.DESCRIPTION 
  This function allows you to add aliases through a GUI
#>
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
  $form.FormBorderStyle = "FixedDialog"
  $form.Icon = $icon

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

<#
.SYNOPSIS
  Removes aliases through a GUI
.DESCRIPTION  
  This function allows you to remove aliases through a GUI
#>
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

  

  $width = 400
  $height = 300

  $form = New-Object System.Windows.Forms.Form
  $form.Width = $width
  $form.Height = $height
  $form.Text = "Alias Configuration"
  $form.StartPosition = "CenterScreen"
  $form.BackColor = $nord0
  $form.ForeColor = $nord4
  $form.FormBorderStyle = "FixedDialog"
  $form.Icon = $icon

  $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
  $tableLayoutPanel.Width = $width
  $tableLayoutPanel.RowCount = 1
  $tableLayoutPanel.ColumnCount = 1
  $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  $tableLayoutPanel.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
  $tableLayoutPanel.RowStyles.Clear()
  $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
  $tableLayoutPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $tableLayoutPanel.AutoScroll = $false

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

function Get-ReverseAlias {
  param (
    [Parameter(Mandatory = $true)][string]$Command
  )

  $aliases = Get-Alias | Where-Object { $_.Definition -eq $Command }
  if ($aliases) {
    $aliases.Name
  }
}

<#
.SYNOPSIS
  Displays the help menu
.DESCRIPTION 
  This function displays the help menu
.PARAMETER ShowInConsole
  Displays the help menu in the console
#>
function Get-ProfileHelp {
  param (
    [Parameter(Mandatory = $false)]
    [Alias('c')]
    [switch]$ShowInConsole = $false
  )
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

  if ($ShowInConsole) {
    Clear-Host
    $commandString = "For more information about a command, type 'Get-Help <command-name>'`n" + ($commands | Out-String)
    $commandString
  }
  else {
    Clear-Host
    $commandsOutput = $commands | Format-Table -Wrap -AutoSize | Out-String
    Show-Help -Output $commandsOutput -Introduction "For more information about a command, type 'Get-Help <command-name>'"
  }
}

function Show-Help {
  param (
    [Parameter(Mandatory = $true)][string]$Output,
    [Parameter(Mandatory = $true)][string]$Introduction
  )

  $PanelWidth = 1000

  $form = New-Object System.Windows.Forms.Form
  $form.Text = "$($shellType) Profile Help"
  $form.BackColor = $nord0
  $form.Size = New-Object System.Drawing.Size($PanelWidth, 500)
  $form.StartPosition = 'CenterScreen'
  $form.FormBorderStyle = 'FixedDialog'
  $form.Icon = $icon

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
  Simple calendar
.DESCRIPTION
  This function displays a simple calendar
.PARAMETER Month
  The month
.PARAMETER Year
  The year
.EXAMPLE
  Calendar 12 2020
#>
function Calendar {
  param(
    [Parameter(Position = 0)]
    [int]$Month = (Get-Date).Month,
    [Parameter(Position = 1)]
    [int]$Year = (Get-Date).Year
  )

  $daysInMonth = [DateTime]::DaysInMonth($Year, $Month)
  $date = New-Object DateTime $Year, $Month, 1

  Write-Host ("    {0} {1}" -f $date.ToString('MMMM'), $Year)
  Write-Host "Su Mo Tu We Th Fr Sa"

  1..$date.DayOfWeek.value__ | ForEach-Object { Write-Host "   " -NoNewline }
  1..$daysInMonth | ForEach-Object {
    $day = $_
    $date = New-Object DateTime $Year, $Month, $day
    if ($day -lt 10) { Write-Host " $day" -NoNewline } else { Write-Host "$day" -NoNewline }
    if ($date.DayOfWeek.value__ -eq 6) { Write-Host "" }
    else { Write-Host " " -NoNewline }
  }
  Write-Host ""
}

<#
.SYNOPSIS
  Gets the current shell information
.DESCRIPTION
  This function gets the current shell information
#>
function Get-ShellInfo {
  Write-Output "Profile Path: $PROFILE"
  Write-Output "Host Name: $($host.Name)"
  Write-Output "Host Version: $($host.Version) -> $($shellType) ($bitness)"
}


# ----------------------------------------
# End of profile
# ----------------------------------------
Import-Aliases