local M = {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil --float<cr>", desc = "Open parent directory" },
  },
}

function M.config()
  require("oil").setup {
    view_options = {
      show_hidden = true,
    },
    float = {
      max_height = 20,
      max_width = 60,
      border = "rounded",
    },
    keymaps = {
      ["<C-h>"] = false,
      ["<C-l>"] = false,
    },
  }
end

return M
