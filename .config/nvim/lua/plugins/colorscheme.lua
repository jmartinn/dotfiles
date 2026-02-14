local M = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
}

function M.config()
  require("tokyonight").setup {
    style = "night",
    styles = {
      functions = { italic = true },
      comments = { italic = true },
    },
  }
  vim.cmd.colorscheme "tokyonight"
end

return M
