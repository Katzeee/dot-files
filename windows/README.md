# Windows desktop

This setup uses Komorebi for window tiling, whkd for shortcuts, YASB for the top bar, and THide to hide the Windows taskbar.

## Deploy the configuration

Install the applications first. The configured locations are `D:\komorebi\bin`, `D:\whkd\bin`, `D:\YASB`, and `D:\THide`. Add the Komorebi and whkd executable directories to your user PATH.

| Repository files | Destination |
| --- | --- |
| `komorebi/komorebi.json`, `komorebi/applications.json` | `%USERPROFILE%\` |
| `komorebi/whkdrc` | `%USERPROFILE%\.config\whkdrc` |
| `komorebi/scripts/resize-window.ps1` | `D:\komorebi\scripts\` |
| `yasb/config.yaml`, `yasb/styles.css`, `yasb/assets/` | `%USERPROFILE%\.config\yasb\`, preserving the directory structure |
| `yasb/scripts/InputStatus.exe` | `D:\YASB\scripts\`, built as described below |

The configuration contains absolute paths for this machine. When changing the account name or installation locations, update paths in the YAML, CSS, whkdrc, and resize script, including the CSS paths for the avatar and media button assets.

YASB uses **JetBrainsMono Nerd Font Propo** (`JetBrainsMono NFP` in the configuration) and **Material Symbols Rounded**. Install these fonts for all users so they are available at logon.

The input status helper is stored as source. Run the [build script](../yasb/scripts/Build-InputStatus.ps1) in a regular PowerShell session:

```powershell
& D:\codes\dot-files\yasb\scripts\Build-InputStatus.ps1
```

Copy the generated `InputStatus.exe` to the destination above. Build artifacts are excluded by `.gitignore`.

Deployment is complete when the bar displays its icons and input status, and shortcut commands can locate their executables. Workspace offsets depend on the monitor work area; check single-window centering after changing displays.

## Logon startup and privileges

Open an administrator PowerShell session under the same Windows account you use on the desktop, then run the [autostart registration script](Register-DesktopAutostart.ps1):

```powershell
& D:\codes\dot-files\windows\Register-DesktopAutostart.ps1
```

| Component | Startup entry and privileges | Reason |
| --- | --- | --- |
| Komorebi + whkd | `Komorebi Elevated` scheduled task, interactive logon, highest privileges | On this machine, reading QQ process information fails without elevation; elevated Komorebi can manage it. Starting whkd through the same entry preserves the working command communication environment. |
| YASB | `YASB` scheduled task, interactive logon, normal privileges | The bar runs in the desktop session and needs no elevation. |
| THide | Current-user registry `Run` entry, normal privileges | THide hides the taskbar by default when it starts at user logon. |

The script registers startup entries without starting or restarting the applications. Complete application and configuration deployment first on a new machine. On an existing installation, keep one startup entry per component as listed above and disable duplicate startup apps, shortcuts, or scheduled tasks. Keep any THide scheduled task disabled and use its `Run` entry.

Verify the resulting state: the first two tasks use highest and normal privileges respectively, and THide appears under `HKEY_USERS\<current user SID>\Software\Microsoft\Windows\CurrentVersion\Run`. After signing in again, the window manager and bar should run, and the taskbar should be hidden.

## Taskbar visibility

Install the [official THide executable](https://github.com/amnweb/thide) separately at the configured location. Its control commands are `thide hide`, `thide show`, and `thide toggle`.

`Ctrl + Alt + T` calls THide through `komorebi/whkdrc` to toggle visibility. THide maintains the hidden state; exiting it restores the taskbar. If the taskbar remains visible after logon, check the THide process and startup entry before adding another startup action.

## Win + L

`whkdrc` assigns `Win + L` to focus the window on the right. On this machine, this also requires the machine-wide DWORD `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DisableLockWorkstation` to be set to `1`.

This setting requires administrator privileges, affects all accounts, and disables manual workstation locking. Set it explicitly to retain this binding, or choose another focus shortcut to preserve Windows locking. The autostart script registers application startup entries without changing the lock policy.
