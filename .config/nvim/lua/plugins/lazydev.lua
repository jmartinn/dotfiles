local M = {
  "folke/lazydev.nvim",
  ft = "lua",
  dependencies = {
    { "Bilal2453/luvit-meta", lazy = true },
  },
}

function M.config()
  require("lazydev").setup({
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })
end

return M
