local wezterm = require("wezterm")
local M = {}
local name = "JetBrains Mono"

M.init = function()
  return name
end

M.activate = function(config)
  config.font = wezterm.font(name)
  -- config.freetype_load_target = "Light"
  -- config.freetype_render_target = "HorizontalLcd"
  config.font_size = 17.0
  config.line_height = 1.2
  config.harfbuzz_features = {}
  config.font_rules = {
    {
      intensity = "Normal",
      italic = false,
      font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" }),
    },
    {
      intensity = "Normal",
      italic = true,
      font = wezterm.font("JetBrainsMono Nerd Font", { weight = 325, style = "Italic" }),
    },
    {
      intensity = "Bold",
      italic = false,
      font = wezterm.font("JetBrainsMono Nerd Font", { weight = "ExtraBold" }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold", style = "Italic" }),
    },
  }
end

return M
