# Custom Functions
## Configure Starship to set the window title to the name of the current directory
function Invoke-Starship-PreCommand {
    $Host.UI.RawUI.WindowTitle = "$(Split-Path -Path (Get-Location) -Leaf)"
}

# Set ENV variables
## NOTE: neovim picks up on this and will use it as its config path.
$env:XDG_CONFIG_HOME = "$PSScriptRoot\config"
$env:STARSHIP_CONFIG = "$env:XDG_CONFIG_HOME\starship.toml"
$env:EDITOR = "nvim"
#$env:SHELL = "pwsh"
$env:YAZI_CONFIG_HOME = "$env:XDG_CONFIG_HOME\yazi"
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$env:USR_BIN = "c:\development\usr-bin"
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
$env:POWERSHELL_TELEMETRY_OPTOUT = '1'

# Add to PATH
$env:PATH += ";$env:USR_BIN"
$env:PATH += ";$env:USR_BIN\cmake\bin"
$env:PATH += ";$env:USR_BIN\lua-language-server\bin"

# Fast Node Manager setup
#try {
#    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
#}
#catch {
#    Write-Host "Unable to setup fnm env."
#}
# Source autocomplete configs provided by various tools
#   Since these aren't specific to my config, I've chosed to
#   put them in my 'usr-bin' directory.
#gci "$env:USR_BIN\autocomplete" -fi *.ps1 | % { . $_.FullName }

