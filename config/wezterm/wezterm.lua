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

-- 設定ファイルの変更を自動で読み込む
config.automatically_reload_config = true

-- ステータスバー更新間隔 (デフォルト 1000ms から少し緩める)
config.status_update_interval = 1500

-- 非アクティブペインを少し暗くして、どこにフォーカスがあるかを視覚化
config.inactive_pane_hsb = {
  hue = 1.0,
  saturation = 0.9,
  brightness = 0.85,
}

-- ウィンドウ全体を閉じる時の確認ダイアログ無効
-- (Cmd+W のペイン閉じには別途 confirm = true が効く)
config.window_close_confirmation = "NeverPrompt"

-- QuickSelect (デフォルト Ctrl+Shift+Space) のパターンをカスタマイズ。
-- mozumasu/dotfiles の wezterm.lua から流用。日常的に拾いたいトークンを網羅。
config.disable_default_quick_select_patterns = true
config.quick_select_patterns = {
  -- URL
  "\\bhttps?://[\\w\\-._~:/?#@!$&'()*+,;=%]+",
  -- AWS ARN
  "\\barn:[\\w\\-]+:[\\w\\-]+:[\\w\\-]*:[0-9]*:[\\w\\-/:]+",
  -- ファイルパス: スペース・記号の後にあるもの (行頭プロンプトを除外)
  "(?<=[\\s:=(\"'`])(?:~|/)[/\\w\\-.@~]+",
  -- ファイルパス: 行頭かつ行末まで (pwd 出力など)
  "(?m)^(?:~|/)[/\\w\\-.@~]+(?=\\s*$)",
  -- Git commit hash (7-40 chars)
  "\\b[0-9a-f]{7,40}\\b",
  -- IP address (IPv4)
  "\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b",
  -- UUID
  "\\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\\b",
  -- kebab-case / snake_case 識別子 (2 セグメント以上)
  "\\b[a-zA-Z][a-zA-Z0-9]*(?:[_-][a-zA-Z0-9]+){1,}\\b",
  -- メールアドレス
  "\\b[\\w.+-]+@[\\w.-]+\\.[a-zA-Z]{2,}\\b",
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
