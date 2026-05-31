{
  config,
  lib,
  pkgs,
  dotfilesRelative,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
in
{
  # fzf-tab: Tab 補完はここ一本。zeno はスペース snippet 専用 (zeno.nix)。
  # 読み込み順: compinit (HM) → fzf --zsh (shell.nix 2500) → zeno bindkey (2600, Tab なし) → fzf-tab (2650) → syntax-highlighting (2700)
  home.packages = [ pkgs.zsh-fzf-tab ];

  programs.zsh.initContent = lib.mkMerge [
    (lib.mkOrder 2640 ''
      # fzf-tab より前に zstyle を置く (compinit は HM enableCompletion で済んでいる)
      zstyle ':completion:*' menu no
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':fzf-tab:*' switch-group '<' '>'
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath 2>/dev/null'
      zstyle ':fzf-tab:complete:cd:*' fzf-flags --preview-window=right:50%
    '')
    (lib.mkOrder 2650 ''
      if [[ -o zle ]]; then
        source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
      fi
    '')
    (lib.mkOrder 2655 ''
      if [[ -o zle ]] && [[ -f "${dotfilesPath}/config/zsh/fzf-tab.zsh" ]]; then
        source "${dotfilesPath}/config/zsh/fzf-tab.zsh"
      fi
    '')
  ];
}
