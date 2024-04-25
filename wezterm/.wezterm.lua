local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local fonts = {
	"JetBrainsMono Nerd Font",
	"Geist Mono",
	"SF Mono",
	"Monaspace Neon",
	"Monaspace Xenon",
	"Monaspace Krypton",
	"Monaspace Radon",
	"Monaspace Argon",
	"Comic Code Ligatures",
}
local emoji_fonts = { "Apple Color Emoji", "Joypixels", "Twemoji", "Noto Color Emoji", "Noto Emoji" }

config.harfbuzz_features =
	{ "calt", "liga", "zero", "-ss01", "ss02", "-ss03", "ss04", "ss05", "-ss06", "-ss07", "-ss08", "-ss09", "ss10", "ss11", "ss12", "-ss13", "ss14", "ss15", "ss16", "ss17", "ss18" }
config.font = wezterm.font_with_fallback({ fonts[1], emoji_fonts[1], emoji_fonts[2] })
-- config.disable_default_key_bindings = true
config.front_end = "WebGpu"
config.enable_scroll_bar = false
config.scrollback_lines = 10240
config.font_size = 18
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.automatically_reload_config = true
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.initial_cols = 145
config.initial_rows = 40
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
-- config.window_decorations = "RESIZE|TITLE"
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
	left = 15,
	right = 15,
	top = 20,
	bottom = 10,
}
config.window_frame = {
	font = wezterm.font({ family = "SF Mono" }),
	-- font = wezterm.font({ family = "Geist Mono" }),
	active_titlebar_bg = "#1e1e1e",
	inactive_titlebar_bg = "#1e1e1e",
	font_size = 15.0,
}

config.color_scheme = "OneDark (base16)"
config.color_scheme = "OneDark"
config.color_schemes = {
	["OneDark"] = {
		foreground = "#f0f6fc",
		background = "#1e1e1e",
		-- background = "#21262d",
		-- background = "#1e1e2e",
		-- background = "#1a1b26",
		cursor_bg = "#b1cad8",
		cursor_fg = "#21262d",
		cursor_border = "#CF7277",
		selection_fg = "#21262d",
		selection_bg = "#2A4668",
		scrollbar_thumb = "#30363d",
		split = "#6e7681",

		ansi = {
			"#8b949e",
			"#ff7b72",
			"#aff5b4",
			"#FFE08C",
			"#79c0ff",
			"#d2a8ff",
			"#a5d6ff",
			"#c9d1d9",
		},
		brights = {

			"#8b949e",
			"#ff7b72",
			"#aff5b4",
			"#FFE08C",
			"#79c0ff",
			"#d2a8ff",
			"#a5d6ff",
			"#c9d1d9",
		},
	},
}

config.colors = {
	tab_bar = {
		background = "#808080",
		active_tab = {
			bg_color = "#1e1e1e",
			fg_color = "#c8c8c8",
		},
		inactive_tab = {
			bg_color = "#30363d",
			fg_color = "#8b949e",
		},
		inactive_tab_hover = {
			bg_color = "#484f58",
			fg_color = "#b1bac4",
		},
		new_tab = {
			bg_color = "#30363d",
			fg_color = "#8b949e",
		},
		new_tab_hover = {
			bg_color = "#484f58",
			fg_color = "#b1bac4",
		},
	},
}

-- local act = wezterm.action

-- config.keys = {
-- 	{ key = "a", mods = "ctrl", action = act.ActivateTabRelative(-1) },
-- 	{ key = "b", mods = "ctrl", action = act.ActivateTabRelative(1) },
-- }

return config
