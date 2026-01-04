local M = {
  "LunarVim/breadcrumbs.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "SmiteshP/nvim-navic",
  },
}

function M.config()
  require("breadcrumbs").setup()
end

return M
