local M = {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
}

function M.config()
  -- Let Neovim detect dark/light from the terminal; match Ghostty's hard contrast.
  require("gruvbox").setup {
    contrast = "hard",
  }
  vim.cmd.colorscheme "gruvbox"
end

return M
