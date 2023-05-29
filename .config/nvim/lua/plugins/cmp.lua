return {
  "hrsh7th/nvim-cmp",

  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },

    { "kristijanhusak/vim-dadbod-completion" },
    { "tpope/vim-dadbod" },
    {
      "L3MON4D3/LuaSnip",
      event = "InsertCharPre",
      dependencies = "rafamadriz/friendly-snippets",
    },
  },
  event = {
    "InsertEnter",
    "CmdlineEnter",
  },
  config = function()
    -- Using protected call
    local cmp_ok, cmp = pcall(require, "cmp")
    if not cmp_ok then
      return
    end
    local luasnip_ok, luasnip = pcall(require, "luasnip")
    if not luasnip_ok then
      return
    end

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local compare = require("cmp.config.compare")

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      formatting = {
        fields = { "abbr", "menu", "kind" },
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = "λ",
            luasnip = "⋗",
            buffer = "Ω",
            path = "🖫",
            nvim_lua = "Π",
          }
          item.menu = menu_icon[entry.source.name]
          return item
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "nvim_lsp", group_index = 2 },
        { name = "nvim_lua", group_index = 2 },
        { name = "luasnip",  group_index = 2 },
        { name = "buffer",   group_index = 2 },
        { name = "copilot" },
        { name = "path",     group_index = 2 },
      },
      sorting = {
        -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,

          -- copied from cmp-under, but I don't think I need the plugin for this.
          -- I might add some more of my own.
          function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find "^_+"
            local _, entry2_under = entry2.completion_item.label:find "^_+"
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
              return false
            elseif entry1_under < entry2_under then
              return true
            end
          end,

          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      window = {
        documentation = {
          border = "rounded",
          winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
        },
        completion = {
          border = "rounded",
          winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
        },
      },
      experimental = {
        ghost_text = true,
      },
    })
    -- Add vim-dadbod-completion in sql files
    vim.cmd [[
" hrsh7th/nvim-cmp
  autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })

  " Source is automatically added, you just need to include it in the chain complete list
let g:completion_chain_complete_list = {
    \   'sql': [
    \    {'complete_items': ['vim-dadbod-completion']},
    \   ],
    \ }
" Make sure `substring` is part of this list. Other items are optional for this completion source
let g:completion_matching_strategy_list = ['exact', 'substring']
" Useful if there's a lot of camel case items
let g:completion_matching_ignore_case = 1

]]
  end,
}
