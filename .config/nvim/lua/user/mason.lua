local M = {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    "nvim-lua/plenary.nvim",
  },
}

M.execs = {
  "lua_ls",
  "cssls",
  "html",
  "ts_ls",
  "eslint",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "tailwindcss",
  "marksman",
  "intelephense",
}

function M.config()
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  require("mason-lspconfig").setup {
    ensure_installed = M.execs,
  }
end

return M
