#!/bin/sh
# Karabiner Ctrl+Opt+W 用ラッパー（env -i でも動く・ログ付き）
set -eu

if [ -z "${HOME:-}" ]; then
  HOME="/Users/$(/usr/bin/id -un)"
  export HOME
fi

LOG="${HOME}/.cache/karabiner-hotkey.log"
mkdir -p "${HOME}/.cache"
printf '%s karabiner-toggle-wezterm\n' "$(date '+%Y-%m-%d %H:%M:%S')" >>"$LOG"

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

DOTFILES="${HOME}/Development/dotfiles/config/bin/toggle-wezterm-hotkey.zsh"
SCRIPT="${HOME}/.local/bin/toggle-wezterm-hotkey"
if [ -f "$DOTFILES" ]; then
  SCRIPT="$DOTFILES"
elif [ ! -x "$SCRIPT" ]; then
  echo "toggle-wezterm-hotkey not found" >>"$LOG"
  exit 1
fi

exec /bin/zsh -f "$SCRIPT" >>"$LOG" 2>&1
