#!/usr/bin/env zsh
# Toggle Ghostty window (iTerm2 Hotkey Window 相当).
# Karabiner Ctrl+Opt+G — Ghostty AppleScript toggle_visibility（補助アクセス不要）
set -euo pipefail

if [[ -z "${HOME:-}" ]]; then
  HOME="/Users/$(/usr/bin/id -un)"
  export HOME
fi

APP_NAME="Ghostty"
PROCESS_NAME="ghostty"
LOG="${HOME}/.cache/toggle-ghostty-hotkey.log"

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

log() {
  mkdir -p "${HOME}/.cache"
  printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >>"$LOG"
}

toggle_ghostty_visibility() {
  /usr/bin/osascript 2>>"$LOG" <<'APPLESCRIPT'
tell application "Ghostty"
  if (count of windows) is 0 then
    return "show"
  end if
  set t to focused terminal of front tab of front window
  perform action "toggle_visibility" on t
end tell
APPLESCRIPT
}

show_ghostty() {
  log "show Ghostty (launch)"
  /usr/bin/open -a "$APP_NAME"
}

# --- main ---

if ! /usr/bin/pgrep -xq "$PROCESS_NAME" 2>/dev/null; then
  show_ghostty
  exit 0
fi

if toggle_ghostty_visibility; then
  log "toggle_visibility ok"
else
  log "toggle_visibility failed; open Ghostty"
  show_ghostty
fi
