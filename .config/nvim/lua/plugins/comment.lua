local M = {
  "numToStr/Comment.nvim",
  keys = {
    { "gcc", mode = "n", desc = "Comment line" },
    { "gc", mode = { "n", "v" }, desc = "Comment" },
  },
}

function M.config()
  require("Comment").setup({})
end

return M
