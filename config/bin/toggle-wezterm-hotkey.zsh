#!/usr/bin/env zsh
# Toggle WezTerm hotkey window (iTerm2 Hotkey Window 相当).
# Karabiner Ctrl+Opt+W — 補助アクセス不要（WezTerm Lua Hide + activate）
set -euo pipefail

if [[ -z "${HOME:-}" ]]; then
  HOME="/Users/$(/usr/bin/id -un)"
  export HOME
fi

HOTKEY_WS="hotkey"
LOG="${HOME}/.cache/toggle-wezterm-hotkey.log"
STATE_FILE="${HOME}/.cache/wezterm-hotkey-visible"

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/run/current-system/sw/bin:${HOME}/.nix-profile/bin"

log() {
  mkdir -p "${HOME}/.cache"
  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>"$LOG"
}

set_visible_state() { printf '%s' "$1" >"$STATE_FILE" }
get_visible_state() { [[ -f "$STATE_FILE" ]] && [[ "$(<"$STATE_FILE")" == "1" ]] }

if [[ -x /Applications/WezTerm.app/Contents/MacOS/wezterm ]]; then
  WEZTERM="/Applications/WezTerm.app/Contents/MacOS/wezterm"
elif command -v wezterm >/dev/null 2>&1; then
  WEZTERM="$(command -v wezterm)"
else
  log "error: wezterm not found"
  exit 1
fi

if [[ -x /usr/bin/jq ]]; then
  JQ=/usr/bin/jq
elif command -v jq >/dev/null 2>&1; then
  JQ="$(command -v jq)"
else
  log "error: jq not found"
  exit 1
fi

get_pane_id() {
  "$WEZTERM" cli list --format json 2>/dev/null | "$JQ" -r --arg ws "$HOTKEY_WS" '
    [.[] | select(.workspace == $ws)] | .[0].pane_id // empty
  ' || true
}

send_hotkey_hide() {
  local pid="$1"
  local b64
  b64=$(printf '%s' hide | base64 | tr -d '\n')
  local esc
  esc=$(printf '\033]1337;SetUserVar=hotkey_toggle=%s\007' "$b64")
  "$WEZTERM" cli send-text --pane-id "$pid" --no-paste "$esc" 2>>"$LOG" || true
}

launch_hotkey() {
  log "launch hotkey workspace"
  if "$WEZTERM" cli list-clients &>/dev/null 2>&1; then
    "$WEZTERM" cli spawn --new-window --workspace "$HOTKEY_WS" >/dev/null 2>&1 || \
      "$WEZTERM" start --workspace "$HOTKEY_WS" &
  else
    /usr/bin/open -na "WezTerm.app" --args start --workspace "$HOTKEY_WS"
  fi
  local i pid=""
  for i in {1..30}; do
    sleep 0.1
    pid=$(get_pane_id)
    [[ -n "$pid" ]] && break
  done
  echo "$pid"
}

show_hotkey() {
  local pid="$1"
  log "show hotkey pane_id=${pid:-none}"
  if [[ -z "$pid" ]]; then
    pid=$(launch_hotkey)
  fi
  [[ -n "$pid" ]] && "$WEZTERM" cli activate-pane --pane-id "$pid" 2>/dev/null || true
  /usr/bin/open -a WezTerm.app 2>/dev/null || true
  /usr/bin/osascript -e 'tell application "WezTerm" to activate' 2>>"$LOG" || true
  set_visible_state 1
}

hide_hotkey() {
  local pid="$1"
  log "hide hotkey pane_id=${pid:-none}"
  [[ -n "$pid" ]] && send_hotkey_hide "$pid"
  set_visible_state 0
}

# --- main ---

if ! "$WEZTERM" cli list-clients &>/dev/null 2>&1; then
  show_hotkey "$(launch_hotkey)"
  exit 0
fi

pane_id=$(get_pane_id)
if [[ -z "$pane_id" ]]; then
  set_visible_state 0
  show_hotkey "$(launch_hotkey)"
  exit 0
fi

if get_visible_state; then
  hide_hotkey "$pane_id"
else
  show_hotkey "$pane_id"
fi
