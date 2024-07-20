local wezterm = require("wezterm")
local color_scheme = require("modules.colorscheme")
local font = require("modules.font")
local window = require("modules.window")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

window.update_config(config)
color_scheme.update_config(config)
font.update_config(config)

return config
