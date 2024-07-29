local M = {
	"epwalsh/pomo.nvim",
	version = "*",
	lazy = true,
	cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
	dependencies = {
		"rcarriga/nvim-notify",
	},
}

function M.config()
	require("pomo").setup({
		-- How often the notifiers are updated.
		update_interval = 1000,

		-- Configure the default notifiers to use for each timer.
		-- You can also configure different notifiers for timers given specific names, see
		-- the 'timers' field below.
		notifiers = {
			-- The "Default" notifier uses 'vim.notify' and works best when you have 'nvim-notify' installed.
			{
				name = "Default",
				opts = {
					sticky = true,

					-- Configure the display icons:
					title_icon = "󱎫",
					text_icon = "󰄉",
				},
			},

			-- The "System" notifier sends a system notification when the timer is finished.
			{ name = "System" },

			-- You can also define custom notifiers by providing an "init" function instead of a name.
			-- See "Defining custom notifiers" below for an example 👇
			-- { init = function(timer) ... end }
		},

		-- Override the notifiers for specific timer names.
		timers = {
			-- For example, use only the "System" notifier when you create a timer called "Break",
			-- e.g. ':TimerStart 2m Break'.
			Break = {
				{ name = "System" },
			},
		},
		sessions = {
			default = {
				{ name = "Work", duration = "25m" },
				{ name = "Short Break", duration = "5m" },
				{ name = "Work", duration = "25m" },
				{ name = "Short Break", duration = "5m" },
				{ name = "Work", duration = "25m" },
				{ name = "Long Break", duration = "15m" },
			},
		},
	})
end

return M
