local M = {
  "nvim-tree/nvim-web-devicons",
  lazy = false,
}

function M.config()
  require("nvim-web-devicons").setup({
    color_icons = true,
    default = true,
    strict = true,
  })
end

return M
