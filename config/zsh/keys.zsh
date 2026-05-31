# ショートカット一覧: docs/keybindings/*.md と各アプリの実効キー
# shell.nix で DOTFILES_ROOT を export してから source される。
setopt NO_HIST_EXPAND 2>/dev/null || true

_dotfiles_root() {
  print -r -- "${DOTFILES_ROOT:-$HOME/Development/dotfiles}"
}

# ページャは less のみ（bat は日本語で化けやすいため使わない）
# LANG=C 等が入っていても表示時だけ UTF-8 を強制する
_keys_less() {
  env \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LESSSECURE=1 \
    LESS='-FXi' \
    command less -+FXi "$@"
}

_keys_pager_file() {
  local f="$1"
  if [[ ! -f "$f" ]]; then
    print -u2 "keys: not found: $f"
    return 1
  fi
  if [[ "$f" == *.json ]] && command -v jq >/dev/null 2>&1; then
    jq . "$f" | _keys_less
  else
    _keys_less "$f"
  fi
}

_keys_pager_stdin() {
  local tmp
  tmp="$(mktemp "${TMPDIR:-/tmp}/keys.XXXXXX")" || {
    print -u2 "keys: mktemp failed" >&2
    return 1
  }
  command cat >"$tmp"
  _keys_less "$tmp"
  local ret=$?
  command rm -f "$tmp"
  return ret
}

_keys_md() {
  _keys_pager_file "$1"
}

keys() {
  _keys_md "$(_dotfiles_root)/docs/keybindings/README.md"
}

keys-wezterm() {
  local root="$(_dotfiles_root)"
  local md="$root/docs/keybindings/wezterm.md"
  if [[ ! -f "$md" ]]; then
    print -u2 "keys: not found: $md"
    return 1
  fi
  {
    command cat "$md"
    print ""
    print "=== wezterm show-keys (effective) ==="
    print ""
    if command -v wezterm >/dev/null 2>&1; then
      command wezterm show-keys 2>/dev/null
    else
      print "(wezterm not found)"
    fi
  } | _keys_pager_stdin
}

keys-ghostty() {
  local root="$(_dotfiles_root)"
  local md="$root/docs/keybindings/ghostty.md"
  local cfg="$root/config/ghostty/config"
  if [[ ! -f "$md" ]]; then
    print -u2 "keys: not found: $md"
    return 1
  fi
  {
    command cat "$md"
    if [[ -f "$cfg" ]]; then
      print ""
      print "=== keybind lines (config/ghostty/config) ==="
      print ""
      command grep '^keybind' "$cfg" 2>/dev/null
    fi
  } | _keys_pager_stdin
}

keys-karabiner() {
  local root="$(_dotfiles_root)"
  local md="$root/docs/keybindings/karabiner.md"
  local json="$root/karabiner/karabiner.json"
  if [[ ! -f "$md" ]]; then
    print -u2 "keys: not found: $md"
    return 1
  fi
  {
    command cat "$md"
    if [[ -f "$json" ]] && command -v jq >/dev/null 2>&1; then
      print ""
      print "=== karabiner rules (description) ==="
      print ""
      command jq -r '.. | objects | select(has("description")) | .description' "$json" 2>/dev/null \
        | command sort -u
    fi
  } | _keys_pager_stdin
}

keys-cmux() {
  _keys_md "$(_dotfiles_root)/docs/keybindings/cmux.md"
}

keys-iterm() {
  local root="$(_dotfiles_root)"
  local md="$root/docs/keybindings/iterm2.md"
  local plist="$root/config/iterm2/com.googlecode.iterm2.plist"
  if [[ ! -f "$md" ]]; then
    print -u2 "keys: not found: $md"
    return 1
  fi
  {
    command cat "$md"
    if [[ -f "$plist" ]]; then
      print ""
      print "=== iTerm2 plist (hotkey / font / default profile) ==="
      print ""
      command plutil -p "$plist" 2>/dev/null \
        | command rg -i 'hotkey|Normal Font|Default Bookmark|GlobalKeyMap' \
        || command plutil -p "$plist" 2>/dev/null | command head -40
    fi
  } | _keys_pager_stdin
}

keys-nvim() {
  local root="$(_dotfiles_root)"
  case "${1:-}" in
    (--live|-l)
      command nvim -c 'map' -c 'set nomodifiable'
      return $?
      ;;
    (-h|--help)
      print "usage: keys-nvim [--live|-l]"
      return 0
      ;;
  esac
  _keys_md "$root/docs/keybindings/nvim.md"
}

keys-cursor() {
  _keys_pager_file "$(_dotfiles_root)/config/cursor/keybindings.json"
}

keys-vscode() {
  _keys_pager_file "$(_dotfiles_root)/config/vscode/keybindings.json"
}

alias kw='keys-wezterm'
alias kg='keys-ghostty'
alias kk='keys-karabiner'
alias kn='keys-nvim'
alias kc='keys-cmux'
alias ki='keys-iterm'
alias kcur='keys-cursor'
alias kvs='keys-vscode'
