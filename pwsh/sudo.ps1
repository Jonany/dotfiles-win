function sudo {
    param([string]$command)
    Start-Process -FilePath pwsh -Verb RunAs -ArgumentList "-Command $command"
}

function adm {
    param([string]$command)
    Start-Process -FilePath 'wezterm-gui' -Verb RunAs -ArgumentList "--config-file `"$env:XDG_CONFIG_HOME\wezterm.lua`""
}
