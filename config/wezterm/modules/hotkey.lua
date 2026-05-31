-- iTerm2 Hotkey Window 相当: workspace `hotkey` 専用ウィンドウ（オーバーレイではない）
-- トグル: ~/.local/bin/toggle-wezterm-hotkey (Karabiner Ctrl+Opt+W)

local wezterm = require("wezterm")
local mux = wezterm.mux

local HOTKEY_WORKSPACE = "hotkey"
local HOTKEY_TITLE = "WezTerm Hotkey"

local function setup_hotkey_window(window)
	local pane = window:active_pane()
	pane:set_user_var("hotkey_window", "1")
	window:set_title(HOTKEY_TITLE)
	window:gui_window():maximize()
end

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	local workspace = (cmd and cmd.workspace) or "default"

	if workspace == HOTKEY_WORKSPACE then
		setup_hotkey_window(window)
	else
		window:gui_window():maximize()
	end
end)

wezterm.on("format-window-title", function(_tab, pane, _tabs, _panes, _config)
	if pane.user_vars.hotkey_window == "1" then
		return HOTKEY_TITLE
	end
end)

-- Karabiner トグルから OSC 1337 で hotkey_toggle=hide を送り、補助アクセスなしで最小化
wezterm.on("user-var-changed", function(window, pane, name, value)
	if name ~= "hotkey_toggle" or value ~= "hide" then
		return
	end
	if pane:get_user_vars().hotkey_window ~= "1" then
		return
	end
	window:perform_action(wezterm.action.Hide, pane)
end)

return {
	apply_to_config = function(_config) end,
	HOTKEY_WORKSPACE = HOTKEY_WORKSPACE,
	HOTKEY_TITLE = HOTKEY_TITLE,
}
