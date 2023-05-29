vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Briefly highlight yanked text",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
	callback = function()
		vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

vim.cmd([[
    " Have Vim jump to the last position when reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\""
    endif
]])

-- Automatically close tab/vim when nvim-tree is the last window in the tab
-- vim.cmd("autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif")
--
--
vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Copy relative path
-- vim.api.nvim_create_user_command("CRpath", function()
-- 	local path = vim.fn.expand("%")
-- 	vim.fn.setreg("+", path)
-- 	vim.notify('Copied "' .. path .. '" to the clipboard!')
-- end, {})

-- Copy absolute path
-- vim.api.nvim_create_user_command("CApath", function()
-- 	local path = vim.fn.expand("%:p")
-- 	vim.fn.setreg("+", path)
-- 	vim.notify('Copied "' .. path .. '" to the clipboard!')
-- end, {})
