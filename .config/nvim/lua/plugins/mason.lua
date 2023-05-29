return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
  },
  build = function()
    pcall(vim.cmd, "MasonUpdate") -- TODO: disable lua_ls warning
  end,
  cmd = "Mason",
  event = "BufReadPre",
  config = function()
    -- Using protected call
    local mason_ok, mason = pcall(require, "mason")
    if not mason_ok then
      return
    end
    local mason_lspcfg_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not mason_lspcfg_ok then
      return
    end

    -- Seeting up Mason
    mason.setup({
      PATH = "append",
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
    })

    -- Using protected call
    local lsp_ok, lspconfig = pcall(require, "lspconfig")
    if not lsp_ok then
      return
    end
    local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if not cmp_nvim_lsp_ok then
      return
    end
    local typescript_ok, typescript = pcall(require, "typescript")
    if not typescript_ok then
      return
    end

    -- Setting up capabilities
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local ih = require("inlay-hints")
    -- Setting up on_attach
    local on_attach = function(client, bufnr)
      local opts = { silent = true, buffer = bufnr }
      ih.on_attach(client, bufnr)

      -- Setting keymaps for lsp
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "df", vim.diagnostic.open_float, opts)
      vim.keymap.set("n", "gn", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)
      vim.keymap.set("n", "<leader>li", vim.cmd.LspInfo, opts)

      -- Typescript specific settings
      if client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
        vim.keymap.set("n", "<leader>lR", vim.cmd.TypescriptRenameFile, opts)
      end
    end

    -- Setting up lua server
    -- lspconfig.lua_ls.setup({
    --   on_attach = on_attach,
    --   capabilities = capabilities,
    --   settings = {
    --     Lua = {
    --       diagnostics = {
    --         globals = { "vim" },
    --       },
    --       workspace = {
    --         library = {
    --           [vim.fn.expand("$VIMRUNTIME/lua")] = true,
    --           [vim.fn.stdpath("config") .. "/lua"] = true,
    --         },
    --       },
    --     },
    --   },
    -- })
    --
    -- Setting up ts server
    -- typescript.setup({
    --   server = {
    --     on_attach = on_attach,
    --     capabilities = capabilities,
    --   },
    -- })

    -- --Setting up rust toolr
    -- require("rust-tools").setup({
    --   on_attach = on_attach,
    --   capabilities = capabilities,
    -- })
    --

    -- -- Setting up Mason LSP Bridged
    require("mason-lspconfig").setup {
      ensure_installed = { "lua_ls", "rust_analyzer" },
    }

    require("mason-lspconfig").setup_handlers {
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
          on_attach = on_attach,
          capabilities = capabilities,

        }
      end,
      -- Next, you can provide a dedicated handler for specific servers.
      -- For example, a handler override for the `rust_analyzer`:
      ["rust_analyzer"] = function()
        require("rust-tools").setup {

          tools = {
            on_initialized = function()
              ih.set_all()
            end,
            inlay_hints = {
              auto = true,
            },
          },
          checkOnSave = {
            command = "clippy" },
          server = {
            on_attach = on_attach,
            capabilities = capabilities,
          },
        }
      end,
      ["lua_ls"] = function()
        lspconfig.lua_ls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            Lua = {
              hint = { enable = true

              },
              diagnostics = {
                globals = { "vim" }
              }
            }
          }
        }
      end,
    }
    -- Setting up keymaps
    vim.keymap.set("n", "<leader>lI", vim.cmd.Mason, { silent = true })
  end,
}
