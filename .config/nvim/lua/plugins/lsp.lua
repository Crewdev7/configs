return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "jose-elias-alvarez/typescript.nvim",
    "simrat39/rust-tools.nvim",
    "Maan2003/lsp_lines.nvim",
  },
  config = function()
    local status_ok, lsp_lines = pcall(require, "lsp_lines")
    if not status_ok then
      return
    end

    lsp_lines.setup()
    vim.diagnostic.config({ virtual_text = false })

    -- Setting up icons for diagnostics
    local signs = { Error = "✘ ", Warn = "▲ ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end,
}
