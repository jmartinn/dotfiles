local M = {
  "SmiteshP/nvim-navic",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "neovim/nvim-lspconfig" },
}

function M.config()
  local icons = require("config.icons")
  require("nvim-navic").setup({
    icons = icons.kind,
    highlight = true,
    lsp = {
      auto_attach = true,
    },
    click = true,
    separator = " " .. icons.ui.ChevronRight .. " ",
    depth_limit = 0,
    depth_limit_indicator = "..",
  })
end

return M
