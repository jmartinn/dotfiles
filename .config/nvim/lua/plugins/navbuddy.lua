local M = {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>[", "<cmd>Navbuddy<cr>", desc = "Navigate symbols" },
  },
}

function M.config()
  local icons = require("config.icons")
  require("nvim-navbuddy").setup({
    window = {
      border = "rounded",
    },
    icons = icons.kind,
    lsp = {
      auto_attach = true,
    },
  })
end

return M
