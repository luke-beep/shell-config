# Tips for Using Azrael's PowerShell/Pwsh Profile

1. **Understand the Nord Theme**: Familiarize yourself with the Nord theme color codes defined at the start of the profile for customizing your PowerShell environment.

2. **Utilize Global Variables**: Leverage the global variables like `$ShellIcon`, `$ShellType`, and `$Bitness` for scripting and custom configurations. You can add your own global variables to the `custom-variables.ps1` file, which is automatically imported by the profile. Or by using the `Manage-Variables` function.

3. **Restart the Shell Effectively**: Use the `Restart-Shell` function for a quick and effective way to restart your PowerShell session.

4. **Leverage Timestamped Messages**: Utilize functions like `Write-TimestampedInformation`, `Write-TimestampedWarning`, and `Write-TimestampedError` for better logging and debugging.

5. **Use Write-Color for Visual Customization**: Utilize the `Write-Color` function to write colored text and backgrounds in the console, enhancing visual differentiation of output.

6. **Keep Your Profile Updated**: Regularly use `Update-Profile` to check and update the profile, ensuring you have the latest features and fixes.

7. **Import and Manage Custom Functions and Variables**: Use `Import-Functions`, `Manage-Functions`, `Import-Variables`, and `Manage-Variables` to handle custom PowerShell functions and variables effectively.

8. **Preview Functions and Variables**: Utilize `Preview-Functions` and `Preview-Variables` to review the current functions and variables available in your PowerShell session.

9. **Manage the Entire Profile**: Use `Manage-Profile` or `profile` for comprehensive management of your profile, encompassing settings, functions, and variables. Here's a quick overview of the available options:

   - **Settings**: Configure profile settings via a GUI.
   - **Functions**: Import, manage, and preview custom functions.
   - **Variables**: Import, manage, and preview custom variables.
   - **Update**: Check for and update the profile.
   - **Theme**: Change the theme of the profile.

10. **Automate Update Checks**: Take advantage of the auto-update feature in the `Update-Profile` function to keep your profile up to date automatically.

11. **Utilize Shell Icon**: Change the `$ShellIcon` global variable to add a personalized touch to your PowerShell environment.

12. **Take Advantage of Color Themes**: Use the predefined Nord theme color variables for consistent and appealing color schemes in your scripts and console output.

13. **Prompt Customization**: Customize your prompt using either oh-my-posh or starship, with preset configurations available in the profile.

14. **Registry Key Management**: The profile interacts with the Windows Registry for settings storage, providing a persistent and centralized configuration management system. These settings can be managed via the `Manage-Profile` function. The following registry keys are used:

    - **HKCU:\Software\Azrael\PowerShell**: Stores the profile settings for PowerShell.
    - **HKCU:\Software\Azrael\Pwsh**: Stores the profile settings for PowerShell Core.

15. **Login Message Customization**: Adjust the login message as per your preference for a personalized greeting when you start PowerShell.

16. **Use Custom Functions and Variables**: Explore and modify the `custom-functions.ps1` and `custom-variables.ps1` for personalized scripting and environment customization. These files are automatically imported by the profile, and can be managed via the `Manage-Profile` function.

    - **Functions**: The `custom-functions.ps1` file contains custom functions that are automatically imported by the profile. These functions can be managed via the `Manage-Profile` function.
    - **Variables**: The `custom-variables.ps1` file contains custom variables that are automatically imported by the profile. These variables can be managed via the `Manage-Profile` function

17. **Implement Error Handling**: Take advantage of the error handling functions like `Write-TimestampedError` for better debugging and error tracking in your scripts.

18. **Regularly Check for New Features**: Keep an eye on the GitHub repository for updates and new features added to the profile, ensuring you leverage the latest improvements. Make sure to occasionally run the alias update command to ensure maximum compatibility with the latest version of the profile. The alias update command is `Import-Aliases -Force`. Alternatively, you can update the alias list via the `Manage-Profile` function by selecting `Update Aliases`.

19. **Leverage the Essential Tools**: Leverage the tools provided for a quick and easy way level up your PowerShell environment, including oh-my-posh, starship, Nerd Fonts & more.

20. **Leverage GUI for Profile Configuration**: Use the provided GUI tools for configuring and managing profile settings, making it easier to customize various aspects of your PowerShell experience.

21. **Understanding and Modifying the Profile Initialization**: Review and modify the `Initialize-Profile` function according to your preferences and requirements for an optimized startup routine. This can be quite tricky, so make sure to take a backup of the original profile before making any changes.

22. **Leverage PowerShell Version Check**: Use the `$ShellType` variable to distinguish between PowerShell and Pwsh (PowerShell Core), especially useful in cross-platform scripts.
