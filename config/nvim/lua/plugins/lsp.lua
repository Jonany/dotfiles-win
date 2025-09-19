return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      require("lspconfig").lua_ls.setup {}

      -- 2025-09-19: Seems to working well enough. I've been able to C# work in nvim the last few days.
      require("lspconfig").csharp_ls.setup({
        cmd = { 'C:/Users/Jonathan.Rigsby/.dotnet/tools/csharp-ls.exe' }
      })

      -- Setup format on save
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- Auto formatting
          if client.supports_method('textDocument/formatting', 0) then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end

          -- Goto Definition
          -- csharp_ls:
          --  2025-09-19:
          --    Works for definitions in current file (ex., variables) and other files in codebase (ex., interfaces).
          --    Does not seem to work for definitions outside of the current solution (?) such as stuff in BuildingBlocks.
          --      I opened up the Live codebase from the root directory and navigated to OrdersCommandsService and then tried to
          --      go to definition on the IAuditSink interface but nothing happened.
          --    Does not work for definitions that need to be decompiled. See 'Goto Type Definition' below.
          if client.supports_method('textDocument/definition', 0) then
            vim.keymap.set("n", "gd", vim.lsp.buf.definition)
          end

          -- Goto Type Definition
          -- This doesn't seem to work in C#. I'm fairly certain it requires decompiling to be working.
          -- https://github.com/razzmatazz/csharp-language-server?tab=readme-ov-file#decompile-for-your-editor--with-the-example-of-neovim
          -- https://github.com/Decodetalkers/csharpls-extended-lsp.nvim
          -- Perhaps also, https://github.com/Hoffs/omnisharp-extended-lsp.nvim
          if client.supports_method('textDocument/typeDefinition', 0) then
            vim.keymap.set("n", "gD", vim.lsp.buf.type_definition)
          end

          -- Goto Implementation
          -- csharp_ls:
          --  2025-09-19:
          --    Worked for finding (some) implementations of IAuditSink. It returned the NullAuditSink and OrderEntityAuditDbSink
          --      in Orders when called from the OrdersCommandsService file.
          --    Oddly enough, it does not work in Contacts. Maybe I'm just not waiting long enough. It seems pretty slow.
          if client.supports_method('textDocument/implementation', 0) then
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
          end
        end,
      })
    end,
  }
}
