local M = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
}

local ensure_installed = {
  "javascript",
  "typescript",
  "lua",
  "html",
  "markdown",
  "bash",
  "gitcommit",
  "gitignore",
  "php",
}

function M.config()
  local ts = require "nvim-treesitter"

  ts.setup {
    install_dir = vim.fn.stdpath "data" .. "/site",
  }

  -- Install only parsers that aren't already compiled, avoiding work on every startup.
  local installed = require("nvim-treesitter.config").get_installed()
  local missing = vim.tbl_filter(function(parser)
    return not vim.tbl_contains(installed, parser)
  end, ensure_installed)
  if #missing > 0 then
    ts.install(missing)
  end

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Enable treesitter highlighting, indentation, and folds",
    callback = function(args)
      -- Highlighting; bail out for filetypes without an installed parser.
      if not pcall(vim.treesitter.start, args.buf) then
        return
      end
      vim.bo[args.buf].syntax = ""

      -- Treesitter-based indentation.
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

      -- Treesitter-based folds, left open by default.
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldmethod = "expr"
      vim.wo.foldlevel = 99
    end,
  })
end

return M
