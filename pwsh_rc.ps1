. "$PSScriptRoot\pwsh_profile.ps1"
. "$PSScriptRoot\pwsh_aliases.ps1"

# Launch Starship
Invoke-Expression (&starship init powershell)
