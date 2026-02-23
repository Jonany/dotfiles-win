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

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>wq", ":wq<CR>")
vim.keymap.set("n", "<leader>e", ":Ex<CR>")

-- delete means delete not cut
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { noremap = true, })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true, })
vim.keymap.set('x', 'p', '"_dP', { noremap = true })
--vim.keymap.set('v', 'iwp', 'iw"_dP', { noremap = true, })
