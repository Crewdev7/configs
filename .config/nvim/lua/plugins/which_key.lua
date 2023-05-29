return {
  "folke/which-key.nvim",
  config = function()
    local status_ok, which_key = pcall(require, "which-key")
    if not status_ok then
      return
    end

    local setup = {
      plugins = {
        marks = true,  -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true,     -- misc bindings to work with windows
          z = true,       -- bindings for folds, spelling and others prefixed with z
          g = true,       -- bindings for prefixed with g
        },
      },
      -- add operators that will trigger motion and text object completion
      -- to enable all native operators, set the preset / operators plugin above
      -- operators = { gc = "Comments" },
      key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        ["<leader>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+",  -- symbol prepended to a group
      },
      popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
      },
      window = {
        border = "none",      -- none, single, double, shadow
        position = "bottom",  -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 15,
      },
      layout = {
        height = { min = 4, max = 25 },                                              -- min and max height of the columns
        width = { min = 20, max = 50 },                                              -- min and max width of the columns
        spacing = 3,                                                                 -- spacing between columns
        align = "center",                                                            -- align columns left, center or right
      },
      ignore_missing = true,                                                         -- enable this to hide mappings for which you didn't specify a label
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
      show_help = true,                                                              -- show a help message in the command line for using WhichKey
      show_keys = true,                                                              -- show the currently pressed key and its label as a message in the command line
      triggers = "auto",                                                             -- automatically setup triggers
      -- triggers = {"<leader>"} -- or specifiy a list manually
      -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
      triggers_nowait = {
        -- marks
        "`",
        "'",
        "g`",
        "g'",
        -- registers
        '"',
        "<c-r>",
        -- spelling
        "z=",
      },
      triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "j" },
        v = { "j", "j" },
      },
    }

    local i = {
      [" "] = "Whitespace",
      ['"'] = 'Balanced "',
      ["'"] = "Balanced '",
      ["`"] = "Balanced `",
      ["("] = "Balanced (",
      [")"] = "Balanced ) including white-space",
      [">"] = "Balanced > including white-space",
      ["<lt>"] = "Balanced <",
      ["]"] = "Balanced ] including white-space",
      ["["] = "Balanced [",
      ["}"] = "Balanced } including white-space",
      ["{"] = "Balanced {",
      ["?"] = "User Prompt",
      _ = "Underscore",
      a = "Argument",
      b = "Balanced ), ], }",
      c = "Class",
      f = "Function",
      o = "Block, conditional, loop",
      q = "Quote `, \", '",
      t = "Tag",
    }

    local a = vim.deepcopy(i)
    for k, v in pairs(a) do
      a[k] = v:gsub(" including.*", "")
    end
    local ic = vim.deepcopy(i)
    local ac = vim.deepcopy(a)
    for key, name in pairs({ n = "Next", l = "Last" }) do
      i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
      a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
    end

    local opts = {
      mode = "n",  -- NORMAL mode
      prefix = "<leader>",
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
    }

    local mappings = {
      ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
      ["x"] = { "<cmd>x<cr>", "Write and Quit" },
      ["q"] = { "<cmd>bw<cr>", "Close Buffer" },
      ["Q"] = { "<cmd>qa!<cr>", "Force Quit!" },
      c = {
        name = "Config",
        -- f = { '<cmd>!eslint --fix %<cr>', 'Format Files' },
        F = { "<cmd>retab<cr>", "Fix Tabs" },
        i = { vim.show_pos, "Inspect Position" },
        l = { "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", "Redraw" },
        n = { "<cmd>enew<cr>", "New File" },
        N = { "<cmd>Notifications<cr>", "Show Notifications" },
        r = { "<cmd>set relativenumber!<cr>", "Relative Numbers" },
        R = { "<cmd>lua ReloadConfig()<cr>", "Reload" },
        s = { "<cmd>set spell!<cr>", "Spellcheck" },
        z = { "<cmd>ZenMode<cr>", "Toggle ZenMode" },
        u = { "<cmd>UndotreeToggle<cr>", "Undo Tree" },
        y = { "<cmd>CRpath<cr>", "Copy Relative Path" },
        C = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        Y = { "<cmd>CApath<cr>", "Copy Absolute Path" },
        e = { "<cmd>e $MYVIMRC<CR>", "Edit Config" },
        c = { "<cmd>Telescope neoclip<CR>", "Neoclip" },
        p = {
          "<cmd>lua require('telescope').extensions.project.project{ search_dirs = { vim.fn.expand('$HOME/.config/nvim') } }<CR>",
          "Go to NVIM Folder Project",
        },
        t = {
          name = "+termgui", -- sub-group name
          c = { "<cmd>set termguicolors!<CR>", "Toggle Termgui Colors" },
          l = {
            "<cmd>let g:terminal_color_0='#000000'<CR><cmd>let g:terminal_color_1='#FF5555'<CR><cmd>let g:terminal_color_2='#50FA7B'<CR><cmd>let g:terminal_color_3='#F1FA8C'<CR><cmd>let g:terminal_color_4='#BD93F9'<CR><cmd>let g:terminal_color_5='#FF79C6'<CR><cmd>let g:terminal_color_6='#8BE9FD'<CR><cmd>let g:terminal_color_7='#BFBFBF'<CR><cmd>let g:terminal_color_8='#4D4D4D'<CR><cmd>let g:terminal_color_9='#FF6E6E'<CR><cmd>let g:terminal_color_10='#69FF94'<CR><cmd>let g:terminal_color_11='#FFFFA5'<CR><cmd>let g:terminal_color_12='#D6ACFF'<CR><cmd>let g:terminal_color_13='#FF92DF'<CR><cmd>let g:terminal_color_14='#A4FFFF'<CR><cmd>let g:terminal_color_15='#E6E6E6'<CR>",
            "Load Terminal Colorscheme",
          },
        },
      },

      f = {
        name = "Find",
        b = {
          "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal'})<cr>",
          "Find files in Buffer",
        },
        f = {
          "<cmd>Telescope find_files find_command=fd,--hidden,-I<cr>",
          "Find All Files",
        },
        g = {
          "<cmd>Telescope git_files find_command=fd,--hidden<cr>",
          "Find files git",
        },
        m = { "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>", "Media" },
        R = { "<cmd>lua require('telescope').extensions.frecency.frecency()<cr>", "Frecent Files" },
        o = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
        P = { "<cmd>Telescope projects<CR>", "Projects" },

        t = { "<cmd>Telescope<cr>", "Telescope Panel" },
      },
      s = {
        name = "Searching",
        n = { "<cmd>Telescope notify<cr>", "Notifications" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        h = { "<cmd>Telescope help_tags<cr>", "Help" },
        l = { "<cmd>Telescope resume<cr>", "Last Search" },
        g = { "<cmd>Telescope live_grep<cr>", "Find Text" },
        G = { "<cmd>Telescope grep_string<cr>", "Find Under Cursor" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        c = { "<cmd>Telescope commands<cr>", "Commands" },
        ['"'] = { "<cmd>Telescope registers<cr>", "Registers" },
        t = { "<cmd>Telescope<cr>", "Telescope Panel" },
      },
      g = {
        name = "Git",
        A = { "<cmd>GitCoAuthors<cr>", "Co Authors" },
        g = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "Lazygit" },
        n = { "<cmd>Neogit<cr>", "Neogit" },
        c = { "<cmd>Neogit commit<cr>", "Commit" },
        C = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        j = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
        k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk" },
        p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
        r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
        R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
        s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
        S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage Buffer" },
        u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo Stage Hunk" },
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Gitsigns blame_line<cr>", "Blame" },
        B = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        D = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
        d = { "<cmd>DiffviewOpen<cr>", "Diff View" },
        f = { "<cmd>DiffviewFileHistory<cr>", "File History" },
        h = {
          name = "+Github",
          c = {
            name = "+Commits",
            c = { "<cmd>GHCloseCommit<cr>", "Close" },
            e = { "<cmd>GHExpandCommit<cr>", "Expand" },
            o = { "<cmd>GHOpenToCommit<cr>", "Open To" },
            p = { "<cmd>GHPopOutCommit<cr>", "Pop Out" },
            z = { "<cmd>GHCollapseCommit<cr>", "Collapse" },
          },
          i = {
            name = "+Issues",
            p = { "<cmd>GHPreviewIssue<cr>", "Preview" },
          },
          l = {
            name = "+Litee",
            t = { "<cmd>LTPanel<cr>", "Toggle Panel" },
          },
          r = {
            name = "+Review",
            b = { "<cmd>GHStartReview<cr>", "Begin" },
            c = { "<cmd>GHCloseReview<cr>", "Close" },
            d = { "<cmd>GHDeleteReview<cr>", "Delete" },
            e = { "<cmd>GHExpandReview<cr>", "Expand" },
            s = { "<cmd>GHSubmitReview<cr>", "Submit" },
            z = { "<cmd>GHCollapseReview<cr>", "Collapse" },
          },
          p = {
            name = "+Pull Request",
            c = { "<cmd>GHClosePR<cr>", "Close" },
            d = { "<cmd>GHPRDetails<cr>", "Details" },
            e = { "<cmd>GHExpandPR<cr>", "Expand" },
            o = { "<cmd>GHOpenPR<cr>", "Open" },
            p = { "<cmd>GHPopOutPR<cr>", "PopOut" },
            r = { "<cmd>GHRefreshPR<cr>", "Refresh" },
            t = { "<cmd>GHOpenToPR<cr>", "Open To" },
            z = { "<cmd>GHCollapsePR<cr>", "Collapse" },
          },
          t = {
            name = "+Threads",
            c = { "<cmd>GHCreateThread<cr>", "Create" },
            n = { "<cmd>GHNextThread<cr>", "Next" },
            t = { "<cmd>GHToggleThread<cr>", "Toggle" },
          },
        },
      },
      d = {
        name = "Diagnostic",
        q = { "<cmd>Telescope quickfix<cr>", "Quickfix Tele" },
        L = { "<cmd>Telescope loclist<cr>", "Location List Tele" },
      },
      l = {
        name = "LSP",
        A = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
        f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
        D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
        d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
        i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementations" },
        R = { "<cmd>TroubleToggle lsp_references<cr>", "References Trouble" },
        h = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
        a = { "<cmd> lua vim.lsp.buf.code_action()<CR>", "Code action" },
        r = { "<cmd>lua vim.lsp.buf.references()<CR", "References" },
        n = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
        I = { "<cmd>LspInfo<cr>", "Info" },

        l = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Toggle LSP Lines" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols Tele" },

        w = {
          name = "Workspace Related",

          A = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Workspace Folder" },
          w = {
            "<cmd>Telescope lsp_workspace_diagnostics<cr>",
            "Workspace Diagnostics Tele",
          },
          S = {
            "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
            "Workspace Symbols Tele",
          },
          R = { "<cmd> lua  vim.lsp.buf.remove_workspace_folder()<CR>", "Remove workspace folder" },
        },
        t = { "<cmd>TroubleToggle<cr>", "Trouble Diagnostics" },
        u = { "<cmd>LuaSnipUnlinkCurrent<cr>", "Unlink Snippet" },
      },
      o = {
        name = "Session",
        s = { "<cmd>SaveSession<cr>", "Save" },
        r = { "<cmd>RestoreSession<cr>", "Restore" },
        x = { "<cmd>DeleteSession<cr>", "Delete" },
        f = { "<cmd>Autosession search<cr>", "Find" },
        d = { "<cmd>Autosession delete<cr>", "Find Delete" },
      },

      S = {
        name = "SnipRun",
        c = { "<cmd>SnipClose<cr>", "Close" },
        f = { "<cmd>%SnipRun<cr>", "Run File" },
        i = { "<cmd>SnipInfo<cr>", "Info" },
        m = { "<cmd>SnipReplMemoryClean<cr>", "Mem Clean" },
        r = { "<cmd>SnipReset<cr>", "Reset" },
        t = { "<cmd>SnipRunToggle<cr>", "Toggle" },
        x = { "<cmd>SnipTerminate<cr>", "Terminate" },
      },
      t = {
        name = "Terminal",
        ["1"] = { ":1ToggleTerm<cr>", "1" },
        ["2"] = { ":2ToggleTerm<cr>", "2" },
        ["3"] = { ":3ToggleTerm<cr>", "3" },
        ["4"] = { ":4ToggleTerm<cr>", "4" },
        n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
        h = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
        t = { "<cmd>ToggleTerm<cr>", "ToggleTerm" },
        f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
        s = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
        v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
      },
      T = {
        name = "Treesitter",
        h = { "<cmd>TSHighlightCapturesUnderCursor<cr>", "Highlight" },
        p = { "<cmd>TSPlaygroundToggle<cr>", "Playground" },
        r = { "<cmd>TSToggle rainbow<cr>", "Rainbow" },
        w = { ":write | edit | TSBufEnable :qhighlight" },
      },
      w = {
        name = "Window",
        w = { "<cmd>w<cr>", "Write" },
        W = { "<cmd>lua require'utils'.sudo_write()<cr>", "Force Write" },
        x = { "<cmd>x<cr>", "Write and Quit" },
        q = { "<cmd>bw<cr>", "Close Current Buf" },
        s = { "<cmd>split<cr>", "Horizontal Split File" },
        v = { "<cmd>vsplit<cr>", "Vertical Split File" },
        t = { "<cmd>tabnew<cr>", "New Tab" },
        f = { "<cmd>tabfirst<cr>", "First Tab" },
        l = { "<cmd>tablast<cr>", "Last Tab" },
        o = { "<cmd>tabnext<cr>", "Next Tab" },
        c = { "<cmd>tabclose<cr>", "Close Tab" },
        O = { "<cmd>tabprevious<cr>", "Previous Tab" },
      },
      -- s = {
      --   name = "Split",
      --   s = { "<cmd>split<cr>", "HSplit" },
      --   v = { "<cmd>vsplit<cr>", "VSplit" },
      -- },
    }

    local vopts = {
      mode = "v",  -- VISUAL mode
      prefix = "<leader>",
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = true, -- use `nowait` when creating keymaps
    }

    local vmappings = {
      ["/"] = { '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Comment" },
      s = { "<esc><cmd>'<,'>SnipRun<cr>", "Run Code" },
      r = {
        name = "Refactor",
        r = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Refactor Commands" },
        e = { "<esc><cmd>lua require('refactoring').refactor('Extract Function')<CR>", "Extract Function" },
        f = {
          "<esc><cmd>lua require('refactoring').refactor('Extract Function To File')<CR>",
          "Extract Function To File",
        },
        v = { "<esc><cmd>lua require('refactoring').refactor('Extract Variable')<CR>", "Extract Variable" },
        i = { "<esc><cmd>lua require('refactoring').refactor('Inline Variable')<CR>", "Inline Variable" },
      },
      l = {
        name = "LSP",
        a = "<cmd><C-U>Lspsaga range_code_action<CR>",
      },
    }

    which_key.setup(setup)
    which_key.register(mappings, opts)
    which_key.register(vmappings, vopts)
    which_key.register({ mode = { "o", "x" }, i = i, a = a })
  end,
}
