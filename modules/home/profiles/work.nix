{
  config,
  hostname,
  dotfilesRelative,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
in
{
  # 業務用 Git email に差し替える（dummy のままコミットしないこと）
  programs.git.settings.user.email = "kugetyan0211+work@example.com";

  # Cursor を主に使う場合、VS Code（Nix）の二重メンテを避ける。必要なら true に戻す。
  programs.vscode.enable = false;

  # 社用 PC の zsh エイリアス / 関数（raw zsh）をここで管理する。
  #   - 全社用 PC 共通: config/zsh/work-common.zsh
  #   - マシン固有     : config/zsh/host-<hostname>.zsh（flake の hostname で選択）
  # どちらも raw zsh なので ${AWS_PROFILE} 等の実行時展開変数をそのまま書ける。
  programs.zsh.initContent = ''
    if [ -f "${dotfilesPath}/config/zsh/work-common.zsh" ]; then
      source "${dotfilesPath}/config/zsh/work-common.zsh"
    fi
    if [ -f "${dotfilesPath}/config/zsh/host-${hostname}.zsh" ]; then
      source "${dotfilesPath}/config/zsh/host-${hostname}.zsh"
    fi
  '';
}
