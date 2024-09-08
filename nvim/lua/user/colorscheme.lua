local M = {
<<<<<<< HEAD
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
=======
  "ellisonleao/gruvbox.nvim",
  name = "gruvbox",
  lazy = false,
  priority = 1000,
>>>>>>> 97cfeff (add tmux config)
}

function M.config()
  require("gruvbox").setup {
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = true,
      emphasis = true,
      comments = true,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
  }

<<<<<<< HEAD
		enable = {
			terminal = true,
			legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
			migrations = true, -- Handle deprecated options automatically
		},

		styles = {
			bold = true,
			italic = true,
			transparency = false,
		},

		groups = {
			border = "muted",
			link = "iris",
			panel = "surface",

			error = "love",
			hint = "iris",
			info = "foam",
			note = "pine",
			todo = "rose",
			warn = "gold",

			git_add = "foam",
			git_change = "rose",
			git_delete = "love",
			git_dirty = "rose",
			git_ignore = "muted",
			git_merge = "iris",
			git_rename = "pine",
			git_stage = "iris",
			git_text = "rose",
			git_untracked = "subtle",

			h1 = "iris",
			h2 = "foam",
			h3 = "rose",
			h4 = "gold",
			h5 = "pine",
			h6 = "foam",
		},

		highlight_groups = {
			-- Comment = { fg = "foam" },
			-- VertSplit = { fg = "muted", bg = "muted" },
		},

		before_highlight = function(group, highlight, palette)
			-- Disable all undercurls
			-- if highlight.undercurl then
			--     highlight.undercurl = false
			-- end
			--
			-- Change palette colour
			-- if highlight.fg == palette.pine then
			--     highlight.fg = palette.foam
			-- end
		end,
	})

	-- vim.cmd("colorscheme rose-pine")
	vim.cmd("colorscheme rose-pine-main")
	-- vim.cmd("colorscheme rose-pine-moon")
	-- vim.cmd("colorscheme rose-pine-dawn")

  -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
=======
  vim.cmd "colorscheme gruvbox"
>>>>>>> 97cfeff (add tmux config)
end

return M
