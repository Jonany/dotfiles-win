# Custom Functions
## Configure Starship to set the window title to the name of the current directory
function Invoke-Starship-PreCommand {
    $Host.UI.RawUI.WindowTitle = "$(Split-Path -Path (Get-Location) -Leaf)"
}

# Set ENV variables
$env:STARSHIP_CONFIG = "$PSScriptRoot\starship.toml"
$env:USR_BIN = "c:\development\usr-bin"

# Add to PATH
$env:PATH += ";$env:USR_BIN"
$env:PATH += ";$env:USR_BIN\cmake\bin"
$env:PATH += ";$env:USR_BIN\lua-language-server"

# Source autocomplete configs provided by various tools
#   Since these aren't specific to my config, I've chosed to
#   put them in my 'usr-bin' directory.
gci "$env:USR_BIN\autocomplete" -fi *.ps1 | % { . $_.FullName }

