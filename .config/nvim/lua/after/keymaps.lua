-- Lsp lines
vim.keymap.set("n", "<Leader>ll", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })



-- Bufferline
vim.keymap.set("n", "<leader>x", ":Bdelete<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bp", ":bprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bs", ":BufferLinePick<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bx", ":BufferLineClose<CR>", { noremap = true, silent = true })

-- Co Pilate
vim.keymap.set("n", "<leader>ct", "<cmd>Copilot toggle<CR>", { silent = true })

-- Nullls

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>ltd", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "dn", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "dp", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
-- Enable completion triggered by <c-x><c-o>
-- local bufopts = { noremap = true, silent = true }
-- vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", bufopts)
-- vim.keymap.set("n", "gd", "<cmd> lua vim.lsp.buf.definition()<CR>", bufopts)
-- vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
-- vim.keymap.set("n", "gi", "<cmd> lua vim.lsp.buf.implementation()<CR>", bufopts)
-- vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", bufopts)
-- vim.keymap.set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", bufopts)
-- vim.keymap.set("n", "<space>wr", "<cmd> lua  vim.lsp.buf.remove_workspace_folder()<CR>", bufopts)
-- vim.keymap.set("n", "<space>wl", function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, bufopts)
--
-- nvimtree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })

local opts = { silent = true }

-- keymap("n", "<leader>ff", ":Telescope lsp_references<CR>", opts)
-- keymap("n", "<leader>ft", ":Telescope  lsp_incoming_calls<CR>", opts)
-- keymap("n", "<leader>fp", ":Telescope lsp_document_symbols<CR>", opts)
-- keymap("n", "<leader>fb", ":Telescope diagnostics<CR>", opts)
-- keymap("n", "<leader>fh", ":Telescope lsp_implementations<CR>", opts)
-- keymap("n", "<leader>fk", ":Telescope lsp_definitions<CR>", opts)
-- keymap("n", "<leader>fo", ":Telescope treesitter<CR>", opts)
-- keymap("n", "<leader>fch", ":Telescope quickfix<CR>", opts)

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })



-- define the key mapping to toggle the floating terminal
vim.api.nvim_set_keymap('n', '<Leader>tt', ':ToggleTerm<CR>i', { noremap = true, silent = true })

-- define the key mapping to hide the floating terminal
vim.api.nvim_set_keymap('t', '<Leader>tt', '<C-\\><C-n>:ToggleTerm<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Leader>tt', '<C-\\><C-n>:ToggleTerm<CR>', { noremap = true, silent = true })

-- define the key mapping for "Esc" in terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })



-- Tab for  switch  buffers
vim.api.nvim_set_keymap('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

