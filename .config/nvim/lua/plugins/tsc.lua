local M = {
  "dmmulroy/tsc.nvim",
  cmd = { "TSC" },
  ft = { "typescript", "typescriptreact" },
}

function M.config()
  require("tsc").setup({
    auto_open_qflist = true,
    auto_close_qflist = false,
    enable_progress_notifications = true,
    flags = {
      noEmit = true,
    },
  })
end

return M
