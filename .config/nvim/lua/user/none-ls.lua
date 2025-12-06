local M = {
  "nvimtools/none-ls.nvim",
}

function M.config()
  local null_ls = require "null-ls"

  local formatting = null_ls.builtins.formatting

  null_ls.setup {
    debug = true,
    sources = {
      formatting.stylua,
      formatting.prettier,
      formatting.black,
      formatting.shfmt,
      formatting.sql_formatter,
      formatting.phpcsfixer,
      formatting.prettier.with {
        disabled_filetypes = {
          "markdown",
        },
      },
      null_ls.builtins.completion.spell,
    },
  }
end

return M
