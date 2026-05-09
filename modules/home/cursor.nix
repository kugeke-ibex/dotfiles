{ config, dotfilesPath, ... }:
let
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  # Cursor 本体は brew cask "cursor" で管理。設定は WezTerm / nvim と同様に
  # dotfiles を直接指す symlink（編集が rebuild なしで反映）。
  # JSONC (// コメント / trailing comma) 含むため Nix からは内容を解析しない。
  home.file = {
    "Library/Application Support/Cursor/User/settings.json".source =
      mkLink "config/cursor/settings.json";
    "Library/Application Support/Cursor/User/keybindings.json".source =
      mkLink "config/cursor/keybindings.json";
  };

  # 拡張のインストール / エクスポートは config/cursor/extensions.txt のヘッダ参照
}
