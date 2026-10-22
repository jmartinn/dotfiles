local M = {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format { async = true }
      end,
      desc = "Format buffer",
    },
  },
}

function M.config()
  require("conform").setup {
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
      swift = { "swiftformat" },
      kotlin = { "ktlint" },
    },
    formatters = {
      ktlint = {
        -- Resolve .editorconfig and script rules using the actual buffer path.
        append_args = { "--stdin-path", "$FILENAME", "--ignore-autocorrect-failures" },
      },
    },
  }
end

return M
