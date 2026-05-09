{ config, dotfilesRelative, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
in
{
  programs.git.userEmail = "kugetyan0211@gmail.com";

  # 個人 PC 専用の zsh エイリアス / 関数は config/zsh/personal.zsh に raw zsh として置き、
  # ここでは source するだけにする (Nix エスケープ不要 + 単独で編集しやすい)。
  programs.zsh.initContent = ''
    if [ -f "${dotfilesPath}/config/zsh/personal.zsh" ]; then
      source "${dotfilesPath}/config/zsh/personal.zsh"
    fi
  '';

  # 個人 PC 専用の環境変数 (volta / pyenv 関連)。
  home.sessionVariables = {
    VOLTA_HOME = "${config.home.homeDirectory}/.volta";
    VOLTA_FEATURE_PNPM = "1";
    PYENV_ROOT = "${config.home.homeDirectory}/.pyenv";
  };

  # pyenv は brew で /opt/homebrew/bin/pyenv に入るので $PYENV_ROOT/bin は PATH に
  # 入れない (pyenv init - が冪等に PATH をセットアップする)。重複 PATH を避ける。
  home.sessionPath = [
    "${config.home.homeDirectory}/.volta/bin"
  ];
}
