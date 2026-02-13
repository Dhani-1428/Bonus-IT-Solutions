# Automatic Git Push Setup

This repository has been configured to automatically push changes to GitHub.

## How It Works

### Option 1: Auto-Push After Commits (Recommended)
A git hook has been set up that automatically pushes to GitHub after every commit you make.

**To use:**
1. Simply commit your changes as usual:
   ```bash
   git add .
   git commit -m "Your commit message"
   ```
2. The changes will automatically be pushed to GitHub!

### Option 2: Continuous File Watcher
If you want automatic commits AND pushes whenever you save a file, you can run the file watcher script:

**To use:**
1. Open PowerShell in the project directory
2. Run:
   ```powershell
   .\auto-push.ps1
   ```
3. The script will watch for file changes and automatically commit and push them
4. Press `Ctrl+C` to stop the watcher

**Note:** The file watcher will create commits with timestamps. Use this if you want fully automatic commits without manual git commands.

## Disabling Auto-Push

If you want to disable the auto-push hook:
1. Delete or rename the file: `.git/hooks/post-commit`
2. Or comment out the `git push` line in the hook file

## Manual Push (if needed)

You can still push manually anytime:
```bash
git push origin main
```
