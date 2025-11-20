return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="zig cc" && cmake --build build --config Release' },
  },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    --vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>en', function() builtin.find_files({ cwd = vim.fn.stdpath('config') }) end,
      { desc = 'Telescope Neovim config files' })
    vim.keymap.set('n', '<leader>ep',
      function() builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy') }) end,
      { desc = 'Telescope packages files' })

    -- lua\config\telescope\multigrep.lua
    -- Set keymap
    require('config.telescope.multigrep').setup()
  end,
}
