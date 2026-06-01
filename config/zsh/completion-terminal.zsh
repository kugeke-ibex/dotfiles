# Tab 補完（DOTFILES_FZF_TAB_PLUGIN は modules/home/fzf-tab.nix が設定）
# 全ターミナル共通で fzf-tab を使う（以前は iTerm2 のみ zsh 標準メニューだった）。
# ターミナル判定 (_dotfiles_terminal_app) は見た目切替などでも共有するため残す。

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

  # iTerm2 / WezTerm / Ghostty いずれも fzf-tab に統一。
  if [[ -f "$root/config/zsh/completion/fzf-tab.zsh" ]]; then
    source "$root/config/zsh/completion/fzf-tab.zsh"
  fi
}

if [[ -o zle ]]; then
  _dotfiles_setup_tab_completion
fi
