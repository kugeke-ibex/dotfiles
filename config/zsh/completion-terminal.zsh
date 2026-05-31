# ターミナル別 Tab 補完（DOTFILES_FZF_TAB_PLUGIN は modules/home/fzf-tab.nix が設定）
# iTerm2: zsh 標準メニュー（cd 安定）。WezTerm / Ghostty / その他: fzf-tab。

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

_dotfiles_setup_tab_completion() {
  emulate -L zsh
  local app root
  app="$(_dotfiles_terminal_app)"
  typeset -g DOTFILES_COMPLETION="$app"
  root="${DOTFILES_ROOT:-$HOME/Development/dotfiles}"

  case "$app" in
    (iterm2)
      zstyle ':completion:*' menu select
      zstyle ':completion:*:descriptions' format '[%d]'
      if [[ -f "$root/config/zsh/completion/iterm2.zsh" ]]; then
        source "$root/config/zsh/completion/iterm2.zsh"
      fi
      ;;
    (*)
      if [[ -f "$root/config/zsh/completion/fzf-tab.zsh" ]]; then
        source "$root/config/zsh/completion/fzf-tab.zsh"
      fi
      ;;
  esac
}

if [[ -o zle ]]; then
  _dotfiles_setup_tab_completion
fi
