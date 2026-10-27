#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$apps = @(
    @{ Name = 'Komorebi Elevated'; Exe = 'D:\komorebi\bin\komorebic-no-console.exe'; Arguments = 'start --whkd'; Directory = 'D:\komorebi\bin'; RunLevel = 'Highest'; Delay = 'PT5S' },
    @{ Name = 'YASB'; Exe = 'D:\YASB\yasb.exe'; Arguments = ''; Directory = 'D:\YASB'; RunLevel = 'Limited'; Delay = $null }
)
$requiredFiles = @($apps | ForEach-Object { $_.Exe }) + @(
    'D:\komorebi\bin\komorebi.exe',
    'D:\whkd\bin\whkd.exe',
    'D:\THide\thide.exe'
)
foreach ($file in $requiredFiles) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw "Missing executable: $file" }
}

$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -MultipleInstances IgnoreNew -ExecutionTimeLimit ([TimeSpan]::Zero)
foreach ($app in $apps) {
    $actionOptions = @{ Execute = $app.Exe; WorkingDirectory = $app.Directory }
    if ($app.Arguments) { $actionOptions.Argument = $app.Arguments }
    $action = New-ScheduledTaskAction @actionOptions
    $trigger = New-ScheduledTaskTrigger -AtLogOn -User $identity.Name
    if ($app.Delay) { $trigger.Delay = $app.Delay }
    $principal = New-ScheduledTaskPrincipal -UserId $identity.User.Value -LogonType Interactive -RunLevel $app.RunLevel
    Register-ScheduledTask -TaskName $app.Name -TaskPath '\' -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null
    $registered = Get-ScheduledTask -TaskName $app.Name -TaskPath '\'
    if ($registered.Principal.RunLevel.ToString() -ne $app.RunLevel -or $registered.Principal.LogonType.ToString() -ne 'Interactive' -or $registered.State.ToString() -eq 'Disabled') {
        throw "Task verification fails: $($app.Name)"
    }
    $registeredActions = @($registered.Actions)
    $registeredTriggers = @($registered.Triggers)
    if ($registeredActions.Count -ne 1 -or $registeredActions[0].Execute -ne $app.Exe -or [string]$registeredActions[0].Arguments -ne $app.Arguments -or $registeredActions[0].WorkingDirectory -ne $app.Directory) {
        throw "Task action verification fails: $($app.Name)"
    }
    if ($registeredTriggers.Count -ne 1 -or -not $registeredTriggers[0].Enabled -or $registeredTriggers[0].CimClass.CimClassName -ne 'MSFT_TaskLogonTrigger' -or ($app.Delay -and $registeredTriggers[0].Delay -ne $app.Delay) -or (-not $app.Delay -and $registeredTriggers[0].Delay -and $registeredTriggers[0].Delay -ne 'PT0S')) {
        throw "Task trigger verification fails: $($app.Name)"
    }
    Write-Output "Registered: $($app.Name) / $($app.RunLevel)"
}

$runPath = $identity.User.Value + '\Software\Microsoft\Windows\CurrentVersion\Run'
$runKey = [Microsoft.Win32.Registry]::Users.CreateSubKey($runPath)
$thideCommand = '"D:\THide\thide.exe" start'
try {
    $runKey.SetValue('THide', $thideCommand, [Microsoft.Win32.RegistryValueKind]::String)
    $runKey.Flush()
    if ($runKey.GetValue('THide', $null) -ne $thideCommand) { throw 'THide Run entry verification fails.' }
} finally {
    $runKey.Dispose()
}
Write-Output 'Registered: THide / current-user Run / normal privileges'
