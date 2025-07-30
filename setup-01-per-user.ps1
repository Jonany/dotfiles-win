# This script is meant to be run on setup to install various tools


Write-Host SETUP:: Installing or updating 'sxyazi.yazi' and dependencies
winget install --id sxyazi.yazi
winget install --id Gyan.FFmpeg
winget install --id jqlang.jq
winget install --id sharkdp.fd
winget install --id BurntSushi.ripgrep.MSVC
winget install --id junegunn.fzf
winget install --id ajeetdsouza.zoxide

Write-Host SETUP:: Installing or updating 'uutils.coreutils'
winget install --id uutils.coreutils

Write-Host SETUP:: Installing or updating 'jftuga.less'
winget install jftuga.less

Write-Host SETUP:: Installing or updating 'shenwei356/rush' via 'go install'
go install github.com/shenwei356/rush@latest
