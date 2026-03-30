return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.2.1',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build =
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="zig cc" && cmake --build build --config Release'
    },
  },
  config = function()
    -- Customizations
    local actions = require('telescope.actions')
    local action_layout = require("telescope.actions.layout")
    require("telescope").setup {
      defaults = {
        --path_display = { shorten = { len = 1, exclude = { -1, -2 } } },
        path_display = { "filename_first" },
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            preview_height = function(_, _, max_lines) return math.max(math.floor(max_lines * 0.66), 15) end,
          },
        },
        mappings = {
          n = {
            -- M == meta/alt
            ["<M-p>"] = action_layout.toggle_preview,
          },
          i = {
            ["<M-p>"] = action_layout.toggle_preview,
          },
        },
      },
      pickers = {
        buffers = {
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
            },
          },
        },
      },
    }

    -- Keymaps
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    --vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb',
      function()
        builtin.buffers({ show_all_buffers = false, path_display = { "filename_first" }, })
      end,
      { desc = 'Telescope buffers' }
    )
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    --vim.keymap.set('n', '<leader>en', function() builtin.find_files({ cwd = vim.fn.stdpath('config') }) end,
    --  { desc = 'Telescope Neovim config files' })
    --vim.keymap.set('n', '<leader>ep',
    --  function() builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy') }) end,
    --  { desc = 'Telescope packages files' })

    -- lua\config\telescope\multigrep.lua
    -- Set keymap
    require('config.telescope.multigrep').setup()
  end,
}
