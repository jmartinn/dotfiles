local M = {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude" },
    { "<leader>cf", "<cmd>ClaudeCodeFocus<CR>", desc = "Focus Claude" },
    { "<leader>cr", "<cmd>ClaudeCode --resume<CR>", desc = "Resume Claude" },
    { "<leader>cC", "<cmd>ClaudeCode --continue<CR>", desc = "Continue Claude" },
    { "<leader>cb", "<cmd>ClaudeCodeAdd %<CR>", desc = "Add current buffer" },
    { "<leader>cs", "<cmd>ClaudeCodeSend<CR>", mode = "v", desc = "Send selection to Claude" },
    {
      "<leader>cs",
      "<cmd>ClaudeCodeTreeAdd<CR>",
      desc = "Add file from explorer",
      ft = { "oil" },
    },
    { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<CR>", desc = "Accept diff" },
    { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<CR>", desc = "Deny diff" },
  },
}

function M.config()
  require("claudecode").setup({})
end

return M
