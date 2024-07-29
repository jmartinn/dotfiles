local M = {
	"folke/which-key.nvim",
	event = "VeryLazy",
}

function M.config()
	local mappings = {
		{ "<leader>;", "<cmd>tabnew | terminal<CR>", desc = "Term" },
		{ "<leader>T", group = "Treesitter" },
		{ "<leader>]", group = "Pomo" },
		{ "<leader>]w", "<cmd>TimerSession default<CR>", desc = "Start work session" },
		{ "<leader>]p", "<cmd>TimerPause<CR>", desc = "Pause Timer" },
		{ "<leader>]r", "<cmd>TimerResume<CR>", desc = "Resume Timer" },
		{ "<leader>]s", "<cmd>TimerStop<CR>", desc = "Stop Timer" },
		{ "<leader>a", group = "Tab" },
		{ "<leader>aN", "<cmd>tabnew %<cr>", desc = "New Tab" },
		{ "<leader>ah", "<cmd>-tabmove<cr>", desc = "Move Left" },
		{ "<leader>al", "<cmd>+tabmove<cr>", desc = "Move Right" },
		{ "<leader>an", "<cmd>$tabnew<cr>", desc = "New Empty Tab" },
		{ "<leader>ao", "<cmd>tabonly<cr>", desc = "Only" },
		{ "<leader>b", group = "Buffers" },
		{ "<leader>d", group = "Debug" },
		{ "<leader>f", group = "Find" },
		{ "<leader>g", group = "Git" },
		{ "<leader>h", "<cmd>nohlsearch<CR>", desc = "NOHL" },
		{ "<leader>l", group = "LSP" },
		{ "<leader>o", group = "Obsidian" },
		{ "<leader>p", group = "Plugins" },
		{ "<leader>q", "<cmd>confirm q<CR>", desc = "Quit" },
		{ "<leader>t", group = "Test" },
		{ "<leader>v", "<cmd>vsplit<CR>", desc = "Split" },
	}

	local which_key = require("which-key")
	which_key.setup({
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				operators = false,
				motions = false,
				text_objects = false,
				windows = false,
				nav = false,
				z = false,
				g = false,
			},
		},
		win = {
			padding = { 1, 2 },
			title = true,
			title_pos = "center",
		},
		layout = {
			width = { min = 20 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
		},
		show_help = true,
		show_keys = true,
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt" },
		},
	})

	local opts = {
		mode = "n", -- NORMAL mode
		prefix = "<leader>",
	}

	which_key.add(mappings, opts)
end

return M
