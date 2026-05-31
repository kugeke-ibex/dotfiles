# ショートカット一覧: docs/keybindings/*.md と各アプリの実効キー
# shell.nix で DOTFILES_ROOT を export してから source される。
setopt NO_HIST_EXPAND 2>/dev/null || true

_dotfiles_root() {
  print -r -- "${DOTFILES_ROOT:-$HOME/Development/dotfiles}"
}

# bat 優先（Markdown / JSON のハイライト）。無いときだけ less にフォールバック。
# LANG=C 等が入っていても表示時だけ UTF-8 を強制する（日本語ドキュメント用）。
_keys_utf8_env() {
  env \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    "$@"
}

# 対話 TTY: bat → less でページ送り（:q で終了）。programs.bat.config.pager 参照。
# 非 TTY / パイプ: 装飾付きで一括出力。TERM=dumb は --color=always。
_keys_bat() {
  local -a bat_args=()
  if [[ -t 1 ]]; then
    bat_args=(--paging=always)
    [[ "${TERM:-}" == dumb ]] && bat_args+=(--color=always)
  else
    bat_args=(--paging=never --color=always --style=full)
  fi
  if [[ -t 1 ]]; then
    # bat 既定の less -FRX に加え、旧 keys の less -+FXi 相当（:q / q で終了）
    _keys_utf8_env LESS='-FXi' BAT_PAGER='less -+FXi -R' command bat "${bat_args[@]}" "$@"
  else
    _keys_utf8_env command bat "${bat_args[@]}" "$@"
  fi
}

_keys_less() {
  _keys_utf8_env \
    LESSSECURE=1 \
    LESS='-FXi' \
    command less -+FXi "$@"
}

_keys_pager() {
  if command -v bat >/dev/null 2>&1; then
    _keys_bat "$@"
  else
    _keys_less "$@"
  fi
}

_keys_pager_file() {
  local f="$1"
  if [[ ! -f "$f" ]]; then
    print -u2 "keys: not found: $f"
    return 1
  fi
  if [[ "$f" == *.json ]] && command -v jq >/dev/null 2>&1; then
    if command -v bat >/dev/null 2>&1; then
      local -a bat_args=(--language=json -)
      if [[ -t 1 ]]; then
        bat_args=(--paging=always "${bat_args[@]}")
        [[ "${TERM:-}" == dumb ]] && bat_args+=(--color=always)
      else
        bat_args=(--paging=never --color=always --style=full "${bat_args[@]}")
      fi
      if [[ -t 1 ]]; then
        jq . "$f" | _keys_utf8_env LESS='-FXi' BAT_PAGER='less -+FXi -R' command bat "${bat_args[@]}"
      else
        jq . "$f" | _keys_utf8_env command bat "${bat_args[@]}"
      fi
    else
      jq . "$f" | _keys_less
    fi
  else
    _keys_pager "$f"
  fi
}

_keys_pager_stdin() {
  local suffix="${1:-md}"
  local tmp
  tmp="$(mktemp "${TMPDIR:-/tmp}/keys.XXXXXX.${suffix}")" || {
    print -u2 "keys: mktemp failed" >&2
    return 1
  }
  command cat >"$tmp"
  _keys_pager "$tmp"
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
  } | _keys_pager_stdin md
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
  } | _keys_pager_stdin md
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
  } | _keys_pager_stdin md
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
  } | _keys_pager_stdin md
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
