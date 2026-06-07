# PC 共通の zsh エイリアス / 関数。
# modules/home/shell.nix の initExtra から source される。
# raw zsh の方がシェル変数 (${...}) のエスケープを気にせず書ける。

# ----------------------------------------------------
# ls 系 (BSD ls + color)
# zsh は alias を再帰展開するため、`la` → `ls -a` → `ls -FG -a` になる。
# ----------------------------------------------------
alias ls="ls -FG"
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"

# ----------------------------------------------------
# Terminal OSC 7 (cwd): Ghostty shell-integration=none / WezTerm 未統合時の代替
# ----------------------------------------------------
if [[ -o interactive ]] && [[ "$TERM" != dumb ]]; then
  _dotfiles_osc7_precmd() {
    printf '\033]7;file://%s%s\033\\' "$HOST" "${PWD//\//%2F}"
  }
  if (( ! ${precmd_functions[(Ie)_dotfiles_osc7_precmd]} )); then
    precmd_functions=(_dotfiles_osc7_precmd "${precmd_functions[@]}")
  fi
fi

# ----------------------------------------------------
# Navigation / safety
# ----------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias home="cd ~/"
alias download="cd ~/Downloads"

# 定義済みエイリアス一覧（alias -L を名前順）
als() {
  emulate -L zsh
  alias -L | LC_ALL=C sort
}

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# ----------------------------------------------------
# Python: macOS の `python` を python3 に
# ----------------------------------------------------
alias python="python3"

# ----------------------------------------------------
# direnv
# ----------------------------------------------------
alias da="direnv allow"

# ----------------------------------------------------
# Editor / launcher / image
# ----------------------------------------------------
alias v='nvim'
alias l='lazygit'
alias raycast='open raycast://'
alias imgcat='wezterm imgcat'

# ----------------------------------------------------
# Claude
# ----------------------------------------------------
alias claudesize='du -sh ~/.claude/ && du -sh ~/.claude/* | sort -h'

# ----------------------------------------------------
# Docker / docker-compose
# ----------------------------------------------------
alias dup='docker-compose up'
alias dud='docker-compose up -d'
alias dbuild='docker-compose build'
alias dstart='docker-compose start'
alias drestart='docker-compose restart'
alias dstop='docker-compose stop'
alias ddown='docker-compose down'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimages='docker images'
alias dexec='docker exec -it'
alias dvolume='docker volume'
alias dvolumels='docker volume ls'
alias dvolumerm='docker volume rm'
alias dlogs='docker logs'
alias dlogsf='docker logs -f'

# docker-compose run --rm <service> sh -c <command>
dshell_invoke() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: dshell_invoke <service> '<command>'"
    return 1
  fi
  docker-compose run --rm "$1" sh -c "$2"
}

# ----------------------------------------------------
# Git
# ----------------------------------------------------
alias gpush='git push'
alias gpull='git pull'
alias gfetch='git fetch --prune'
alias gcm='git commit'
alias gst='git status'
alias gct='git switch'
alias gctb='git switch -c'
alias gb='git branch'
alias gbl='git branch -l'
alias gbla='git branch -la'
alias glogo='git log --oneline'
alias gmergetool='git mergetool'
alias gstash='git stash'
alias gspop='git stash pop'
alias gtag='git tag'
alias gcherrypick='git cherry-pick'

# annotated tag (タグ名と同じメッセージ)
gtag_commit() {
  git tag -a "$1" -m "$1"
}

# ----------------------------------------------------
# tig
# ----------------------------------------------------
alias tiga='tig --all'

# ----------------------------------------------------
# tree (eza ベース)
# 再帰深度 3、隠しファイル表示、 node_modules / .git / .cache / .next は除外
# ----------------------------------------------------
alias tree='eza -T -L 3 -a -I "node_modules|.git|.cache|.next"'

# ----------------------------------------------------
# cat → bat（シンタックスハイライト。スクリプト・$(...) 内は command cat）
# modules/home/shell.nix の programs.bat で bat を提供。
# ----------------------------------------------------
if command -v bat >/dev/null 2>&1; then
  cat() {
    command bat --paging=never "$@"
  }
fi

# ----------------------------------------------------
# ripgrep (隠しファイル検索、 .git は除外)
# ----------------------------------------------------
alias rg='rg --hidden --glob "!.git"'

# rg + delta でページャ表示
rgdelta() {
  rg --line-number --no-heading --color=always "$@" | delta --paging=auto
}

# ----------------------------------------------------
# Terraform 共通 (aws-vault なし版)
# 個人 PC では config/zsh/personal.zsh で aws-vault 経由の tf* alias が
# 後勝ちで定義される。
# ----------------------------------------------------
alias tinit='terraform init'
alias tplan='terraform plan'
alias tapply='terraform apply'
alias tstate='terraform state'
alias tstatels='terraform state list'
alias tstatecat='terraform state show'
alias tplangenerate='terraform plan -generate-config-out=tmp.tf'
alias tui='tftui'

# ----------------------------------------------------
# 言語ランタイム (pyenv / rbenv) — lazy loader
# 起動時には関数定義だけして実 init は最初の pyenv / rbenv 呼び出し時に行う。
# zsh 起動を 50-100ms 短縮しつつ、初回利用時の体感は変わらない。
# 入っていない環境では関数も定義しない (command -v チェック)。
# ----------------------------------------------------
if command -v pyenv >/dev/null 2>&1; then
  pyenv() {
    unfunction pyenv
    eval "$(command pyenv init -)"
    pyenv "$@"
  }
fi
if command -v rbenv >/dev/null 2>&1; then
  rbenv() {
    unfunction rbenv
    eval "$(command rbenv init - --no-rehash zsh)"
    rbenv "$@"
  }
fi

# ----------------------------------------------------
# asdf (0.16+ Go 版) — shims を PATH に追加
# 旧来の asdf.sh の source 方式は廃止され、shims ディレクトリを PATH に
# 追加しないと java 等のコマンドが解決できない (macOS の /usr/bin/java
# スタブに落ちて "Unable to locate a Java Runtime" になる)。
# 入っていない環境では何もしない (shims ディレクトリ存在チェック)。
# path は typeset -U で重複排除されるため毎回 prepend で安全。
# ----------------------------------------------------
if [[ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" ]]; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fi

# ----------------------------------------------------
# keys* コマンド (docs/keybindings)
# shell.nix の initContent が未反映の .zshrc でも common 経由で必ず読み込む
# ----------------------------------------------------
: "${DOTFILES_ROOT:=$HOME/Development/dotfiles}"
export DOTFILES_ROOT

# ターミナル識別 / Starship 切替（shell.nix 未反映のシェルでも common 経由で有効）
if [[ -f "${DOTFILES_ROOT}/config/zsh/terminal-app.zsh" ]]; then
  source "${DOTFILES_ROOT}/config/zsh/terminal-app.zsh"
fi
if [[ -f "${DOTFILES_ROOT}/config/zsh/terminal-appearance.zsh" ]]; then
  source "${DOTFILES_ROOT}/config/zsh/terminal-appearance.zsh"
fi

if [[ -f "${DOTFILES_ROOT}/config/zsh/keys.zsh" ]]; then
  source "${DOTFILES_ROOT}/config/zsh/keys.zsh"
fi
