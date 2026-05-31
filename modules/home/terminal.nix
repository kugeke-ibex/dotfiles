{
  config,
  lib,
  dotfilesRelative,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
  # 手動 install / 旧 backup (*.before-nix-darwin) との衝突を避ける
  mkLocalBin = name: source: {
    ".local/bin/${name}" = {
      inherit source;
      executable = true;
      force = true;
    };
  };
  localBinFiles =
    mkLocalBin "toggle-wezterm-hotkey" ../../config/bin/toggle-wezterm-hotkey.zsh
    // mkLocalBin "toggle-ghostty-hotkey" ../../config/bin/toggle-ghostty-hotkey.zsh
    // mkLocalBin "karabiner-toggle-wezterm" ../../config/bin/karabiner-toggle-wezterm.sh
    // mkLocalBin "karabiner-toggle-ghostty" ../../config/bin/karabiner-toggle-ghostty.sh
    // mkLocalBin "verify-hotkey-overlay" ../../config/bin/verify-hotkey-overlay.sh;
in
{
  # WezTerm / Ghostty 設定をディレクトリ全体で live symlink。
  # mkOutOfStoreSymlink を使うので dotfiles 編集が即時反映され、
  # config/wezterm/modules/* のような追加ファイルも自動で見える。
  xdg.configFile = {
    "wezterm".source = mkLink "config/wezterm";
    "ghostty".source = mkLink "config/ghostty";
  };

  # WezTerm / Ghostty hotkey ウィンドウトグル (Karabiner Ctrl+Opt+W / Ctrl+Opt+G)
  home.file = localBinFiles;

  # backupFileExtension 使用時、既存の *.before-nix-darwin と衝突するため checkLinkTargets 前に削除
  home.activation.removeStaleLocalBinBackups = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    $DRY_RUN_CMD rm -f "$HOME"/.local/bin/*.before-nix-darwin
  '';
}
