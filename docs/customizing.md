# How to extend this profile with your own customizations

This profile is designed to be extended and customized. You can add your own functions, aliases, variables, and more. You can also override existing functions, aliases, variables, and more.

To add your own customizations, simply type `profile` and hit enter. This will open a new immersive window with the profile script at the bottom and various profile configuration buttons at the top. You can then click one of the buttons to add your own customizations. There are a few guidelines to follow when adding your own customizations:

- **Do not edit the profile script directly.** The profile script is designed to be modular and read-only. If you edit the profile script directly, your changes will be lost the next time you run update the profile.

### Adding your own functions

To add your own functions, simply type `profile` and hit enter. Then click the `Functions` button. This will open a new immersive window with a function template. You can then add your own code to the function template. When you're done, click the `Save` button to save your changes. There are a few guidelines to follow when adding your own functions:

```powershell
# (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced?view=powershell-7.3)
# (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-7.3)
# (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.3)
# (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_argument_completion?view=powershell-7.3)
# (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-7.3)

function global:ExampleFunction {
    [CmdletBinding()]
    PARAM ( ) # Parameters go here.

    DYNAMICPARAM { # Dynamic parameters go here.
        # Dynamic parameters are parameters that are added to the command
        # based on the values of other parameters.
    }

    BEGIN {
        TRAP { continue } # Error handling goes here.
    } # Runs before anything else.

    PROCESS {
        TRAP { continue } # Error handling goes here.
    } # Runs once for each input.

    CLEAN {
        TRAP { continue } # Error handling goes here.
        # Cleanup code goes here.
    } # Runs after PROCESS and before END. ONLY AVAILABLE IN POWERSHELL 7.3+.

    END {
        TRAP { continue } # Error handling goes here.
    } # Runs after everything else.
}
```

### Adding your own aliases

To add your own aliases, simply type `profile` and hit enter. Then click the `Add Alias` button. This will open a new immersive window with an alias template. You can then add your own code to the alias template. When you're done, click the `Save` button to save your changes. There are a few guidelines to follow when adding your own aliases:

- **Adding aliases for existing commands.** If you're adding an alias for a command that already exists, make sure to first include it in the `Remove Alias` section of the profile view.

- **Adding aliases for new commands.** If you're adding an alias for a command that doesn't exist, make sure to include it in the `Add Alias` section of the profile view. Then simply restart your shell and the alias will be available.

### Adding your own variables

To add your own variables, simply type `profile` and hit enter. Then click the `Variables` button. This will open a new immersive window with a variable template. You can then add your own code to the variable template. When you're done, click the `Save` button to save your changes. There are a few guidelines to follow when adding your own variables:

- **Do not add variables that are already defined.** If you're adding a variable that is already defined, issues may arise. For example, if you add a variable that is already defined, the variable will be overwritten.

- **Do not add variables undefined variables.** If you're adding a variable that is not defined, issues may arise. For example, if you add a variable that is not defined, the variable will not be available.

```powershell
Set-Variable -Name "ExampleVariable" -Value "ExampleValue" -Scope Global
```

### Configuring your own settings

To configure your own settings, simply type `profile` and hit enter. Then click the `Settings` button. This will open a new immersive window with a settings template. You can then change the settings to your liking. When you're done, click the `Save` button to save your changes. There are a few guidelines to follow when configuring your own settings:

- **Do not add settings that don't exist.** If you're adding a setting that doesn't exist, issues may arise. For example, if you add a setting that doesn't exist, the setting will not be available and it'll clutter the settings registry.

- **Do not remove settings that exist.** If you're removing a setting that exists, issues may arise.

- **Do not change the following settings.** If you're changing the following settings, issues may arise.
  - Version
  - FirstRun

### Choosing your own shell theme

To choose your own shell theme, simply type `profile` and hit enter. Then click the settings button. This will open a new immersive window with a settings template. There are currently 2 shell themes to choose from: `Starship` and `Oh-my-posh`. You can choose your shell theme by changing the `Starship` setting. When you're done, click the `Save` button to save your changes.

- **Starship** - Starship is a cross-shell prompt for astronauts. It works with Bash, Zsh, Fish, and PowerShell. It's minimal, blazing fast, and infinitely customizable. Starship can be installed via Scoop, Chocolatey, and more. For more information, visit the [Starship GitHub page](https://github.com/starship/starship).

- **Oh-my-posh** - Oh-my-posh is a theme engine for any shell that uses PowerShell. It's highly customizable and easy to configure. Oh-my-posh can be installed via Scoop, Chocolatey, and more. For more information, visit the [Oh-my-posh GitHub page](https://github.com/JanDeDobbeleer/oh-my-posh).

### Changing your shell theme settings

To change your shell theme settings, simply type `profile` and hit enter. Then click the `Change Theme` button. This will open a new immersive window with a theme template. You can then include an URL to your theme file. When you're done, click the `Save` button to save your changes. There are a few guidelines to follow when changing your shell theme settings:

- It must be a valid URL. If you include an invalid URL, issues may arise.
- It must be a valid JSON file. If you include an invalid JSON file, issues may arise.
- It must be a valid theme file. If you include an invalid theme file, issues may arise.

When you're done, click the `Save` button to save your changes; then restart your shell.

### Choosing between Dark and Light mode

To choose between Dark and Light mode, simply type `profile` and hit enter. Then click the `Settings` button. This will open a new immersive window with a settings template. You can then choose between Dark and Light mode by toggling the `LightMode` setting. When you're done, click the `Save` button to save your changes.

- **Dark mode** - Dark mode is a color scheme that uses dark background colors and light foreground colors. It's designed to reduce eye strain and improve readability in low-light environments. Dark mode can be enabled by setting the `LightMode` setting to `0`. They're utilizing the Nord theme color variables for a beautiful interface.

- **Light mode** - Light mode is a color scheme that uses light background colors and dark foreground colors. It's designed to reduce eye strain and improve readability in bright environments. Light mode can be enabled by setting the `LightMode` setting to `1`. They're utilizing the Nord theme color variables for a beautiful interface.

- Overriding the current theme color variables. If you want to override the current theme color variables, you can do so by opening the `profile` menu and clicking on the `Variables` button. After that you need to add the following variables to the `Variables` section of the profile view:

  - **$PrimaryBackgroundColor** # Primary background color. Used for forms and other elements.
  - **$SecondaryBackgroundColor** # Secondary background color, used for alternate backgrounds like buttons.
  - **$PrimaryForegroundColor** # Primary foreground color. Used for text.
  - **$SecondaryForegroundColor** # Secondary foreground color. Used for alternate text like buttons foreground.
  - **$AccentColor** # Accent color. Used for highlighting elements, e.g. button borders.

```powershell
Set-Variable -Name "PrimaryBackgroundColor" -Value "#HexColor" -Scope Global
Set-Variable -Name "SecondaryBackgroundColor" -Value "#HexColor" -Scope Global
Set-Variable -Name "PrimaryForegroundColor" -Value "#HexColor" -Scope Global
Set-Variable -Name "SecondaryForegroundColor" -Value "#HexColor" -Scope Global
Set-Variable -Name "AccentColor" -Value "#HexColor" -Scope Global
```

---

**<div align="center" id="footer">© 2023 LukeHjo. All rights reserved. <div>**
<br>

<div align="right"><a href="#">(Back to top)</a></div>
```
