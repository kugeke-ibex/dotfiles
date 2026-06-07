#!/usr/bin/env bash
# Hotkey ウィンドウ設定の自動チェック（Ctrl+Opt+W/G の手動トグル確認は別途）
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${HOME}/.nix-profile/bin:${PATH}"

WEZ=/Applications/WezTerm.app/Contents/MacOS/wezterm
GHOSTTY_CFG="${HOME}/.config/ghostty/config"
FAIL=0

ok() { printf '  OK  %s\n' "$1"; }
ng() {
  printf '  NG  %s\n' "$1"
  FAIL=1
}

echo "=== WezTerm hotkey ==="

if [[ ! -x $WEZ ]]; then
  ng "WezTerm.app not found"
else
  if ! "$WEZ" cli list-clients &>/dev/null 2>&1; then
    ng "WezTerm GUI not running (start with: wezterm start --workspace hotkey)"
  else
    ok "WezTerm GUI running"
    hotkey_json=$("$WEZ" cli list --format json | jq '[.[] | select(.workspace == "hotkey")]')
    count=$(echo "$hotkey_json" | jq 'length')
    if [[ $count -eq 0 ]]; then
      ng "no pane in workspace hotkey"
    else
      ok "hotkey workspace pane exists (count=$count)"
      wt=$(echo "$hotkey_json" | jq -r '.[0].window_title // ""')
      if [[ $wt == *"Hotkey"* ]]; then
        ok "window_title=$wt"
      else
        ng "window_title missing Hotkey (got: ${wt:-empty}) — Cmd+Shift+R"
      fi
    fi
  fi
fi

if [[ -x "${HOME}/.local/bin/toggle-wezterm-hotkey" ]]; then
  ok "toggle-wezterm-hotkey installed"
else
  ng "run: darwin-rebuild switch (toggle-wezterm-hotkey missing)"
fi

echo ""
echo "=== Ghostty (no quick-terminal) ==="

if [[ -f $GHOSTTY_CFG ]]; then
  ok "config at $GHOSTTY_CFG"
  if grep -q 'toggle_quick_terminal' "$GHOSTTY_CFG" 2>/dev/null; then
    ng "remove quick-terminal keybinds from ghostty config"
  else
    ok "quick-terminal disabled"
  fi
else
  ng "ghostty config not found"
fi

if pgrep -xq ghostty 2>/dev/null || pgrep -xq Ghostty 2>/dev/null; then
  ok "Ghostty process running"
else
  ng "Ghostty not running — launch once for Ctrl+Opt+G"
fi

if [[ -x "${HOME}/.local/bin/toggle-ghostty-hotkey" ]]; then
  ok "toggle-ghostty-hotkey installed"
else
  ng "run: darwin-rebuild switch (toggle-ghostty-hotkey missing)"
fi

echo ""
echo "=== Karabiner ==="
KARA="${HOME}/.config/karabiner/karabiner.json"
if grep -q 'karabiner-toggle-wezterm' "$KARA" 2>/dev/null; then
  ok "Ctrl+Opt+W -> karabiner-toggle-wezterm"
else
  ng "karabiner.json missing karabiner-toggle-wezterm"
fi

if grep -q 'karabiner-toggle-ghostty' "$KARA" 2>/dev/null; then
  ok "Ctrl+Opt+G -> karabiner-toggle-ghostty"
else
  ng "karabiner.json missing karabiner-toggle-ghostty"
fi

echo "  (manual) Accessibility: Karabiner-Elements (Ctrl+Opt+W/G)"

echo ""
if [[ $FAIL -eq 0 ]]; then
  echo "All automated checks passed."
  echo "Manual: Ctrl+Opt+W / Ctrl+Opt+G — show/hide toggle (iTerm2 hotkey window style)."
else
  echo "Some checks failed."
  exit 1
fi
