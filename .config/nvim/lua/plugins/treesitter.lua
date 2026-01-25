local M = {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter").setup {}
  require("nvim-treesitter").install {
    "javascript",
    "typescript",
    "lua",
    "html",
    "markdown",
    "bash",
    "gitcommit",
    "gitignore",
  }

  -- Enable treesitter highlighting and disable vim syntax (required in nvim-treesitter 1.0+)
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local ok = pcall(vim.treesitter.start, args.buf)
      if ok then
        -- Disable vim syntax highlighting to prevent conflicts
        vim.bo[args.buf].syntax = ""
      end
    end,
  })
end

return M
