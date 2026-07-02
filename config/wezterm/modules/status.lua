-- 右ステータス（日時・バッテリー・分割ペイン時のペイン番号）とタブタイトル
-- キーバインド・color_scheme は wezterm.lua 側の方針を維持（重複させない）

local wezterm = require("wezterm")

local function get_pane_info(window)
	local tab = window:active_tab()
	if not tab then
		return ""
	end
	local panes = tab:panes_with_info()
	if #panes < 2 then
		return ""
	end

	for i, p in ipairs(panes) do
		if p.is_active then
			return string.format("💻 Pane %d/%d", i, #panes)
		end
	end
	return ""
end

local function get_battery_info()
	local parts = {}
	for _, b in ipairs(wezterm.battery_info()) do
		local pct = b.state_of_charge * 100
		local icon = "🌑 "
		if pct >= 80 then
			icon = "🌕 "
		elseif pct >= 50 then
			icon = "🌗 "
		elseif pct >= 20 then
			icon = "🌘 "
		end
		table.insert(parts, string.format("%s%.0f%%", icon, pct))
	end
	return table.concat(parts, " ")
end

local wday_ja = { "日", "月", "火", "水", "木", "金", "土" }

local function register_update_status()
	wezterm.on("update-status", function(window, _pane)
		local pane_info = get_pane_info(window)
		local bat = get_battery_info()

		local wday = os.date("*t").wday
		local wday_str = string.format("(%s)", wday_ja[wday] or "?")
		local date = wezterm.strftime("📆 %Y-%m-%d " .. wday_str .. " ⏰ %H:%M:%S")

		local status_parts = {}
		if pane_info ~= "" then
			table.insert(status_parts, pane_info)
		end
		if bat ~= "" then
			table.insert(status_parts, bat)
		end
		table.insert(status_parts, date)

		window:set_right_status(wezterm.format({
			{ Text = table.concat(status_parts, " | ") },
		}))
	end)
end

local function register_format_tab_title()
	wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, _max_width)
		local tab_index = tab.tab_index + 1

		local ap = tab.active_pane

		if tab.is_active and ap then
			if ap.title and string.match(ap.title, "Copy mode:") then
				return string.format(" %d %s ", tab_index, "Copy mode…📄")
			end
			if ap.is_zoomed then
				return string.format(" %d %s ", tab_index, "Zoom…🔍")
			end
		end

		-- config/zsh/ai-agents.zsh が SetUserVar で送る agent / git ブランチを表示
		-- （cmux の「タブに状態表示」に相当）
		local extra = ""
		if ap and ap.user_vars then
			local agent = ap.user_vars.agent
			local branch = ap.user_vars.git_branch
			if agent and agent ~= "" then
				extra = extra .. " 🤖" .. agent
			end
			if branch and branch ~= "" then
				extra = extra .. "  " .. branch
			end
		end

		return string.format(" %d%s ", tab_index, extra)
	end)
end

local M = {}

function M.apply_to_config(_config)
	register_update_status()
	register_format_tab_title()
end

return M
