vim.lsp.config['buf_ls'] = {
  -- https://github.com/bufbuild/buf
  cmd = { 'buf', 'lsp', 'serve' },
  filetypes = { 'proto' },
  root_markers = { 'buf.yaml', 'Protos', '.git' },
}
--vim.lsp.config['docker-language-server'] = {
--  cmd = { 'docker-language-server', 'start', '--stdio', '--verbose' },
--  filetypes = { 'dockerfile', 'yaml.docker-compose' },
--  get_language_id = function(_, ftype)
--    if ftype == 'yaml.docker-compose' or ftype:lower():find('ya?ml') then
--      return 'dockercompose'
--    else
--      return ftype
--    end
--  end,
--  root_markers = {
--    'Dockerfile',
--    'docker-compose.yaml',
--    'docker-compose.yml',
--    'compose.yaml',
--    'compose.yml',
--  },
--  settings = {
--    initializationOptions = {
--      dockercomposeExperimental = true,
--    },
--    telemetry = 'off',
--  },
--}

-- there is also https://github.com/docker/docker-language-server
vim.lsp.config['dockerls'] = {
  -- https://github.com/rcjsuen/dockerfile-language-server
  -- `bun install -g dockerfile-language-server-nodejs`
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
    },
  },
}
-- plugin settings in plugins/rosyln.lua
vim.lsp.config['roslyn'] = {
  cmd = {
    'dotnet',
    'C:/util/apps/usr-bin/Microsoft.CodeAnalysis.LanguageServer/content/LanguageServer/win-x64/Microsoft.CodeAnalysis.LanguageServer.dll',
    '--logLevel',              -- this property is required by the server
    'Information',
    '--extensionLogDirectory', -- this property is required by the server
    vim.fs.joinpath(vim.uv.os_tmpdir(), 'roslyn_ls/logs'),
    '--stdio',
  },
  filetypes = { 'cs', 'csproj', 'sln', 'slnx' },
  root_markers = { { '.csproj', '.sln', '.slnx' }, '.git' },
  on_attach = function()
    print('Roslyn is running')
  end,
  settings = {
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
    ['csharp|code_lens'] = {
      dotnet_enable_references_code_lens = true,
      dotnet_enable_tests_code_lens = true,
    },
    ['csharp|background_analysis'] = {
      dotnet_analyzer_diagnostics_scope = 'openFiles',
      dotnet_compiler_diagnostics_scope = 'fullSolution',
    },
    ['csharp|completion'] = {
      dotnet_provide_regex_completions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true,
    },
    ['csharp|symbol_search'] = {
      dotnet_search_reference_assemblies = true,
    },
    ['csharp|formatting'] = {
      dotnet_organize_imports_on_format = true,
    },
  },
}

vim.lsp.config['sqls'] = {
  cmd = { 'sqls', '-config', 'c:/util/src/sqls-config.yml' },
  filetypes = { 'sql', 'mysql' },
  root_markers = { { '.sqlproj', '.sln' }, '.git' },
  on_attach = function()
    print('sqls is running')
  end,
  single_file_support = true,
}

vim.lsp.config['tsgo'] = {
  -- https://github.com/microsoft/typescript-go
  -- `bun install -g @typescript/native-preview`
  cmd = { 'C:/Users/Jonathan.Rigsby/.bun/bin/tsgo.exe', '--lsp', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb',
      'bun.lock', '.git' }
    -- We fallback to the current working directory if no project root is found
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    on_dir(project_root)
  end,
}

vim.lsp.config['yamlls'] = {
  -- Can't seem to get this to work. It always fails to load the schema: Error: unable to get local issuer certificate
  --cmd = { 'bun', 'run', 'c:/development/etc/microsoft/azure-pipelines-language-server/language-server/bin/azure-pipelines-language-server', '--stdio' },

  -- https://github.com/redhat-developer/yaml-language-server
  -- `bun install -g yaml-language-server`
  cmd = { 'C:/Users/Jonathan.Rigsby/.bun/bin/yaml-language-server.exe', '--stdio' },
  filetypes = { 'yaml' },
  root_markers = { 'azure-devops' },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      schemas = {
        ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = {
          '**/azure-devops/*.yml',
        },
      },
      schemaStore = {
        enable = true,
        url = 'https://www.schemastore.org/api/json/catalog.json',
      },
      format = {
        enable = false,
      },
      validate = true,
      hover = true,
      completion = true,
    },
  },
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

vim.lsp.enable('azure_pipelines_ls')
--vim.lsp.enable('buf_ls')
--vim.lsp.enable('docker-language-server')
vim.lsp.enable('dockerls')
vim.lsp.enable('lua-language-server')
vim.lsp.enable('roslyn')
--vim.lsp.enable('sqls')
--vim.lsp.enable('tsgo')
--vim.lsp.enable('yamlls')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    vim.cmd [[set completeopt+=menuone,noselect,popup]]
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
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
