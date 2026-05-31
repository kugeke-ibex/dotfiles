-- iTerm2 Hotkey Window 相当: workspace "hotkey" をドロップダウン表示し、外部からトグルする。
-- トグル: ~/.local/bin/toggle-wezterm-hotkey (Karabiner Ctrl+Opt+W)

local wezterm = require("wezterm")
local mux = wezterm.mux

local HOTKEY_WORKSPACE = "hotkey"
local HOTKEY_TITLE = "WezTerm Hotkey"

local function configure_hotkey_window(gui)
	local screen = wezterm.gui.screens().active
	local height = math.floor(screen.height * 0.4)
	gui:set_position(screen.x, screen.y)
	gui:set_inner_size(screen.width, height)
	pcall(function()
		gui:set_window_level("FloatingWindow")
	end)
end

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	local gui = window:gui_window()
	local workspace = (cmd and cmd.workspace) or "default"

	if workspace == HOTKEY_WORKSPACE then
		window:set_name(HOTKEY_TITLE)
		mux.set_active_workspace(HOTKEY_WORKSPACE)
		configure_hotkey_window(gui)
	else
		gui:maximize()
	end
end)

return {
	apply_to_config = function(_config) end,
	HOTKEY_WORKSPACE = HOTKEY_WORKSPACE,
	HOTKEY_TITLE = HOTKEY_TITLE,
}
