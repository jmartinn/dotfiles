local M = {
  "epwalsh/obsidian.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>oT", "<cmd>ObsidianTags<cr>", desc = "Search By Tag" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show Backlinks" },
    { "<leader>oc", "<cmd>ObsidianNew<cr>", desc = "Create New Note" },
    { "<leader>od", function() require("obsidian").util.toggle_checkbox() end, desc = "Toggle Check-Box" },
    { "<leader>of", "<cmd>ObsidianSearch<cr>", desc = "Search Note" },
    { "<leader>ok", "<cmd>ObsidianTemplate<cr>", desc = "Template Palette" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Show Links" },
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open Current Buffer" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open/Create Today's Note" },
    -- Work log keybindings
    { "<leader>owt", function()
      local home = os.getenv("HOME")
      local today = os.date("%Y-%m-%d")
      local path = home .. "/Documents/svalbard/2-Areas/Work/Logs/" .. today .. "-worklog.md"
      vim.cmd("edit " .. path)
    end, desc = "Today's Work Log" },
    { "<leader>owy", function()
      local home = os.getenv("HOME")
      local yesterday = os.date("%Y-%m-%d", os.time() - 86400)
      local path = home .. "/Documents/svalbard/2-Areas/Work/Logs/" .. yesterday .. "-worklog.md"
      vim.cmd("edit " .. path)
    end, desc = "Yesterday's Work Log" },
    { "<leader>owq", function()
      local home = os.getenv("HOME")
      local today = os.date("%Y-%m-%d")
      local path = home .. "/Documents/svalbard/2-Areas/Work/Logs/" .. today .. "-worklog.md"
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
  local home = os.getenv("HOME")
  require("obsidian").setup({
    workspaces = {
      {
        name = "svalbard",
        path = home .. "/Documents/svalbard/",
      },
    },

    log_level = vim.log.levels.INFO,

    daily_notes = {
      folder = "0-Daily-Notes",
      template = "Daily Notes.md",
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>od"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
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

    wiki_link_func = function(opts)
      return require("obsidian.util").wiki_link_id_prefix(opts)
    end,

    markdown_link_func = function(opts)
      return require("obsidian.util").markdown_link(opts)
    end,

    preferred_link_style = "wiki",

    ---@return string
    image_name_func = function()
      return string.format("%s-", os.time())
    end,

    disable_frontmatter = false,

    ---@return table
    note_frontmatter_func = function(note)
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    templates = {
      subdir = "Templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },

    ---@param url string
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url })
    end,

    picker = {
      name = "telescope.nvim",
      note_mappings = {},
      tag_mappings = {},
    },

    sort_by = "modified",
    sort_reversed = true,

    open_notes_in = "current",

    callbacks = {
      ---@param client obsidian.Client
      post_setup = function(client) end,

      ---@param client obsidian.Client
      ---@param note obsidian.Note
      enter_note = function(client, note) end,

      ---@param client obsidian.Client
      ---@param note obsidian.Note
      leave_note = function(client, note) end,

      ---@param client obsidian.Client
      ---@param note obsidian.Note
      pre_write_note = function(client, note) end,

      ---@param client obsidian.Client
      ---@param workspace obsidian.Workspace
      post_set_workspace = function(client, workspace) end,
    },

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
      img_folder = "assets/imgs",
      confirm_img_paste = true,
      ---@param client obsidian.Client
      ---@param path obsidian.Path
      ---@return string
      img_text_func = function(client, path)
        local link_path
        local vault_relative_path = client:vault_relative_path(path)
        if vault_relative_path ~= nil then
          link_path = vault_relative_path
        else
          link_path = tostring(path)
        end
        local display_name = vim.fs.basename(link_path)
        return string.format("![%s](%s)", display_name, link_path)
      end,
    },
  })
end

return M
