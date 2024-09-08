local M = {
	"eandrju/cellular-automaton.nvim",
}

function M.config()
	local wk = require("which-key")
	wk.add({
    { "<leader>y", "<cmd>CellularAutomaton scramble<CR>", desc = "Cellular Automaton" },
	})
end

return M
