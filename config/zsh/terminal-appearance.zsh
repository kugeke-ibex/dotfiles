# ターミナル別 Starship 設定（starship init より前に source すること）
# iTerm2: gruvbox-rainbow / WezTerm: tokyo-night / Ghostty: jetpack

: "${DOTFILES_ROOT:=$HOME/Development/dotfiles}"

if [[ -f "${DOTFILES_ROOT}/config/zsh/terminal-app.zsh" ]]; then
  source "${DOTFILES_ROOT}/config/zsh/terminal-app.zsh"
fi

_dotfiles_setup_starship_config() {
  emulate -L zsh
  local app root cfg
  # ターミナル起動直後は env が未設定のことがあるためキャッシュを無効化して再判定
  unset _DOTFILES_TERMINAL_APP
  app="$(_dotfiles_terminal_app)"
  root="${DOTFILES_ROOT}"
  case "$app" in
    (iterm2) cfg="$root/config/starship-iterm.toml" ;;
    (ghostty) cfg="$root/config/starship-ghostty.toml" ;;
    (wezterm|default|*) cfg="$root/config/starship.toml" ;;
  esac
  if [[ -f "$cfg" ]]; then
    export STARSHIP_CONFIG="$cfg"
  fi
}

if [[ -o interactive ]] && [[ "$TERM" != dumb ]]; then
  _dotfiles_setup_starship_config
fi
