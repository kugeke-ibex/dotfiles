{
  config,
  lib,
  pkgs,
  dotfilesRelative,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  # zeno.zsh (https://github.com/yuki-yano/zeno.zsh)
  # 設定ファイルは zeno の README / 公開例を参考にこのリポジトリ向けに整理。
  #
  # 構成:
  #   - Deno を home.packages で導入 (zeno は TypeScript で動く)
  #   - 設定ファイル一式を xdg.configFile で symlink (~/.config/zeno)
  #   - zeno.zsh 本体は初回起動時に git clone (programs.zsh.initContent)
  #     ※ Nix で sha256 を固定するより気軽。固定したくなったら fetchFromGitHub に切替

  home.packages = with pkgs; [ deno ];

  xdg.configFile."zeno".source = mkLink "config/zeno";

  # syntax-highlighting (shell.nix mkOrder 2000) より前に読み込む
  programs.zsh.initContent = lib.mkOrder 1950 ''
    # zeno.zsh
    ZENO_HOME="$HOME/.local/share/zeno.zsh"
    if [ ! -d "$ZENO_HOME" ] && command -v git >/dev/null 2>&1; then
      git clone --depth 1 https://github.com/yuki-yano/zeno.zsh.git "$ZENO_HOME" 2>/dev/null
    fi
    if [ -f "$ZENO_HOME/zeno.zsh" ] && command -v deno >/dev/null 2>&1; then
      export ZENO_NO_DEFAULT_KEYBINDINGS=true
      source "$ZENO_HOME/zeno.zsh"
      bindkey ' '   zeno-auto-snippet
      bindkey '^M'  zeno-auto-snippet-and-accept-line
      bindkey '^I'  zeno-completion
      bindkey '^X^S' zeno-insert-snippet
    fi
  '';
}
