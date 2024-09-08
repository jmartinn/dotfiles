local M = {
	"ChristianChiarulli/nostr.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	build = { "cd rplugin/node/nostr && npm i", ":UpdateRemotePlugins" },
}

function M.config()
	require("nostr").setup({})
end

return M
