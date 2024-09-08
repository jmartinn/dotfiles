local M = {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
}

function M.config()
  local wk = require("which-key")
  wk.add {
    { "<C-h>", "<cmd> TmuxNavigateLeft<CR>" },
    { "<C-j>", "<cmd> TmuxNavigateDown<CR>" },
    { "<C-k>", "<cmd> TmuxNavigateUp<CR>" },
    { "<C-l>", "<cmd> TmuxNavigateRight<CR>" },
  }
end

return M
