# iTerm2 向け: fzf-tab を使わず zsh 標準のメニュー補完（cd / パス補完を安定させる）

setopt GLOB_DOTS

zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*:cd:*' tag-order \
  local-directories directory-stack named-directories

zstyle ':completion:*:cd:*:*' group-order \
  named-directories directory-stack directories local-directories

# パス補完で .. / ... を候補に（common.zsh の cd エイリアスとは独立）
zstyle ':completion:*' special-dirs true
