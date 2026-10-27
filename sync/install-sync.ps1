# Registers the auto-sync in Windows Task Scheduler: at log-on and every 30 minutes.
# Usage (normal PowerShell, no admin needed):
#   powershell -ExecutionPolicy Bypass -File .\install-sync.ps1 -WorkFolder 'C:\Work\Claude'
# Preview without changing anything:  add -WhatIf
# Remove later:  Unregister-ScheduledTask -TaskName Claude-sync -Confirm:$false
# Keep this file ASCII-only (Windows PowerShell 5.1 reads BOM-less scripts as ANSI).
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)][string]$WorkFolder,
    [string]$DriveCopyName = 'My-Claude',
    [string]$DriveFolder = '',
    [string]$TaskName = 'Claude-sync',
    [int]$EveryMinutes = 30
)

if (-not (Test-Path (Join-Path $WorkFolder '.git'))) {
    throw "$WorkFolder is not a git repository yet. Do step 3 of docs/setup.md first."
}

# sync.ps1 and run-hidden.vbs live in <WorkFolder>\sync (copy them there first)
$vbs = Join-Path $WorkFolder 'sync\run-hidden.vbs'
if (-not (Test-Path $vbs)) { throw "Not found: $vbs. Copy the sync folder into $WorkFolder first." }

$action = New-ScheduledTaskAction -Execute 'wscript.exe' `
    -Argument "`"$vbs`" `"$WorkFolder`" `"$DriveCopyName`" `"$DriveFolder`""
$atLogon = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$repeat  = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) `
    -RepetitionInterval (New-TimeSpan -Minutes $EveryMinutes) `
    -RepetitionDuration (New-TimeSpan -Days 3650)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
    -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 20)

if ($PSCmdlet.ShouldProcess($TaskName, "Register task: every $EveryMinutes min + at log-on, runs $vbs")) {
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger @($atLogon, $repeat) `
        -Settings $settings -Description 'Claude working folder -> GitHub + Google Drive' -Force | Out-Null
    Write-Host "Done. Task '$TaskName' runs every $EveryMinutes minutes. Log: $WorkFolder\sync\sync-log.txt"
}
