local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
  "MesloLGS NF",
  "Ricty Diminished",
})
config.font_size = 14.0
config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.hide_tab_bar_if_only_one_tab = true
config.use_ime = true
config.scrollback_lines = 50000
config.audible_bell = "Disabled"
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

return config
