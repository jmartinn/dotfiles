local M = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
}

function M.config()
  require("tokyonight").setup {
    style = "night",
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
      functions = { italic = true },
      comments = { italic = true },
    },
  }
  vim.cmd.colorscheme "tokyonight"
end

return M
