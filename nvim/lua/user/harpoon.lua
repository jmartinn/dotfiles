local M = {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
}

function M.config()
	local harpoon = require("harpoon")

	-- Setup Harpoon
	harpoon:setup()

	-- Key mappings
	local keymap = vim.keymap.set
	local opts = { noremap = true, silent = true }

	-- Add current file to Harpoon's list and notify the user
	keymap("n", "<s-m>", function()
		harpoon:list():add()
		vim.notify("󱡅  marked file", vim.log.levels.INFO)
	end, opts)

	-- Toggle the quick menu
	keymap("n", "<TAB>", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end, opts)

	-- Select specific files with shortcuts
	keymap("n", "<C-n>", function()
		harpoon:list():select(1)
	end, opts)
	keymap("n", "<C-s>", function()
		harpoon:list():select(2)
	end, opts)
	-- keymap("n", "<C-n>", function()
	-- 	harpoon:list():select(3)
	-- end, opts)
	-- keymap("n", "<C-s>", function()
	-- 	harpoon:list():select(4)
	-- end, opts)

	-- Navigate to previous and next file in the list
	-- keymap("n", "<C-h>", function()
	-- 	harpoon:list():prev()
	-- end, opts)
	-- keymap("n", "<C-l>", function()
	-- 	harpoon:list():next()
	-- end, opts)
end

return M
