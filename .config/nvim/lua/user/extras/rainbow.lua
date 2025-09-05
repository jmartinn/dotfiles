local M = {
	"HiPhish/rainbow-delimiters.nvim",
	event = { "BufReadPost", "BufNewFile" },
}

function M.config()
	local rainbow_delimiters = require("rainbow-delimiters")

	vim.g.rainbow_delimiters = {
		strategy = {
			[""] = rainbow_delimiters.strategy["global"],
			vim = rainbow_delimiters.strategy["local"],
		},
		query = {
			[""] = "rainbow-delimiters",
			lua = "rainbow-delimiters",
			typescript = "rainbow-delimiters", 
			javascript = "rainbow-delimiters",
			tsx = "rainbow-delimiters",
			jsx = "rainbow-delimiters",
			html = "rainbow-delimiters",
			css = "rainbow-delimiters",
			json = "rainbow-delimiters",
		},
		priority = {
			[""] = 110,
			lua = 210,
		},
		highlight = {
			"RainbowDelimiterRed",
			"RainbowDelimiterYellow", 
			"RainbowDelimiterBlue",
			"RainbowDelimiterOrange",
			"RainbowDelimiterGreen",
			"RainbowDelimiterViolet",
			"RainbowDelimiterCyan",
		},
	}
end

return M
