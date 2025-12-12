local M = {
  "folke/tokyonight.nvim",
  -- "rose-pine/neovim",
  -- "catppuccin/nvim",
  name = "tokyonight",
  -- name = "rose-pine",
  -- name = "catppuccin",
  lazy = false,
  priority = 1000,
}

function M.config()
  require("tokyonight").setup {
    style = "night",
  }

  -- require("rose-pine").setup {
  --   variant = "auto",
  -- }

  -- require("catppuccin").setup {
  --   flavour = "mocha",
  -- }

  vim.cmd "colorscheme tokyonight"
  -- vim.cmd "colorscheme rose-pine"
  -- vim.cmd "colorscheme catppuccin"
end

return M
