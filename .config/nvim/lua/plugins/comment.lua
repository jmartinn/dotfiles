local M = {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
}

function M.config()
  -- Setup context-aware commenting (for JSX/TSX)
  require("ts_context_commentstring").setup({
    enable_autocmd = false,
  })

  require("Comment").setup({
    padding = true,
    sticky = true,
    toggler = {
      line = "gcc",
      block = "gbc",
    },
    opleader = {
      line = "gc",
      block = "gb",
    },
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  })

  -- Add <leader>/ keymap
  vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Comment line" })
  vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Comment selection" })
end

return M
