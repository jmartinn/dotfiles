local M = {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  cmd = "Neogen",
  keys = {
    { "<leader>cn", "<cmd>Neogen<cr>", desc = "Generate doc comment" },
  },
}

function M.config()
  require("neogen").setup {
    enabled = true,
    snippet_engine = "luasnip",
    languages = {
      javascript = { template = { annotation_convention = "jsdoc" } },
      typescript = { template = { annotation_convention = "tsdoc" } },
      typescriptreact = { template = { annotation_convention = "tsdoc" } },
      lua = { template = { annotation_convention = "emmylua" } },
      python = { template = { annotation_convention = "google_docstrings" } },
      go = { template = { annotation_convention = "godoc" } },
    },
  }
end

return M
