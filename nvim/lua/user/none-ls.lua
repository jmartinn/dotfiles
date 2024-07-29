local M = {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}

function M.config()
	local null_ls = require("null-ls")

	local formatting = null_ls.builtins.formatting
	-- local diagnostics = null_ls.builtins.diagnostics

	null_ls.setup({
		debug = false,
		sources = {
			formatting.stylua,
			formatting.prettier.with({
				disabled_filetypes = {
					"markdown",
				},
			}),
			formatting.black,
			-- diagnostics.flake8,
			null_ls.builtins.completion.spell,
		},
	})
end

return M
