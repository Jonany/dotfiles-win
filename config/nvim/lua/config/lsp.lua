--vim.lsp.config["docker-language-server"] = {
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
--    telemetry = "off",
--  },
--}
vim.lsp.config["dockerls"] = {
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

vim.lsp.config["lua-language-server"] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      }
    }
  },
}
-- plugin settings in plugins/rosyln.lua
vim.lsp.config["roslyn"] = {
  cmd = {
    "dotnet",
    "C:/development/usr-bin/Microsoft.CodeAnalysis.LanguageServer/content/LanguageServer/win-x64/Microsoft.CodeAnalysis.LanguageServer.dll",
    "--logLevel",              -- this property is required by the server
    "Information",
    "--extensionLogDirectory", -- this property is required by the server
    vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn_ls/logs"),
    "--stdio",
  },
  filetypes = { 'cs', 'csproj' },
  root_markers = { { '.csproj', '.sln' }, '.git' },
  on_attach = function()
    print("This will run when the server attaches!")
  end,
  settings = {
    ["csharp|inlay_hints"] = {
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
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
      dotnet_enable_tests_code_lens = true,
    },
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "fullSolution",
    },
    ["csharp|completion"] = {
      dotnet_provide_regex_completions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true,
    },
    ["csharp|symbol_search"] = {
      dotnet_search_reference_assemblies = true,
    },
    ["csharp|formatting"] = {
      dotnet_organize_imports_on_format = true,
    },
  }
}

vim.lsp.config["yamlls"] = {
  -- Can't seem to get this to work. It always fails to load the schema: Error: unable to get local issuer certificate
  --cmd = { 'bun', 'run', 'c:/development/etc/microsoft/azure-pipelines-language-server/language-server/bin/azure-pipelines-language-server', '--stdio' },
  cmd = { 'C:/Users/Jonathan.Rigsby/.bun/bin/yaml-language-server.exe', '--stdio' },
  filetypes = { 'yaml' },
  root_markers = { 'azure-devops' },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
          "**/azure-devops/*.yml",
        },
      },
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
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

--vim.lsp.enable("docker-language-server")
vim.lsp.enable("dockerls")
vim.lsp.enable("lua-language-server")
vim.lsp.enable("roslyn")
--vim.lsp.enable("yamlls")

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    vim.cmd [[set completeopt+=menuone,noselect,popup]]
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
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

--These GLOBAL keymaps are created unconditionally when Nvim starts:
--- "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
--- "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
--- "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
--- "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
--- "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
--- "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
--- CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
