local M = {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
}

function M.config()
  local lint = require("lint")

  lint.linters_by_ft = {
    python = { "ruff" },
    sh = { "shellcheck" },
    bash = { "shellcheck" },
  }

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("lint", { clear = true }),
    callback = function()
      lint.try_lint(nil, { ignore_errors = true })
    end,
  })

  -- the BufReadPost that lazy-loaded this plugin already fired; lint once
  -- filetype detection has settled
  vim.schedule(function()
    lint.try_lint(nil, { ignore_errors = true })
  end)
end

return M
