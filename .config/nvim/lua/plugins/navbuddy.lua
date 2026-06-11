local M = {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    -- navbuddy requires nvim-navic internally; no winbar breadcrumbs are set up
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
