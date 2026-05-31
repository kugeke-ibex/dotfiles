# ターミナル別 Tab 補完（DOTFILES_FZF_TAB_PLUGIN は modules/home/fzf-tab.nix が設定）
# iTerm2: zsh 標準メニュー（cd 安定）。WezTerm / Ghostty / その他: fzf-tab。

: "${DOTFILES_ROOT:=$HOME/Development/dotfiles}"
if [[ -f "${DOTFILES_ROOT}/config/zsh/terminal-app.zsh" ]]; then
  source "${DOTFILES_ROOT}/config/zsh/terminal-app.zsh"
fi

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
