local M = {
  "nvim-lualine/lualine.nvim",
}

function M.config()
  local colors = {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
  }

  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand "%:t") ~= 1
    end,
    hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
      local filepath = vim.fn.expand "%:p:h"
      local gitdir = vim.fn.finddir(".git", filepath .. ";")
      return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
  }

  local config = {
    options = {
      component_separators = "",
      section_separators = "",
      theme = "tokyonight",
    },
    sections = {
      -- these are to remove the defaults
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      -- These will be filled later
      lualine_c = {},
      lualine_x = {},
    },
    inactive_sections = {
      -- these are to remove the defaults
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
  }

  -- Inserts a component in lualine_c at left section
  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  -- Inserts a component in lualine_x at right section
  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  ins_left {
    function()
      return "▊"
    end,
    color = { fg = colors.blue }, -- Sets highlighting of component
    padding = { left = 0, right = 1 }, -- We don't need space before this
  }

  ins_left {
    -- mode component
    function()
      -- return "  "
      return " ✝ "
    end,
    color = function()
      -- auto change color according to neovims mode
      local mode_color = {
        n = colors.blue,
        i = colors.green,
        v = colors.blue,
        [""] = colors.blue,
        V = colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
  }

  ins_left {
    "filesize",
    cond = conditions.buffer_not_empty,
  }

  ins_left {
    "filename",
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta, gui = "bold" },
  }

  ins_left { "location" }

  ins_left { "progress", color = { fg = colors.fg, gui = "bold" } }

  ins_left {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " " },
    diagnostics_color = {
      error = { fg = colors.red },
      warn = { fg = colors.yellow },
      info = { fg = colors.cyan },
    },
  }

  ins_right {
    function()
      local ok, pomo = pcall(require, "pomo")
      if not ok then
        return ""
      end

      local timer = pomo.get_first_to_finish()
      if timer == nil then
        return ""
      end

      return "󰄉 " .. tostring(timer)
    end,
    color = { fg = colors.yellow, gui = "bold" },
    cond = conditions.hide_in_width,
  }

  ins_right {
    "fileformat",
    fmt = string.upper,
    icons_enabled = true,
    color = { fg = colors.green, gui = "bold" },
  }

  ins_right {
    "branch",
    icon = "",
    color = { fg = colors.violet, gui = "bold" },
  }

  ins_right {
    "diff",
    symbols = { added = " ", modified = "󰝤 ", removed = " " },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.orange },
      removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
  }

  ins_right {
    "filetype",
  }

  ins_right {
    function()
      return "▊"
    end,
    color = { fg = colors.blue },
    padding = { left = 1 },
  }

  require("lualine").setup(config)
end

return M
