{
  pkgs,
  lib,
  config,
  ...
}:
{
  # karabiner.json: ホットキー用ルールは dotfiles 側を常に反映（他ルールは手動 merge 可）
  home.activation.installKarabinerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.config/karabiner/karabiner.json"
    src=${../../karabiner/karabiner.json}
    $DRY_RUN_CMD mkdir -p "$HOME/.config/karabiner"
    if [ ! -e "$target" ]; then
      $DRY_RUN_CMD cp "$src" "$target"
    elif ! grep -q 'toggle-wezterm-hotkey' "$target" 2>/dev/null; then
      $DRY_RUN_CMD cp "$src" "$target"
      echo "installKarabinerConfig: installed karabiner.json (no hotkey rules found)"
    elif ! cmp -s "$src" "$target"; then
      $DRY_RUN_CMD cp "$src" "$target"
      echo "installKarabinerConfig: updated karabiner.json from dotfiles"
    fi
    $DRY_RUN_CMD chmod 644 "$target"
  '';
}
