local wezterm = require("wezterm")
local M = {}
local name = "Sudo Nerd Font"

M.init = function()
  return name
end

M.activate = function(config)
  config.font = wezterm.font(name)
  -- config.freetype_load_target = "Light"
  -- config.freetype_render_target = "HorizontalLcd"
  config.font_size = 18.0
  config.line_height = 1.2
  config.harfbuzz_features = {}
  config.font_rules = {}
end

return M