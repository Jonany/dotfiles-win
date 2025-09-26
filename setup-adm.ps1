#Requires -RunAsAdministrator
# This script is meant to be run on setup to install various tools

# 1. Download all the packages in 'package-list'
# 2. Run installers as ADM.

# 3. Setup WezTerm shortcut
#   2025-09-19: This is still needed
Write-Host SETUP:: Setting up WezTerm shortcut
$lnkPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WezTerm.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($lnkPath)
$shortcut.TargetPath = "$env:USR_BIN\wezterm\wezterm-gui.exe"
$shortcut.Arguments = "--config-file `"$env:XDG_CONFIG_HOME\wezterm.lua`""
$shortcut.WorkingDirectory = "$env:USR_BIN\wezterm"
$shortcut.Save()

# 4. Setup PWSH profile?
#  2025-09-19: This is untested.
#    The goal is to end up with something like this in the 'Profile.ps1' file: `. "c:\development\etc\dotfiles-win\pwsh_rc.ps1"`
#    This will evaluate the pwsh_rc file which in turn will load a bunch of other stuff.
#    I'm thinking about writing a script to dump all this stuff in the Profile file instead of referencing files in
#    my dotfiles repo. I think it would speed load times.
#echo ". $PSScriptRoot\pwsh_rc.ps1" > 'C:\Program Files\PowerShell\7\Profile.ps1'
#echo ". $PSScriptRoot\pwsh_rc.ps1" > 'C:\Program Files\PowerShell\7-preview\Profile.ps1'


# 2025-07-31: Had some issues with running winget as adm. This fixed it. Got these from CoPilot.
# Looks like it adds the winget source manifest file and then reset and updates.
# All the AV really hate ADM winget so it takes forever to do stuff.
#  Add-AppxPackage -DisableDevelopmentMode -Register (Resolve-Path "C:\Program Files\WindowsApps\Microsoft.Winget.Source_*\\AppXManifest.xml") -Verbose
#  winget source reset
#  winget source update

