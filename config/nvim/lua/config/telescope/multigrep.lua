local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values

local live_multigrep = function(opts)
  opts = opts or {}
  opts.args = opts.args or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end
      local pieces = vim.split(prompt, '  ')
      local promptArgs = { 'rg' }
      if pieces[1] then
        table.insert(promptArgs, '-e')
        table.insert(promptArgs, pieces[1])
      end

      if #pieces > 1 then
        _ = table.remove(pieces, 1)
        for _, arg_piece in ipairs(pieces) do
          table.insert(promptArgs, '-g')
          table.insert(promptArgs, arg_piece)
        end
      end

      return vim.tbl_flatten {
        opts.args,
        promptArgs,
        { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--glob-case-insensitive' },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers.new(opts, {
    debounce = 100,
    prompt_title = 'Multi Grep',
    finder = finder,
    previewer = conf.grep_previewer(opts),
    sorter = require('telescope.sorters').empty(),
  }):find()
end

return {
  setup = function()
    vim.keymap.set('n', '<leader>fg', live_multigrep)
    -- Doesn't return any results
    --vim.keymap.set('n', '<leader>fs', function() live_multigrep({ args = { '--sorted=path', }, }) end)
  end
}
