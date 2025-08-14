local M = {
  "nvim-lualine/lualine.nvim",
}

function M.config()
  local colors = {
    blue = "#51afef",
    green = "#98be65",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    yellow = "#ECBE7B",
    orange = "#FF8800",
    red = "#ec5f67",
    cyan = "#008080",
  }

  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand "%:t") ~= 1
    end,
    hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end,
  }

  local config = {
    options = {
      theme = "tokyonight",
      component_separators = "",
      section_separators = "",
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
  }

  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  -- Left side
  ins_left {
    function()
      return "▊"
    end,
    color = { fg = colors.blue },
    padding = { left = 0, right = 1 },
  }

  ins_left {
    function()
      return " ✝ "
    end,
    color = function()
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
    "filename",
    cond = conditions.buffer_not_empty,
    color = { gui = "bold" },
  }

  ins_left { "location" }

  ins_left {
    "progress",
    color = { gui = "bold" },
  }

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

  -- Right side
  ins_right {
    function()
      local ok, pomo = pcall(require, "pomo")
      if not ok then
        return ""
      end
      local timer = pomo.get_first_to_finish()
      return timer and ("󰄉 " .. tostring(timer)) or ""
    end,
    color = { fg = colors.yellow, gui = "bold" },
    cond = conditions.hide_in_width,
  }

  ins_right {
    "branch",
    icon = "",
    color = { fg = colors.violet, gui = "bold" },
    cond = conditions.hide_in_width,
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

  ins_right { "filetype", cond = conditions.hide_in_width }

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
