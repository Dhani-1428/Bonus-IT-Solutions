# Auto-commit and push script
# This script watches for file changes and automatically commits and pushes them

$repoPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoPath

Write-Host "Starting auto-commit and push watcher..." -ForegroundColor Green
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

# Function to commit and push changes
function Commit-And-Push {
    $status = git status --porcelain
    if ($status) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Changes detected, committing and pushing..." -ForegroundColor Cyan
        git add .
        git commit -m "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git push origin main
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Changes pushed successfully!" -ForegroundColor Green
        Write-Host ""
    }
}

# Initial commit check
Commit-And-Push

# Watch for file changes
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repoPath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName

# Exclude .git directory
$watcher.Filter = "*.*"

$action = {
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    
    # Skip .git directory
    if ($path -notlike "*\.git\*") {
        Start-Sleep -Seconds 2  # Wait for file operations to complete
        Commit-And-Push
    }
}

Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $action | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action $action | Out-Null
Register-ObjectEvent -InputObject $watcher -EventName "Deleted" -Action $action | Out-Null

try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
} finally {
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    Write-Host "Watcher stopped." -ForegroundColor Yellow
}
