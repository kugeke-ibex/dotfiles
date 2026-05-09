{ config, lib, pkgs, dotfilesPath, ... }:
let
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
  # Portable seed: @homeDirectory@ in the template is replaced at eval time (see substituteAll).
  codexConfig = pkgs.substituteAll {
    src = ../../config/codex/config.toml;
    homeDirectory = config.home.homeDirectory;
  };
in
{
  # ~/.codex/ の管理戦略:
  #   - AGENTS.md: ~/.claude/CLAUDE.md と共通の global-rules.md を symlink
  #   - config.toml: 初回のみコピー (Codex が動的に書き換える last_updated 等を含むため)
  #   - 完全動的 (sessions / logs / sqlite / state / cache): 触らない
  #
  # 機密 (auth.json) は dotfiles 化しない。

  home.file.".codex/AGENTS.md".source = mkLink "config/ai-tools/global-rules.md";

  home.activation.installCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.codex/config.toml"
    if [ ! -e "$target" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.codex"
      $DRY_RUN_CMD install -Dm644 ${codexConfig} "$target"
    fi
  '';
}
