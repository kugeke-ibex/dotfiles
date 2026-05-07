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

-- Keybindings (iTerm2 / tmux 風)
local act = wezterm.action
config.keys = {
  -- ペイン分割
  { key = "d", mods = "CMD",       action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical   { domain = "CurrentPaneDomain" } },

  -- ペイン間移動 (Cmd+Opt+hjkl)
  { key = "h", mods = "CMD|OPT", action = act.ActivatePaneDirection "Left"  },
  { key = "j", mods = "CMD|OPT", action = act.ActivatePaneDirection "Down"  },
  { key = "k", mods = "CMD|OPT", action = act.ActivatePaneDirection "Up"    },
  { key = "l", mods = "CMD|OPT", action = act.ActivatePaneDirection "Right" },

  -- ペインリサイズ (Ctrl+Shift+Arrow)
  { key = "LeftArrow",  mods = "CTRL|SHIFT", action = act.AdjustPaneSize { "Left",  5 } },
  { key = "DownArrow",  mods = "CTRL|SHIFT", action = act.AdjustPaneSize { "Down",  5 } },
  { key = "UpArrow",    mods = "CTRL|SHIFT", action = act.AdjustPaneSize { "Up",    5 } },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = act.AdjustPaneSize { "Right", 5 } },

  -- ペイン操作
  { key = "w",     mods = "CMD", action = act.CloseCurrentPane { confirm = true } },
  { key = "z",     mods = "CMD", action = act.TogglePaneZoomState },
  { key = "Enter", mods = "CMD", action = act.ToggleFullScreen },

  -- スクロールバッククリア (Cmd+K)
  { key = "k", mods = "CMD", action = act.ClearScrollback "ScrollbackAndViewport" },

  -- コピーモード (Cmd+[)
  { key = "[", mods = "CMD", action = act.ActivateCopyMode },

  -- 設定リロード
  { key = "r", mods = "CMD|SHIFT", action = act.ReloadConfiguration },
}

return config
