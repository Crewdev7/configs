return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Using protected call
		local status_ok, alpha = pcall(require, "alpha")
		if not status_ok then
			return
		end

		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			[[                               __                ]],
			[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
			[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
			[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
			[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
			[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("<leader>ff", " " .. " Find file", ":Telescope find_files <CR>"),
			dashboard.button("<leader>fa", " " .. " New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button(
				"<leader>fpf",
				" " .. " Find project",
				":lua require('telescope').extensions.projects.projects()<CR>"
			),
			dashboard.button("<leader>fr", " " .. " Recent files", ":Telescope oldfiles <CR>"),
			dashboard.button("<leader>ft", " " .. " Find text", ":Telescope live_grep <CR>"),
			dashboard.button("<leade>cc", " " .. " Config", ":e $MYVIMRC <CR>"),
			dashboard.button("<leader>q", " " .. " Quit", ":qa<CR>"),
		}
		local function footer()
			return "crew.dev"
		end

		dashboard.section.footer.val = footer()

		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "Include"
		dashboard.section.buttons.opts.hl = "Keyword"

		dashboard.opts.opts.noautocmd = true
		alpha.setup(dashboard.opts)
	end,
}
