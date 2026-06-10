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
      python = { "black" },
      go = { "gofmt" },
      php = { "php_cs_fixer" },
    },
    -- format_on_save disabled - use <leader>lf to manually format
    format_on_save = nil,
  })
end

return M
