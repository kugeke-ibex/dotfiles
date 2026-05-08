{ ... }:
{
  # Cursor 本体は brew cask "cursor" で管理。設定だけ home-manager で symlink。
  # JSONC (// コメント / trailing comma) 含むため Nix 解析せず raw ファイルとして配置。
  home.file = {
    "Library/Application Support/Cursor/User/settings.json".source =
      ../../config/cursor/settings.json;
    "Library/Application Support/Cursor/User/keybindings.json".source =
      ../../config/cursor/keybindings.json;
  };

  # 拡張のインストール / エクスポートは config/cursor/extensions.txt のヘッダ参照
}
