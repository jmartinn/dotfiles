local M = {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  dependencies = { "nvim-lua/plenary.nvim" },
}

function M.config()
  require("diffview").setup()
end

return M
