local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File explorer",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>og",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Open in GitHub",
      mode = { "n", "v" },
    },
    {
      "<leader>nh",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>nd",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss Notifications",
    },
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    {
      "<leader>zm",
      function()
        Snacks.toggle.dim():toggle()
      end,
      desc = "Toggle Dim Mode",
    },
    {
      "<leader>ln",
      function()
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):toggle()
      end,
      desc = "Toggle Relative Numbers",
    },
    {
      "<leader>cl",
      function()
        Snacks.toggle.option("cursorline", { name = "Cursor Line" }):toggle()
      end,
      desc = "Toggle Cursor Line",
    },
    {
      "<leader>tw",
      function()
        Snacks.toggle.option("wrap"):toggle()
      end,
      desc = "Toggle Line Wrap",
    },
    {
      "<leader>td",
      function()
        Snacks.toggle.diagnostics():toggle()
      end,
      desc = "Toggle Diagnostics",
    },
    {
      "<leader>tf",
      function()
        Snacks.toggle({
          name = "Format on Save",
          get = function()
            return vim.g.autoformat ~= false
          end,
          set = function(state)
            vim.g.autoformat = state
          end,
        }):toggle()
      end,
      desc = "Toggle Format on Save",
    },
    {
      "<leader>tx",
      function()
        local tsc = require "treesitter-context"
        Snacks.toggle({
          name = "Treesitter Context",
          get = tsc.enabled,
          set = function(state)
            if state then
              tsc.enable()
            else
              tsc.disable()
            end
          end,
        }):toggle()
      end,
      desc = "Toggle Treesitter Context",
    },
    {
      "<leader>ih",
      function()
        Snacks.toggle.inlay_hints():toggle()
      end,
      desc = "Toggle Inlay Hints",
    },
    {
      "<leader>tb",
      function()
        Snacks.toggle({
          name = "Git Blame Line",
          get = function()
            return require("gitsigns.config").config.current_line_blame
          end,
          set = function(state)
            require("gitsigns").toggle_current_line_blame(state)
          end,
        }):toggle()
      end,
      desc = "Toggle Git Blame Line",
    },
  },
}

function M.config()
  local icons = require "config.icons"

  require("snacks").setup {
    bigfile = { enabled = false }, -- Disabled: was killing treesitter highlighting
    bufdelete = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        keys = {
          { icon = icons.ui.FindFile, key = "f", desc = "Find File", action = ":Telescope find_files" },
          { icon = icons.ui.FindText, key = "t", desc = "Find Text", action = ":Telescope live_grep" },
          { icon = icons.ui.NewFile, key = "n", desc = "New File", action = ":ene" },
          { icon = icons.git.Repo, key = "g", desc = "Git", action = ":Neogit" },
          { icon = icons.ui.Gear, key = "c", desc = "Config", action = ":edit $MYVIMRC" },
          { icon = icons.ui.Package, key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = icons.ui.SignOut, key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header", padding = 2 },
        { section = "keys", gap = 1, padding = 2 },
        { section = "startup" },
      },
    },
    dim = { enabled = true },
    explorer = { enabled = true },
    gitbrowse = { enabled = true },
    image = { enabled = true }, -- inline images in Ghostty; needed for xcodebuild SwiftUI previews
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "fancy",
    },
    picker = {
      enabled = true,
      ui_select = true, -- vim.ui.select (code actions, etc.)
      layout = { cycle = false }, -- stop at the list edges instead of wrapping around
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                ["o"] = "confirm", -- open file / toggle folder, like nvim-tree (was: open in Finder)
              },
            },
          },
        },
      },
    },
    scratch = { enabled = true },
    statuscolumn = { enabled = true },
    toggle = { enabled = true },
    words = { enabled = false }, -- Might conflict with other plugins
  }

  -- Filter out annoying notifications
  local filtered_messages = { "No information available" }
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      local notify = Snacks.notifier.notify
      ---@diagnostic disable-next-line: duplicate-set-field
      Snacks.notifier.notify = function(message, level, opts)
        for _, msg in ipairs(filtered_messages) do
          if message == msg then
            return nil
          end
        end
        return notify(message, level, opts)
      end
    end,
  })

  -- Oil.nvim integration for file renames
  vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
      if event.data.actions and event.data.actions.type == "move" then
        Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
      end
    end,
  })
end

return M
