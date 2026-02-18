local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

function M.config()
  local alpha = require "alpha"
  local dashboard = require "alpha.themes.dashboard"

  -- ┌──────────────────────────────────────────┐
  -- │  Header                                  │
  -- └──────────────────────────────────────────┘
  dashboard.section.header.val = {
    [[                                                    ]],
    [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
    [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
    [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
    [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
    [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
    [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
    [[                                                    ]],
  }

  -- ┌──────────────────────────────────────────┐
  -- │  Buttons                                 │
  -- └──────────────────────────────────────────┘
  local icons = require "config.icons"
  local i = icons.ui

  dashboard.section.buttons.val = {
    dashboard.button("f", i.FindFile .. "  Find File", "<cmd>Telescope find_files<CR>"),
    dashboard.button("t", i.FindText .. "  Find Text", "<cmd>Telescope live_grep<CR>"),
    dashboard.button("r", i.History .. "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
    dashboard.button("n", i.NewFile .. "  New File", "<cmd>ene<CR>"),
    dashboard.button("g", icons.git.Repo .. "  Git", "<cmd>Neogit<CR>"),
    dashboard.button("c", i.Gear .. "  Config", "<cmd>edit $MYVIMRC<CR>"),
    dashboard.button("l", i.Package .. "  Lazy", "<cmd>Lazy<CR>"),
    dashboard.button("q", i.SignOut .. "  Quit", "<cmd>qa<CR>"),
  }

  -- ┌──────────────────────────────────────────┐
  -- │  Footer                                  │
  -- └──────────────────────────────────────────┘
  dashboard.section.footer.val = function()
    local stats = require("lazy").stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    return "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
  end

  -- ┌──────────────────────────────────────────┐
  -- │  Highlights (tokyonight-night palette)   │
  -- └──────────────────────────────────────────┘
  dashboard.section.header.opts.hl = "AlphaHeader"
  dashboard.section.buttons.opts.hl = "AlphaButtons"
  dashboard.section.footer.opts.hl = "AlphaFooter"

  vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = function()
      -- Header: tokyonight blue
      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7aa2f7", bold = true })
      -- Shortcut keys: tokyonight magenta
      vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#bb9af7", bold = true })
      -- Button text: tokyonight foreground
      vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#c0caf5" })
      -- Footer: tokyonight green
      vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#9ece6a", italic = true })
    end,
  })

  -- ┌──────────────────────────────────────────┐
  -- │  Layout                                  │
  -- └──────────────────────────────────────────┘
  dashboard.config.layout = {
    { type = "padding", val = 4 },
    dashboard.section.header,
    { type = "padding", val = 2 },
    dashboard.section.buttons,
    { type = "padding", val = 2 },
    {
      type = "text",
      val = function()
        local fn = dashboard.section.footer.val
        if type(fn) == "function" then
          return fn()
        end
        return fn
      end,
      opts = { hl = "AlphaFooter", position = "center" },
    },
  }

  dashboard.config.opts.noautocmd = true

  alpha.setup(dashboard.config)

  -- Hide statusline and tabline on dashboard
  vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaReady",
    callback = function()
      vim.opt_local.laststatus = 0
      vim.opt_local.showtabline = 0
      vim.opt_local.winbar = nil
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "AlphaClosed",
    callback = function()
      vim.opt_local.laststatus = 3
    end,
  })
end

return M
