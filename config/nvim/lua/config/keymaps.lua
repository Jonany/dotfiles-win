-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Run the current file
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
-- Run the current file
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
-- Run the current selection
vim.keymap.set("v", "<leader>x", ":lua<CR>")

