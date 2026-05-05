return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install {
        'c',
        'c_sharp',
        'csv',
        'diff',
        'dockerfile',
        'editorconfig',
        'gitignore',
        'go',
        'gomod',
        'gosum',
        'html',
        'javascript',
        'jq',
        'jsdoc',
        'json',
        'jsonc',
        'lua',
        'markdown',
        'markdown_inline',
        'powershell',
        'psv',
        'query',
        'sql',
        'toml',
        'tsv',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
      }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(args)
          local max_filesize = 1000000 -- 1 MB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
          if ok and stats and stats.size > max_filesize then return end
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
