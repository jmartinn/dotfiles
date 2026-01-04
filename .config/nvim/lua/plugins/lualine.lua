local M = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

function M.config()
  local icons = require "config.icons"

  require("lualine").setup {
    options = {
      theme = "auto",
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        { "branch", icon = "" },
        {
          "diff",
          symbols = {
            added = icons.git.LineAdded .. " ",
            modified = icons.git.LineModified .. " ",
            removed = icons.git.LineRemoved .. " ",
          },
        },
      },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error .. " ",
            warn = icons.diagnostics.Warning .. " ",
            info = icons.diagnostics.Information .. " ",
            hint = icons.diagnostics.Hint .. " ",
          },
        },
      },
      lualine_y = { "filetype" },
      lualine_z = { "location" },
    },
  }
end

return M
