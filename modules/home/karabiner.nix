{
  pkgs,
  lib,
  config,
  ...
}:
{
  # karabiner.json は UI 経由で書き換えられる前提のため symlink せず、
  # 既存ファイルが無い場合のみテンプレートをコピー (差分は手動で merge)
  home.activation.installKarabinerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.config/karabiner/karabiner.json"
    if [ ! -e "$target" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.config/karabiner"
      $DRY_RUN_CMD cp ${../../karabiner/karabiner.json} "$target"
      $DRY_RUN_CMD chmod 644 "$target"
    fi
  '';
}
