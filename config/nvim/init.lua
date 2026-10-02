require('vim._core.ui2').enable()

-- *****************
-- * AUTO COMMANDS *
-- *****************
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function ()
    vim.bo.commentstring = "/// %s"
  end
})

-- ***********
-- * KEYMAPS *
-- ***********
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Run the current file
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>')
-- Run the current file
vim.keymap.set('n', '<leader>x', ':.lua<CR>')
-- Run the current selection
vim.keymap.set('v', '<leader>x', ':lua<CR>')

vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set('n', '<leader>wq', ':wq<CR>')
vim.keymap.set('n', '<leader>e', ':Ex<CR>')

-- delete means delete not cut
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })
vim.keymap.set('x', 'p', '"_dP', { noremap = true })
--vim.keymap.set('v', 'iwp', 'iw"_dP', { noremap = true, })

-- ***********
-- * OPTIONS *
-- ***********
-- Spacing set with ~/.editorconfig
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 999
-- highlight the row the cursor is on
vim.opt.cursorline = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.termguicolors = true
vim.opt.background = 'dark'

vim.g.nofsync = true
vim.cmd [[set autocomplete]]

-- *******
-- * LSP *
-- *******
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- autocomplete
    vim.cmd [[set completeopt+=menuone,noselect,popup]]
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
    end

    -- inlay hints
    -- if client:supports_method('textDocument/inlayHint') then
    --   vim.lsp.inlay_hint.enable(true, { bufnr = args.buf, })
    -- end

    -- linkedEditingRange. ex., opening/closing tags in HTML
    if client:supports_method('textDocument/linkedEditingRange') then
      vim.lsp.linked_editing_range.enable(true, { client_id = client.id, })
    end

    -- codeLens
    if client:supports_method('textDocument/codeLens') then
      vim.lsp.codelens.enable(true, { bufnr = args.buf, })
    end

    -- Auto-format ('lint') on save.
    -- Usually not needed if server supports 'textDocument/willSaveWaitUntil'.
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

vim.lsp.config['angularls'] = {
  -- Manually building cmd so that we can include project node_modules for tsProbeLocations
  cmd = function(dispatchers, config)
    local root_dir = (config and config.root_dir) or vim.fn.getcwd()

    local cmd = {
      'C:/Users/Jonathan.Rigsby/AppData/Roaming/npm/ngserver',
      '--stdio',
      '--tsProbeLocations', vim.fs.joinpath(root_dir, 'node_modules/typescript'),
      '--ngProbeLocations',
      'C:/Users/Jonathan.Rigsby/AppData/Roaming/npm/node_modules/@angular/language-server/node_modules',
      '--angularCoreVersion', '21.2.14',
    }
    return vim.lsp.rpc.start(cmd, dispatchers)
  end,
  root_markers = { 'angular.json', },
  filetypes = { 'typescript', 'html', 'htmlangular' },
}

vim.lsp.config['azure_pipelines_ls'] = {
  -- https://github.com/microsoft/azure-pipelines-language-server
  -- `bun install -g azure-pipelines-language-server`
  cmd = { 'C:/Users/Jonathan.Rigsby/.bun/bin/azure-pipelines-language-server.exe', '--stdio' },
  cmd_env = { NODE_TLS_REJECT_UNAUTHORIZED = 0 },
  filetypes = { 'yaml' },
  root_markers = { 'azure-devops' },
  settings = {
    yaml = {
      schemas = {
        ['file:///C:/util/apps/usr-bin/azure-pipelines/service-schema.json'] = {
          '**/azure-devops/*.yml',
          '**/azure-devops/*.yaml',
        },
      },
    },
  },
}

vim.lsp.config['dockerls'] = {
  -- https://github.com/rcjsuen/dockerfile-language-server
  -- `bun install -g dockerfile-language-server-nodejs`
  -- there is also https://github.com/docker/docker-language-server
  cmd = { 'c:/users/jonathan.rigsby/.bun/bin/docker-langserver.exe', '--stdio' },
  filetypes = { 'dockerfile' },
  root_markers = { 'Dockerfile' },
  settings = {
    docker = {
      formatter = {
        ignoreMultilineInstructions = false,
      },
    },
  },
}

vim.lsp.config['lua-language-server'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      codeLens = { enable = true },
    },
  },
}

vim.lsp.config['roslyn'] = {
  -- see companion plugin 'seblyng/roslyn.nvim' below
  -- see also: https://github.com/zed-industries/zed/blob/main/docs/src/languages/csharp.md
  -- see also: https://github.com/seblyng/roslyn.nvim
  -- see also: https://github.com/dotnet/roslyn/blob/main/src/LanguageServer/roslyn-language-server/README.md
  cmd = {
    -- 'dotnet',
    -- 'D:/Development/apps/usr-bin/Microsoft.CodeAnalysis.LanguageServer/content/LanguageServer/win-x64/Microsoft.CodeAnalysis.LanguageServer.dll',
    -- 2026-09-29: Switching to this .NET tool. It wraps the 'Microsoft.CodeAnalysis.LanguageServer' executable and is apparently what MSFT plans to be the primary tool in future.
    'roslyn-language-server',

    -- this property is required by the server
    '--logLevel',
    'Information',

    -- this property is required by the server
    '--extensionLogDirectory',
    vim.fs.joinpath(vim.uv.os_tmpdir(), 'roslyn_ls/logs'),

    -- Allow connecting to (or starting) a shared, multi-client language server daemon instead of launching a dedicated language-server child process for that client.
    '--daemon-mode',
    -- How long to keep the daemon alive for after the last client disconnects. 900 seconds is the default.
    '--daemonKeepAlive',
    '900',

    '--telemetryLevel',
    'off',

    -- Automatically discover and load projects based on workspace folders (default: false)
    -- Invalid integer value 'false' for --autoLoadProjects.
    -- '--autoLoadProjects',
    '--stdio',
  },
  filetypes = { 'cs', 'csproj', 'sln', 'slnx', },
  root_markers = { { '.csproj', '.sln', '.slnx', }, '.git', },
  on_attach = function() print('Roslyn is running') end,
  settings = {
    -- 'csharp|auto_insert.dotnet_enable_auto_insert',
    ['csharp|background_analysis'] = {
      -- 2026-09-29: Setting both of these to 'fullSolution' to try to get my 'fdae' and 'fdaw' commands to show all errors/warnings.
      dotnet_analyzer_diagnostics_scope = 'fullSolution', -- openFiles|fullSolution|none
      dotnet_compiler_diagnostics_scope = 'fullSolution', -- openFiles|fullSolution|none
    },
    ['csharp|code_lens'] = {
      -- I disabled both of these because I never really found them helpful. There is no way to interact with them.
      dotnet_enable_references_code_lens = false,
      dotnet_enable_tests_code_lens = false,
    },
    ['csharp|completion'] = {
      -- Show regular expressions in completion list.
      dotnet_provide_regex_completions = true,
      -- Enables support for showing unimported types and unimported extension methods in completion lists.
      dotnet_show_completion_items_from_unimported_namespaces = false,
      -- Perform automatic object name completion for the members that you have recently selected.
      dotnet_show_name_completion_suggestions = false,
    },
    ['csharp|inlay_hints'] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_indexer_parameters = true,
      dotnet_enable_inlay_hints_for_literal_parameters = true,
      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
      dotnet_enable_inlay_hints_for_other_parameters = true,
      dotnet_enable_inlay_hints_for_parameters = true,
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
    },
    ['csharp|navigation'] = {
      dotnet_navigate_to_decompiled_sources = true,
      dotnet_navigate_to_source_link_and_embedded_sources = true,
    },
    ['csharp|formatting'] = {
      dotnet_organize_imports_on_format = true,
    },
    ['csharp|symbol_search'] = {
      dotnet_search_reference_assemblies = true,
    },
    ['csharp|type_members'] = {
      -- atTheEnd: Inserts new members at the end of the type definition.
      -- withOtherMembersOfTheSameKind: Inserts new members alongside other existing members of the same type (e.g., inserting a new property next to existing properties).
      dotnet_member_insertion_location = 'withOtherMembersOfTheSameKind',

      -- preferAutoProperties|preferThrowingProperties
      dotnet_property_generation_behavior = 'preferAutoProperties',
    },
  },
}

vim.lsp.config['tsgo'] = {
  -- https://github.com/microsoft/typescript-go
  -- `bun install -g @typescript/native-preview`
  cmd = { 'C:/Users/Jonathan.Rigsby/.bun/bin/tsgo.exe', '--lsp', '--stdio' },
  filetypes = {
    'javascript',
    'typescript',
  },
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = {
          enabled = 'all',
          suppressWhenArgumentMatchesName = false,
        },
        parameterTypes = { enabled = true },
        variableTypes = {
          enabled = true,
          suppressWhenTypeMatchesName = false,
        },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'tsconfig.json', }
    -- We fallback to the current working directory if no project root is found
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
    on_dir(project_root)
  end,
}

vim.lsp.enable({ 'angularls', 'azure_pipelines_ls', 'dockerls', 'lua-language-server', 'roslyn', 'tsgo', })

-- ***********
-- * PLUGINS *
-- ***********
vim.pack.add({
  { src = 'https://github.com/f-person/auto-dark-mode.nvim', },
  { src = 'https://github.com/nvim-mini/mini.statusline', },
  { src = 'https://github.com/nvim-mini/mini.pick', },
  { src = 'https://github.com/seblyng/roslyn.nvim', },
  { src = 'https://github.com/folke/tokyonight.nvim', },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main', },
})
require('auto-dark-mode').setup({
  update_interval = 1000,
  set_dark_mode = function()
    vim.api.nvim_set_option_value('background', 'dark', {})
    vim.cmd('colorscheme tokyonight-night')
  end,
  set_light_mode = function()
    vim.api.nvim_set_option_value('background', 'light', {})
    vim.cmd('colorscheme tokyonight-day')
  end,
})
require('roslyn').setup({
  filewatching = 'roslyn',
  choose_target = nil,
  ignore_target = nil,
  broad_search = false,
  lock_target = false,
  silent = false,
})
require('mini.statusline').setup()

local mini_pick = require('mini.pick')
mini_pick.setup({
  options = {
    content_from_bottom = true,
  },
  window = {
    config = function()
      -- 2/3 of the screen
      local height = math.floor(0.66 * vim.o.lines)
      local width = math.floor(0.66 * vim.o.columns)
      return {
        anchor = 'NW',
        height = height,
        width = width,
        -- center window
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end,
  },
  layout = {
    preset = 'vertical',
  },
})
vim.keymap.set("n", "<leader>fg", function() mini_pick.builtin.grep_live() end, { desc = "Multi Grep (rg)" })
vim.keymap.set('n', '<leader>ff', function() mini_pick.builtin.files({ tool = 'fd' }) end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fh', function() mini_pick.builtin.help() end, { desc = 'Help' })

vim.cmd('colorscheme tokyonight-day')
require('nvim-treesitter').setup({ install_dir = vim.fn.stdpath('data') .. '/site', })
require('nvim-treesitter').install({
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
}):wait(300000)
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(args)
    local max_filesize = 1000000 -- 1 MB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then return end
    pcall(vim.treesitter.start)
  end,
})
