local M = {
  "linrongbin16/gitlinker.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gy", "<cmd>GitLink!<cr>", desc = "Copy git link", mode = { "n", "v" } },
    { "<leader>gY", "<cmd>GitLink! blame<cr>", desc = "Copy git link (blame)", mode = { "n", "v" } },
  },
}

function M.config()
  require("gitlinker").setup({
    message = true,
    console_log = false,
  })
end

return M
