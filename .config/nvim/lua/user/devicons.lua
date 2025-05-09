local M = {
  "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
}

function M.config()
  require("nvim-web-devicons").setup {
    override = {
      go = {
        icon = "󰟓",
        color = "#00ADD8",
        cterm_color = "38",
        name = "Go",
      },
    },
  }
end

return M
