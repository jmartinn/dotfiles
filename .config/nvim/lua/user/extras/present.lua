local M = {
  "tjdevries/present.nvim",
  lazy = false,
  opts = {},
}

function M.config()
  require("present").setup {}
end

return M
