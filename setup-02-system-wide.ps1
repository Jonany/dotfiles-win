#Requires -RunAsAdministrator
# This script is meant to be run on setup to install various tools

Write-Host "Installing system-wide tools"

winget install wez.wezterm
winget install 7zip.7zip
winget install ImageMagick.ImageMagick

Write-Host "Setting up WezTerm shortcut"

$lnkPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WezTerm.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($lnkPath)
$shortcut.Arguments = '--config-file "C:\development\etc\dotfiles-win\wezterm.lua"'
$shortcut.Save()

