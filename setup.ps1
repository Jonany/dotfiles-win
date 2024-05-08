# Copies a shortcut of WezTerm that uses the config file in this dir
cp -Force .\WezTerm.lnk "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WezTerm.lnk"

# Setup Neovim
mkdir -Force $HOME\AppData\Local\nvim\pack\3rd-party\start\
cp -Force .\init.lua $HOME\AppData\Local\nvim\
# Leaving these commented out because I have already done them
#git clone https://github.com/f-person/auto-dark-mode.nvim.git $HOME\AppData\Local\nvim\pack\3rd-party\start\auto-dark-mode.nvim
#git clone https://github.com/folke/tokyonight.nvim.git $HOME\AppData\Local\nvim\pack\3rd-party\start\tokyonight.nvim
