-- AI コーディングエージェント用ランチャ（1 タブ = 1 エージェントの専用ターミナル体験）。
--
-- Cmd+Shift+A を prefix にした agent_mode（one_shot）を提供し、次の 1 キーで
-- 各エージェントを起動する:
--   c → 新規タブで Claude Code
--   x → 新規タブで Codex
--   g → 新規タブで Gemini
--   h → 新規タブで herdr（ターミナル内マルチプレクサ。以後は herdr が複数 agent を管理）
--   s → 右 split で Claude（並列作業用）
--   Escape / その他キー → キャンセル（one_shot なので自動で抜ける）
--
-- 各エージェントの生コマンド（claude/codex/gemini）や herdr を新規タブ/split に
-- 送信して起動するだけ。agent の状態表示・並列管理は herdr 側が担当する。

local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

-- 新規タブを開いてエージェントを起動
local function tab_launch(launcher)
	return act.Multiple({
		act.SpawnTab("CurrentPaneDomain"),
		act.SendString(launcher .. "\n"),
	})
end

-- 右に split してエージェントを起動（並列作業）
local function split_launch(launcher)
	return act.Multiple({
		act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		act.SendString(launcher .. "\n"),
	})
end

function M.apply_to_config(config)
	config.key_tables = config.key_tables or {}
	config.key_tables.agent_mode = {
		{ key = "c", action = tab_launch("claude") },
		{ key = "x", action = tab_launch("codex") },
		{ key = "g", action = tab_launch("gemini") },
		{ key = "h", action = tab_launch("herdr") },
		{ key = "s", action = split_launch("claude") },
		{ key = "Escape", action = "PopKeyTable" },
	}

	config.keys = config.keys or {}
	table.insert(config.keys, {
		key = "a",
		mods = "CMD|SHIFT",
		action = act.ActivateKeyTable({
			name = "agent_mode",
			one_shot = true,
			timeout_milliseconds = 2000,
		}),
	})
end

return M
