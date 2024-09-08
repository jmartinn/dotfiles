local M = {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-web-devicons" },
}

function M.config()
	require("bufferline").setup({})
end

return M
