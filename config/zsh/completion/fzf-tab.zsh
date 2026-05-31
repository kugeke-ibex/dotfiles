# WezTerm / Ghostty / 未識別ターミナル: fzf-tab + eza プレビュー

zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:cd:*' fzf-flags --preview-window=right:50%

# git checkout などでソートを無効化 (fzf-tab README 推奨)
zstyle ':completion:*:git-checkout:*' sort false

if [[ -z "${DOTFILES_FZF_TAB_PLUGIN:-}" ]]; then
  local -a _ft_plugins
  _ft_plugins=(${^fpath}/fzf-tab/fzf-tab.plugin.zsh(N) ${^fpath}/fzf-tab.plugin.zsh(N))
  (( ${#_ft_plugins} )) && typeset -g DOTFILES_FZF_TAB_PLUGIN="${_ft_plugins[1]}"
  unset _ft_plugins
fi
if [[ -f "${DOTFILES_FZF_TAB_PLUGIN:-}" ]]; then
  source "${DOTFILES_FZF_TAB_PLUGIN}"
fi
