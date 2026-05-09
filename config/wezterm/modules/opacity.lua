-- Opacity 切替モジュール（setting_mode 用のキーバインドを提供）
--
-- setting_mode (wezterm.lua で定義) に以下のキーを差し込む:
--   ; → 透過度 +0.1
--   - → 透過度 -0.1
--   0 → 透過度を config の値にリセット
-- (Esc で setting_mode を抜ける。Esc は wezterm.lua 側で定義済み)
--
-- `window-focus-changed` でフォーカスごとに opacity を上書きする方式は採用しない
-- （手動で変えた値が勝手に戻されるのを避けるため）。

local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

function module.apply_to_config(config)
  config.key_tables = config.key_tables or {}
  config.key_tables.setting_mode = config.key_tables.setting_mode or {
    { key = "Escape", action = "PopKeyTable" },
  }

  table.insert(config.key_tables.setting_mode, { key = ";", action = act.EmitEvent("increase-opacity") })
  table.insert(config.key_tables.setting_mode, { key = "-", action = act.EmitEvent("decrease-opacity") })
  table.insert(config.key_tables.setting_mode, { key = "0", action = act.EmitEvent("reset-opacity") })
end

local function reactivate_setting_mode(window)
  window:perform_action(
    wezterm.action.ActivateKeyTable({ name = "setting_mode", one_shot = false }),
    window:active_pane()
  )
end

local function adjust_opacity(window, delta, config)
  local overrides = window:get_config_overrides() or {}
  local current = overrides.window_background_opacity or config.window_background_opacity or 1.0

  local new_opacity = current + delta
  new_opacity = math.max(0.1, math.min(1.0, new_opacity))

  overrides.window_background_opacity = new_opacity
  window:set_config_overrides(overrides)

  reactivate_setting_mode(window)
end

wezterm.on("decrease-opacity", function(window, config)
  adjust_opacity(window, -0.1, config)
end)

wezterm.on("increase-opacity", function(window, config)
  adjust_opacity(window, 0.1, config)
end)

wezterm.on("reset-opacity", function(window, config)
  local overrides = window:get_config_overrides() or {}
  overrides.window_background_opacity = config.window_background_opacity
  window:set_config_overrides(overrides)

  reactivate_setting_mode(window)
end)

return module
