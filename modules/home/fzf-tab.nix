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
  # Tab 補完は config/zsh/completion-terminal.zsh でターミナル別に切替。
  # iTerm2 → zsh menu select / その他 → fzf-tab。zeno は Tab を使わない (zeno.nix)。
  # 読み込み順: compinit (HM) → fzf --zsh (2500) → zeno (2600) → completion-terminal (2650) → syntax-highlighting (2700)
  home.packages = [ pkgs.zsh-fzf-tab ];

  programs.zsh.initContent = lib.mkOrder 2650 ''
    typeset -g DOTFILES_FZF_TAB_PLUGIN="${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"
    if [[ -o zle ]] && [[ -f "${dotfilesPath}/config/zsh/completion-terminal.zsh" ]]; then
      source "${dotfilesPath}/config/zsh/completion-terminal.zsh"
    fi
  '';
}
