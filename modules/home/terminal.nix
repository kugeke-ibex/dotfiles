{
  config,
  dotfilesRelative,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
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

  # WezTerm hotkey ウィンドウのグローバルトグル (Karabiner Ctrl+Opt+W)
  home.file.".local/bin/toggle-wezterm-hotkey".source =
    ../../config/bin/toggle-wezterm-hotkey.zsh;
  home.file.".local/bin/toggle-wezterm-hotkey".executable = true;
}
