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
vim.lsp.config["csharp_ls"] = {
  cmd = { 'C:/Users/Jonathan.Rigsby/.dotnet/tools/csharp-ls.exe' },
  filetypes = { 'cs', 'csproj' },
  root_markers = { { '.csproj', '.sln' }, '.git' },
}

vim.lsp.enable("lua-language-server")
vim.lsp.enable("csharp_ls")

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
