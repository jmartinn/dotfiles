local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

function M.config()
  local wk = require("which-key")
  wk.setup({
    delay = 300,
  })
  wk.add({
    { "<leader>b", group = "Buffer" },
    { "<leader>d", group = "Debug" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>l", group = "LSP" },
    { "<leader>n", group = "Notifications" },
    { "<leader>o", group = "Obsidian" },
    { "<leader>s", group = "Split" },
    { "<leader>t", group = "Toggle" },
    { "<leader>x", group = "Trouble" },
  })
end

return M
