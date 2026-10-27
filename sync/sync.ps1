# Auto-sync of the Claude working folder -> private GitHub repo + Google Drive (Drive for desktop).
# Run by Windows Task Scheduler every 30 min (see install-sync.ps1). Log: <WorkFolder>\sync\sync-log.txt
# Keep this file ASCII-only: Windows PowerShell 5.1 reads BOM-less scripts in the ANSI code page.
param(
    # The folder you open in Claude Code. Must already be a git repo with a remote (see docs/setup.md).
    [string]$WorkFolder = 'C:\Work\Claude',
    # Name of the copy inside "My Drive".
    [string]$DriveCopyName = 'My-Claude',
    # Optional: full path of your "My Drive" folder (e.g. 'G:\My Drive'). Not given = detect automatically.
    [string]$DriveFolder = '',
    # Skip the Google Drive step entirely.
    [switch]$NoDrive
)
$ErrorActionPreference = 'Continue'
$root = $WorkFolder
$log  = Join-Path $root 'sync\sync-log.txt'
function Log($m) { "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $m" | Out-File $log -Append -Encoding utf8 }

# Keep the log at ~500 lines max
if ((Test-Path $log) -and (Get-Content $log).Count -gt 500) {
    (Get-Content $log | Select-Object -Last 300) | Set-Content $log -Encoding utf8
}

Set-Location $root

# --- 0. Copy Claude Code's own memory into memory\code (so it reaches GitHub and Google Drive) ---
# Claude Code keeps it in ~\.claude\projects\<folder path with every non-letter/digit replaced by '-'>\memory
$projectId = $root -replace '[^A-Za-z0-9]', '-'
$mem = Join-Path $env:USERPROFILE ".claude\projects\$projectId\memory"
if (Test-Path $mem) {
    robocopy $mem (Join-Path $root 'memory\code') /MIR /R:1 /W:1 /NFL /NDL /NJH /NJS /NP | Out-Null
    if ($LASTEXITCODE -ge 8) { Log "Claude Code memory: copy error (code $LASTEXITCODE)" }
}

# --- 1. GitHub ---
if ((Test-Path (Join-Path $root '.git\rebase-merge')) -or (Test-Path (Join-Path $root '.git\rebase-apply'))) {
    Log 'WARNING: unfinished rebase (conflict). Ask Claude to resolve it. Sync skipped.'
} else {
    git add -A 2>&1 | Out-Null
    git diff --cached --quiet
    if ($LASTEXITCODE -ne 0) {
        git commit -q -m "auto-sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')" 2>&1 | Out-Null
    }
    $pull = git pull --rebase -q 2>&1
    if ($LASTEXITCODE -ne 0) {
        git rebase --abort 2>&1 | Out-Null
        Log "CONFLICT: the same file changed here and on GitHub. Nothing is lost. Ask Claude to resolve it. $pull"
    } else {
        $push = git push -q 2>&1
        if ($LASTEXITCODE -ne 0) { Log "GitHub push error: $push" } else { Log 'GitHub: OK' }
    }
}

# --- 2. Google Drive (if Google Drive for desktop is installed) ---
# WARNING: /MIR makes the Drive copy an exact mirror - anything added there by hand is deleted.
# That is why claude.ai writes to the separate "Claude-memory" folder, never into this copy.
if (-not $NoDrive) {
    $drive = $DriveFolder
    if (-not $drive) {
        # Drive for desktop mounts a disk whose root holds the hidden '.shortcut-targets-by-id'
        # and one visible folder: "My Drive" in your Windows language (plus "Shared drives" for Workspace).
        $driveRoot = Get-PSDrive -PSProvider FileSystem |
            Where-Object { Test-Path (Join-Path $_.Root '.shortcut-targets-by-id') } |
            Select-Object -First 1 -ExpandProperty Root
        if ($driveRoot) {
            $visible = @(Get-ChildItem $driveRoot -Directory -ErrorAction SilentlyContinue |
                Where-Object { -not ($_.Attributes -band [IO.FileAttributes]::Hidden) })
            $named = $visible | Where-Object { $_.Name -eq 'My Drive' } | Select-Object -First 1
            if ($named) { $drive = $named.FullName }
            elseif ($visible.Count -eq 1) { $drive = $visible[0].FullName }
            else { Log 'Google Drive: several folders found - pass -DriveFolder explicitly' }
        }
    }
    if ($drive) {
        $dst = Join-Path $drive $DriveCopyName
        robocopy $root $dst /MIR /R:1 /W:1 /NFL /NDL /NJH /NJS /NP `
            /XD .venv venv build .gradle .git __pycache__ .idea node_modules `
            /XF .env .env.* *.env *.session *.session-journal *.key *.key.pub *.pem *.jks *.keystore settings.local.json sync-log.txt | Out-Null
        if ($LASTEXITCODE -lt 8) { Log 'Google Drive: OK' } else { Log "Google Drive: error (code $LASTEXITCODE)" }
    }
}
