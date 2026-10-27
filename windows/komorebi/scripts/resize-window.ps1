param([ValidateSet('left','down','up','right')][string]$Direction)
$ErrorActionPreference = 'Stop'
$cli = 'D:\komorebi\bin\komorebic.exe'
$mutex = [Threading.Mutex]::new($false, 'Local\KomorebiCenteredResize')
$locked = $false
try {
    $locked = $mutex.WaitOne(3000)
    if (-not $locked) { return }
    $stateText = & $cli state
    if ($LASTEXITCODE -ne 0) { throw 'Cannot read Komorebi state.' }
    $state = ($stateText -join "`n") | ConvertFrom-Json
    $monitorIndex = [int]$state.monitors.focused
    $monitor = $state.monitors.elements[$monitorIndex]
    $workspaceIndex = [int]$monitor.workspaces.focused
    $workspace = $monitor.workspaces.elements[$workspaceIndex]
    if ($state.is_paused -or $null -ne $workspace.maximized_window) { return }
    $count = @($workspace.containers.elements).Count
    if ($count -eq 0 -and $workspace.layer -ne 'Floating') { return }
    if ($count -ne 1 -or $workspace.layer -eq 'Floating' -or $null -ne $workspace.monocle_container) {
        switch ($Direction) {
            'left'  { & $cli resize-edge left increase; & $cli resize-edge right decrease }
            'right' { & $cli resize-edge left decrease; & $cli resize-edge right increase }
            'down'  { & $cli resize-edge up decrease; & $cli resize-edge down increase }
            'up'    { & $cli resize-edge up increase; & $cli resize-edge down decrease }
        }
        return
    }
    $config = [IO.File]::ReadAllText((Join-Path $env:USERPROFILE 'komorebi.json')) | ConvertFrom-Json
    $mc = $config.monitors[$monitorIndex]
    $wc = $mc.workspaces[$workspaceIndex]
    $wp = $config.default_workspace_padding
    if ($null -ne $mc.workspace_padding) { $wp = $mc.workspace_padding }
    if ($null -ne $wc.workspace_padding) { $wp = $wc.workspace_padding }
    $cp = $config.default_container_padding
    if ($null -ne $mc.container_padding) { $cp = $mc.container_padding }
    if ($null -ne $wc.container_padding) { $cp = $wc.container_padding }
    $padding = [int]$wp + [int]$cp + [int]$config.border_width + [int]$config.border_offset
    $availableWidth = [int]$monitor.work_area_size.right - 2 * $padding
    $availableHeight = [int]$monitor.work_area_size.bottom - 2 * $padding
    $offset = $workspace.work_area_offset
    if ($null -eq $offset) { $offset = $wc.work_area_offset }
    $width = $availableWidth - [int]$offset.right
    $height = $availableHeight - [int]$offset.bottom
    switch ($Direction) {
        'left'  { $width -= 50 }
        'right' { $width += 50 }
        'down'  { $height += 50 }
        'up'    { $height -= 50 }
    }
    $width = [Math]::Max([Math]::Min(800, $availableWidth), [Math]::Min($width, $availableWidth))
    $height = [Math]::Max([Math]::Min(500, $availableHeight), [Math]::Min($height, $availableHeight))
    $right = $availableWidth - $width
    $bottom = $availableHeight - $height
    $left = [int][Math]::Floor($right / 2)
    $top = [int][Math]::Floor($bottom / 2)
    & $cli workspace-work-area-offset $monitorIndex $workspaceIndex $left $top $right $bottom
    if ($LASTEXITCODE -ne 0) { throw 'Cannot update the current workspace area.' }
} catch {
    Add-Content -LiteralPath (Join-Path $PSScriptRoot 'resize-errors.log') -Value ((Get-Date).ToString('o') + ' ' + $_.Exception.Message)
} finally {
    if ($locked) { $mutex.ReleaseMutex() }
    $mutex.Dispose()
}