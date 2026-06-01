{
  config,
  lib,
  dotfilesRelative,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
  prefsDir = "${dotfilesPath}/config/iterm2";
in
{
  # iTerm2 本体は brew cask "iterm2"（homebrew-common）。
  #
  # 以前は ~/Library/Preferences/com.googlecode.iterm2.plist を dotfiles へ symlink して
  # いたが、iTerm2 は設定を cfprefsd 経由で読むため、新しい Mac では
  #   - cfprefsd がデフォルト設定をキャッシュして symlink を読まず、フォント・ウィンドウ
  #     位置・Hotkey などが一切反映されない（既定の Monaco でグリフが豆腐になる）
  #   - 終了時に binary plist を書き戻して git 管理の XML を壊す
  # という問題があった。iTerm2 公式の「Load preferences from a custom folder」方式に切替える。
  # 標準ドメイン (~/Library/Preferences) には「このフォルダから読め」というポインタだけを置き、
  # 実体は dotfiles の config/iterm2/com.googlecode.iterm2.plist を直接読み書きさせる。
  # ポインタはマシン固有の絶対パスだが標準ドメイン側にしか書かないため、git 管理の plist は汚れない。
  #
  # 反映には iTerm2 を終了した状態での switch が必要（起動中は defaults write がスキップされる）。
  home.activation.iterm2UseCustomPrefsFolder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    plist="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
    # 旧来の dotfiles symlink が残っていると defaults write が committed plist を
    # 書き換えてしまうため、cfprefsd 管理の実ファイルに置き換える。
    if [ -L "$plist" ]; then
      $DRY_RUN_CMD rm -f "$plist"
    fi
    if pgrep -xq iTerm2; then
      # iTerm2 起動中に defaults を書いても、終了時に上書きされて無効になる。
      # スキップしたことを必ず通知する（verbose でなくても見えるように echo）。
      echo "[iterm2] iTerm2 が起動中のため custom-prefs-folder 設定をスキップしました。" >&2
      echo "[iterm2] WezTerm など別端末で iTerm2 を完全終了してから switch し直してください。" >&2
    else
      $DRY_RUN_CMD defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${prefsDir}"
      $DRY_RUN_CMD defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
    fi
  '';
}
