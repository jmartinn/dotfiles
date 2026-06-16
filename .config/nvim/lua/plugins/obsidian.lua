-- maintained fork of the archived epwalsh/obsidian.nvim
local VAULT = os.getenv("HOME") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/svalbard"

local M = {
  "obsidian-nvim/obsidian.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>oT", "<cmd>Obsidian tags<cr>", desc = "Search By Tag" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show Backlinks" },
    { "<leader>oc", "<cmd>Obsidian new<cr>", desc = "Create New Note" },
    { "<leader>od", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle Check-Box" },
    { "<leader>of", "<cmd>Obsidian search<cr>", desc = "Search Note" },
    { "<leader>ok", "<cmd>Obsidian template<cr>", desc = "Template Palette" },
    { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Show Links" },
    { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Open Current Buffer" },
    { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Open/Create Today's Note" },
    { "gf", "<cmd>Obsidian follow_link<cr>", ft = "markdown", desc = "Follow Link" },
    -- Work log keybindings
    { "<leader>owt", function()
      local today = os.date("%Y-%m-%d")
      local path = VAULT .. "/2-Areas/Work/Logs/" .. today .. "-worklog.md"
      vim.cmd("edit " .. path)
    end, desc = "Today's Work Log" },
    { "<leader>owy", function()
      local yesterday = os.date("%Y-%m-%d", os.time() - 86400)
      local path = VAULT .. "/2-Areas/Work/Logs/" .. yesterday .. "-worklog.md"
      vim.cmd("edit " .. path)
    end, desc = "Yesterday's Work Log" },
    { "<leader>owq", function()
      local today = os.date("%Y-%m-%d")
      local path = VAULT .. "/2-Areas/Work/Logs/" .. today .. "-worklog.md"
      vim.cmd("edit " .. path)
      vim.defer_fn(function()
        vim.fn.search("## Captura Rapida")
        vim.cmd("normal! 2jo")
        vim.cmd("startinsert")
      end, 50)
    end, desc = "Quick Capture" },
  },
}

function M.config()
  require("obsidian").setup({
    legacy_commands = false,

    workspaces = {
      {
        name = "svalbard",
        path = VAULT .. "/",
      },
    },

    log_level = vim.log.levels.INFO,

    daily_notes = {
      folder = "0-Daily-Notes",
      template = "Daily Notes.md",
    },

    -- served by the plugin's in-process LSP; blink.cmp picks it up via its lsp source
    completion = {
      min_chars = 2,
    },

    new_notes_location = "notes_subdir",

    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,

    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path
    note_path_func = function(spec)
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix(".md")
    end,

    link = {
      style = "wiki",
    },

    frontmatter = {
      enabled = true,
      ---@return table
      func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
    },

    templates = {
      folder = "Templates",
      date_format = "YYYY-MM-DD-ddd",
      time_format = "HH:mm",
    },

    picker = {
      name = "telescope.nvim",
    },

    search = {
      sort_by = "modified",
      sort_reversed = true,
    },

    open_notes_in = "current",

    ui = {
      enable = true,
      update_debounce = 200,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    attachments = {
      folder = "assets/imgs",
      confirm_img_paste = true,
      ---@return string
      img_name_func = function()
        return string.format("%s-", os.time())
      end,
    },
  })
end

return M
