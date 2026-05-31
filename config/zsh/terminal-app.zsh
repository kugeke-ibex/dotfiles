# 実行中ターミナルの識別（Tab 補完・Starship 切替で共有）

_dotfiles_terminal_app() {
  if [[ -n "${_DOTFILES_TERMINAL_APP:-}" ]]; then
    print -r -- "$_DOTFILES_TERMINAL_APP"
    return 0
  fi
  local app=default
  if [[ -n "${ITERM_SESSION_ID:-}" ]] || [[ "${TERM_PROGRAM:-}" == iTerm.app ]]; then
    app=iterm2
  elif [[ -n "${WEZTERM_EXECUTABLE:-}${WEZTERM_PANE:-}" ]] || [[ "${TERM_PROGRAM:-}" == WezTerm ]]; then
    app=wezterm
  elif [[ -n "${GHOSTTY_RESOURCES_DIR:-}" ]] || [[ "${TERM_PROGRAM:-}" == ghostty ]]; then
    app=ghostty
  fi
  typeset -g _DOTFILES_TERMINAL_APP="$app"
  print -r -- "$app"
}
