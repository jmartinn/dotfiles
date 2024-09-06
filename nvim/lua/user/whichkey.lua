local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

function M.config()
  local which_key = require "which-key"
  which_key.setup {
    preset = "helix",
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
    },
    win = {
      border = "rounded",
      no_overlap = false,
      padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
      title = false,
      title_pos = "center",
      zindex = 1000,
    },
    -- ignore_missing = true,
    show_help = false,
    show_keys = false,
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  }

  local wk = require "which-key"

  -- icon colors
  -- azure, blue, cyan, green, grey, orange, purple, red, yellow

  wk.add {
    {
      "<leader>]",
      group = "Pomo",
      icon = {
        icon = "󱎫",
        color = "blue",
      },
    },
    {
      "<leader>o]",
      group = "Obsidian",
      icon = {
        icon = "",
        color = "purple",
      },
    },
    {
      "<leader>a",
      group = "AI",
      icon = {
        icon = " ",
        color = "blue",
      },
    },
    {
      "<leader>q",
      "<cmd>confirm q<CR>",
      desc = "Quit",
    },
    {
      "<leader>h",
      "<cmd>nohlsearch<CR>",
      desc = "NOHL",
      hidden = true,
    },
    {
      "<leader>;",
      "<cmd>tabnew | terminal<CR>",
      desc = "Term",
      icon = {
        icon = " ",
        color = "green",
      },
    },
    {
      "<leader>w",
      "<cmd>lua vim.wo.wrap = not vim.wo.wrap<CR>",
      desc = "Wrap",
      hidden = true,
    },
    {
      "<leader>v",
      "<cmd>vsplit<CR>",
      desc = "Split Vertical",
      hidden = true,
    },
    {
      "<leader>h",
      "<cmd>split<CR>",
      desc = "Split Horizontal",
      hidden = true,
    },
    {
      "<leader>b",
      group = "Buffers",
    },
    {
      "<leader>d",
      group = "Debug",
    },
    {
      "<leader>f",
      group = "Find",
    },
    {
      "<leader>g",
      group = "Git",
    },
    {
      "<leader>l",
      group = "LSP",
      icon = {
        icon = " ",
        color = "blue",
      },
    },
    {
      "<leader>p",
      icon = {
        icon = " ",
        color = "azure",
      },
      group = "Plugins",
    },
    {
      "<leader>t",
      group = "Test",
    },
    {
      "<leader>T",
      group = "Treesitter",
    },
  }
end

return M
