local M = {
  "folke/lazydev.nvim",
  ft = "lua",
  dependencies = {
    "Bilal2453/luvit-meta", -- Optional dependency for vim.uv types
  },
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = "luvit-meta/library", words = { "vim%.uv" } },
      -- Always load these library paths
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
    -- Automatically setup lua_ls with proper Neovim runtime and plugin paths
    integrations = {
      lspconfig = true,  -- Auto-configures lua_ls via nvim-lspconfig
      cmp = true,        -- Enable completion support
    },
  },
}

return M
