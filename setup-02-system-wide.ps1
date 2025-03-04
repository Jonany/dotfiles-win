#Requires -RunAsAdministrator
# This script is meant to be run on setup to install various tools

Write-Host SETUP:: Installing or updating 'wez.wezterm'
winget install wez.wezterm

Write-Host SETUP:: Installing or updating 'GoLang.Go'
winget install GoLang.Go

Write-Host SETUP:: Installing or updating Yazi dependencies
winget install 7zip.7zip
winget install ImageMagick.ImageMagick

Write-Host SETUP:: Setting up WezTerm shortcut
$lnkPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WezTerm.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($lnkPath)
$shortcut.Arguments = '--config-file "C:\development\etc\dotfiles-win\wezterm.lua"'
$shortcut.Save()

