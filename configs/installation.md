### Installation

---

1. **Clone the repository**: Clone this repository to your local machine using the following command:

    ```bash
    git clone https://github.com/luke-beep/shell-config.git
    ```

2. **Navigate to the repository**: Change your current directory to the cloned repository:

    ```bash
    cd shell-config
    ```

3. **Copy the clink configuration file**: Copy the [`oh-my-posh.lua`](/configs/clink/oh-my-posh.lua) file to the clink configuration directory:

    ```bash
    cp configs\clink\oh-my-posh.lua "C:\Program Files (x86)\clink\oh-my-posh.lua"
    ```

4. **Copy the Windows Terminal configuration file**: Copy the [`settings.json`](/configs/windows-terminal/settings.json) file to the Windows Terminal configuration directory:

    ```bash
    cp configs\windows-terminal\settings.json "%LocalAppData%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    ```

5. **Copy the PowerShell profile**: Copy the [`Microsoft.PowerShell_profile.ps1`](/configs/powershell/Microsoft.PowerShell_profile.ps1) file to the PowerShell profile directory:

    ```bash
    cp configs\powershell\Microsoft.PowerShell_profile.ps1 "%UserName%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
    cp configs\powershell\Microsoft.PowerShell_profile.ps1 "%UserName%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    ```

6. Open the Windows Terminal and enjoy!

> [!NOTE]
> The PowerShell profile will automatically prompt for updates to the repository when you open a new PowerShell session. If you do not wish to do so simply deny the prompt.
