Set-Alias -Name ls -Value lsd

# Docker
function dps { docker ps --format '{{json .}}' | ConvertFrom-Json | sort Names | ft Names, Status, Ports, Image }

# dotnet CLI
function dusset { dotnet user-secrets set @args && dusls }
function dusls { dotnet user-secrets list @args }
function dusrm { dotnet user-secrets remove @args && dusls }
function dusinit { dotnet user-secrets init @args }

# Git
function gadd { git add @args && gstat }
function gdiff { git diff @args }
function gstat { git status }

# Lazygit
function lg { lazygit -ucf "$env:XDG_CONFIG_HOME/lazygit/config.yml" }

# etc
function cl { cd @args && ls }
function unzip { Expand-Archive @args }

# Source miscellaneous pwsh functions
gci "$PSScriptRoot/pwsh" -fi *.ps1 | % { . $_.FullName }
