{ config, dotfilesPath, ... }:
let
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  # WezTerm / Ghostty 設定をディレクトリ全体で live symlink。
  # mkOutOfStoreSymlink を使うので dotfiles 編集が即時反映され、
  # config/wezterm/modules/* のような追加ファイルも自動で見える。
  xdg.configFile = {
    "wezterm".source = mkLink "config/wezterm";
    "ghostty".source = mkLink "config/ghostty";
  };
}
