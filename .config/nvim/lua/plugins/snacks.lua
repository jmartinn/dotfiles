local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
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
  },
}

function M.config()
  require("snacks").setup {
    bigfile = { enabled = false }, -- Disabled: was killing treesitter highlighting
    bufdelete = { enabled = true },
    dim = { enabled = true },
    gitbrowse = { enabled = true },
    indent = { enabled = true }, -- Using indent-blankline
    input = { enabled = false }, -- Using dressing.nvim
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "fancy",
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
