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
  # iTerm2 本体は brew cask "iterm2"（homebrew-common）。
  # 設定は Cursor と同様、dotfiles 内 plist への symlink（UI で保存するとリポジトリに直接書き込まれる）。
  home.file."Library/Preferences/com.googlecode.iterm2.plist" = {
    force = true;
    source = mkLink "config/iterm2/com.googlecode.iterm2.plist";
  };
}
