#Requires -RunAsAdministrator
# This script is meant to be run on setup to install various tools

# 1. Download all the packages in 'package-list'
# 2. Run installers as ADM.

# 3. Setup WezTerm shortcut
Write-Host `nSETUP:: Setting up WezTerm shortcut
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WezTerm.lnk")
$shortcut.TargetPath = "c:\util\apps\usr-bin\wezterm-nightly\wezterm-gui.exe"
$shortcut.Arguments = "--config-file `"c:\util\src\etc\dotfiles-win\config\wezterm.lua`""
$shortcut.WorkingDirectory = "c:\util\apps\usr-bin\wezterm-nightly"
$shortcut.Save()
Write-Host SETUP:: Created shortcut with the following properties:
Write-Host `t- TargetPath: "$($shortcut.TargetPath)"
Write-Host `t- Arguments: "$($shortcut.Arguments)"
Write-Host `t- WorkingDirectory: "$($shortcut.WorkingDirectory)"

# 4. Setup PWSH profile
Write-Host `nSETUP:: Setting up Powershell Profile
cp -Verbose "$(Get-Location)\pwsh_rc.ps1" 'C:\Program Files\PowerShell\7\Profile.ps1'

