local M = {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format buffer",
    },
  },
}

function M.config()
  require("conform").setup({
    formatters_by_ft = {
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      css = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      lua = { "stylua" },
      python = { "ruff_format" },
      go = { "gofmt" },
      php = { "php_cs_fixer" },
    },
    -- on by default; suspend per session with <leader>tf (or per buffer via vim.b.autoformat)
    format_on_save = function(bufnr)
      if vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
        return
      end
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
  })
end

return M
