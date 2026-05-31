#!/usr/bin/env zsh
# Toggle WezTerm "hotkey" workspace window (iTerm2 Hotkey Window 相当).
set -euo pipefail

HOTKEY_WS="hotkey"
HOTKEY_TITLE="WezTerm Hotkey"
WEZTERM="${WEZTERM:-$(command -v wezterm)}"

if ! command -v "$WEZTERM" >/dev/null 2>&1; then
  echo "toggle-wezterm-hotkey: wezterm not found" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "toggle-wezterm-hotkey: jq not found" >&2
  exit 1
fi

# GUI 未起動 → hotkey ワークスペースで起動
if ! "$WEZTERM" cli list-clients &>/dev/null 2>&1; then
  "$WEZTERM" start --workspace "$HOTKEY_WS" &
  exit 0
fi

pane_id=$("$WEZTERM" cli list --format json | jq -r --arg ws "$HOTKEY_WS" '
  [.[] | select(.workspace == $ws)] | .[0].pane_id // empty
')

# hotkey ウィンドウが無い → 追加起動 (gui-startup でレイアウト)
if [[ -z "$pane_id" ]]; then
  "$WEZTERM" start --workspace "$HOTKEY_WS"
  exit 0
fi

"$WEZTERM" cli activate-pane --pane-id "$pane_id" 2>/dev/null || true

osascript <<APPLESCRIPT
on run
  set hotkeyTitle to "$HOTKEY_TITLE"
  tell application "System Events"
    if not (exists process "WezTerm") then return
    tell process "WezTerm"
      set hotkeyWindows to (every window whose name contains hotkeyTitle)
      if (count of hotkeyWindows) is 0 then return
      set w to item 1 of hotkeyWindows
      if value of attribute "AXMinimized" of w is true then
        set value of attribute "AXMinimized" of w to false
        perform action "AXRaise" of w
      else
        try
          set focusedName to name of (value of attribute "AXFocusedWindow")
        on error
          set focusedName to ""
        end try
        if focusedName contains hotkeyTitle then
          set value of attribute "AXMinimized" of w to true
        else
          perform action "AXRaise" of w
        end if
      end if
    end tell
  end tell
  tell application "WezTerm" to activate
end run
APPLESCRIPT
