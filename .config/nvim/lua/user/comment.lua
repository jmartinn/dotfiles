local M = {
  "numToStr/Comment.nvim",
  lazy = false,
  dependencies = {

    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
    },
  },
}

function M.config()
  local wk = require "which-key"

  wk.add {
    {
      "<leader>/",
      "<Plug>(comment_toggle_linewise_current)",
      desc = "Comment",
      hidden = true,
    },
  }

  wk.add {
    {
      "<leader>/",
      "<Plug>(comment_toggle_linewise_visual)",
      mode = "v",
      desc = "Comment",
      hidden = true,
    },
  }

  vim.g.skip_ts_context_commentstring_module = true
  ---@diagnostic disable: missing-fields
  require("ts_context_commentstring").setup {
    enable_autocmd = false,
  }

  require("Comment").setup {
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {},
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
      ---Line-comment keymap
      line = "gc",
      ---Block-comment keymap
      block = "gb",
    },
    ---LHS of extra mappings
    extra = {},
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
      ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
      basic = false,
      ---Extra mapping; `gco`, `gcO`, `gcA`
      extra = false,
    },
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  }
end

return M
