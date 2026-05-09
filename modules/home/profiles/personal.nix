{ config, dotfilesRelative, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
in
{
  programs.git.userEmail = "kugetyan0211@gmail.com";

  # 個人 PC 専用の zsh エイリアス / 関数は config/zsh/personal.zsh に raw zsh として置き、
  # ここでは source するだけにする (Nix エスケープ不要 + 単独で編集しやすい)。
  programs.zsh.initExtra = ''
    if [ -f "${dotfilesPath}/config/zsh/personal.zsh" ]; then
      source "${dotfilesPath}/config/zsh/personal.zsh"
    fi
  '';
}
