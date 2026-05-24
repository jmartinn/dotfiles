local M = {
  "ellisonleao/glow.nvim",
  cmd = "Glow",
  ft = "markdown",
  opts = {
    border = "rounded",
    width = 120,
    height = 100,
    width_ratio = 0.85,
    height_ratio = 0.85,
  },
}

function M.init()
  vim.keymap.set("n", "<leader>mp", "<cmd>Glow<cr>", { desc = "Glow markdown preview" })
end

return M
