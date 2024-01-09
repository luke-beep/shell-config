<div align="center">

# 🐚 Shell-Config

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/luke-beep/shell-config)
![GitHub stars](https://img.shields.io/github/stars/luke-beep/shell-config)
![GitHub forks](https://img.shields.io/github/forks/luke-beep/shell-config)

</div>

### 🗂️ Table of Contents

---
<!-- no toc -->
- [🐚 Shell-Config](#-shell-config)
    - [🗂️ Table of Contents](#️-table-of-contents)
    - [📚 Description](#-description)
    - [📸 Screenshots](#-screenshots)
    - [🚀 Installation](#-installation)
    - [🌟 Features](#-features)
    - [🛠️ Usage](#️-usage)
    - [🤝 Contributing](#-contributing)
    - [📝 License](#-license)
    - [📮 Contact](#-contact)
    - [🌟 Acknowledgements](#-acknowledgements)

### 📚 Description

---

This repository contains my personal configuration for the Windows Terminal. It's designed to optimize my workflow and make terminal operations more efficient.

### 📸 Screenshots

---

![Screenshot](/assets/Product1.png)
![Screenshot](/assets/Product2.png)

### 🚀 Installation

---

You have two choices for installation. You can either use the automated installation script or manually install the profile. The [automated installation script](./scripts/install-configuration.ps1) is recommended for most users. However, if you want to manually install the profile, you can follow the [manual installation guide](./configs/installation.md).

- **Automated Installation** - The automated installation script is the recommended installation method for most users. It's designed to be user-friendly and easy to use. It will automatically install the profile and configure the Windows Terminal. It will also automatically install the required dependencies. You can use the following command to install the profile:

```powershell
iwr -useb https://raw.githubusercontent.com/luke-beep/shell-config/main/scripts/install-configuration.ps1 | iex
```

- **Manual Installation** - The manual installation guide is designed for advanced users who want to manually install the profile. It's designed to be more flexible and customizable. It will also automatically install the required dependencies. You can follow the [manual installation guide](./configs/installation.md) for more information. **NOTE**: The manual installation guide is not recommended for most users.

### 🌟 Features

---

- **Nord Theme Integration** - Utilizes Nord theme color variables for a beautiful interface.
- **Global Variables** - Includes `$ShellIcon`, `$ShellType`, and more for enhanced scripting.
- **Restart-Shell Function** - Easily restart your PowerShell session.
- **Timestamped Logging** - Functions for detailed, timestamped logs.
- **Write-Color Function** - Enrich your console with colored text.
- **Update-Profile Function** - Keep your profile updated with the latest features.
- **Custom Functions and Variables Management** - Import, manage, and preview custom scripts.
- **Interactive GUI Management** - User-friendly GUI for managing functions and variables.
- **Automated Tool Installation** - Scripted setup for Scoop, Chocolatey, oh-my-posh, and more.
- **Profile Settings GUI** - Customize your profile settings with an interactive interface.
- **Registry Key Management** - Centralized configuration management via Windows Registry.
- **Customizable Login Message** - Personalize your PowerShell greeting message.
- **Error Handling Mechanisms** - Advanced functions for error tracking and logging.
- **Nerd Fonts and Sysinternals Setup** - Enhanced visual appeal with Nerd Fonts and Sysinternals tools integration.
- **Cross-Shell** - Works with both PowerShell and Pwsh (PowerShell Core).
- **Interactive Function and Variable Preview** - Easily view available functions and variables.
- **PowerShell Version Check** - `$ShellType` variable to distinguish between PowerShell versions.
- **Automatic Update Checks** - Option to enable automatic updates for the profile.
- **Manage-Profile Function** - Centralized management for the entire profile.
- **Custom Script Incorporation** - Easily add and manage your own scripts.
- **Help and Documentation** - Access to detailed help and documentation for each function.
- **Guided Initial Setup** - Initial setup with guided instructions and configuration checks.
- **Unix-Style Commands** - Unix-style commands for enhanced cross-platform compatibility. *Note* that these commands are only imitations of the real commands. They are not actual Unix commands and won't function the same way.

This profile is designed to offer a comprehensive, customizable, and user-friendly PowerShell environment.

### 🛠️ Usage

---

After installation, you can use the Windows Terminal as you normally would. The configuration changes should already be applied. Make sure to check out the [`wiki`](https://github.com/luke-beep/shell-config/wiki/) page for detailed information on each function. You can also use the `help` command to view the help documentation for each function. You can also alternatively use the `Get-Help` command to view the help documentation for each function. For example, to view the help documentation for the `Write-Color` function, you can use the following command:

```powershell
Get-Help Write-Color
```

There are also a few functions that are designed to be used in the Windows Terminal. For example, the `Restart-Shell` function is designed to be used in the Windows Terminal. You can use the following command to restart your PowerShell session:

```powershell
Restart-Shell
```

There's also the `Update-Profile` function, which is designed to be used in the Windows Terminal. You can use the following command to update your profile:

```powershell
Update-Profile
```

Then we have the `Manage-Profile` function, which is designed to be used in the Windows Terminal. You can use the following command to manage your profile:

```powershell
Manage-Profile
```

If you want to get more tips on how to use the Windows Terminal, you can use the following command:

```powershell
Get-ShellTips
```

> [!NOTE]
> The actual command is `Get-ShellTips`, but you can also use the alias `tips` to run the command. The tips are located in the [`tips.md`](/configs/pwsh/tips.md) file.

### 🤝 Contributing

---

Contributions are welcome. Please fork this repository and create a pull request with your changes.

### 📝 License

---

This project is licensed under the MIT License. See [`LICENSE`](LICENSE) for more details.

### 📮 Contact

---

If you have any questions, feel free to reach out to me at [lukehjo@duck.com](mailto:lukehjo@duck.com).

### 🌟 Acknowledgements

---

- [luke-beep](https://github.com/luke-beep) for creating this repository and maintaining it.

---

<p align="center">
  <img src="assets/LukeHjo.png" alt="Profile" />
</p>

---

**<div align="center" id="footer">© 2023 LukeHjo. All rights reserved. <div>**
<br>

<div align="right"><a href="#">(Back to top)</a></div>
