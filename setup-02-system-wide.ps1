#Requires -RunAsAdministrator
# This script is meant to be run on setup to install various tools

Write-Host SETUP:: Installing or updating 'Git.Git'
winget install --id Git.Git -e --source winget

Write-Host SETUP:: Installing or updating 'wez.wezterm'
winget install --id wez.wezterm -e --source winget

Write-Host SETUP:: Installing or updating 'GoLang.Go'
winget install --id GoLang.Go -e --source winget

Write-Host SETUP:: Installing or updating Yazi dependencies
winget install --id 7zip.7zip -e --source winget
winget install --id ImageMagick.ImageMagick -e --source winget

Write-Host SETUP:: Setting up WezTerm shortcut
$lnkPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WezTerm.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($lnkPath)
$shortcut.Arguments = "--config-file `"$env:XDG_CONFIG_HOME\wezterm.lua`""
$shortcut.Save()
