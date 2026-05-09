{ config, lib, dotfilesRelative, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  # ~/.claude/ の管理戦略:
  #   - 静的ファイル (CLAUDE.md / commands / skills / agents / statusline.sh): dotfiles を直接 symlink
  #     mkOutOfStoreSymlink を使い、dotfiles 編集が即時反映される (switch 不要)
  #   - 動的ファイル (settings.json): 初回のみコピー
  #     Claude Code の /config エディタが書き戻すため、毎回上書きしない
  #     テンプレ更新だけ反映したい場合は config/claude/settings.json を手でマージする
  #   - 完全動的 (cache / sessions / projects / file-history など): 触らない
  #
  # 機密ファイル (settings.local.json) も dotfiles 化しない。

  home.file = {
    # CLAUDE.md は ~/.codex/AGENTS.md と内容を共有 (config/ai-tools/global-rules.md)
    ".claude/CLAUDE.md".source = mkLink "config/ai-tools/global-rules.md";

    # commands / skills / agents / rules / hooks は dotfiles をディレクトリごと symlink
    ".claude/commands".source = mkLink "config/claude/commands";
    ".claude/skills".source = mkLink "config/claude/skills";
    ".claude/agents".source = mkLink "config/claude/agents";
    ".claude/rules".source = mkLink "config/claude/rules";
    ".claude/hooks".source = mkLink "config/claude/hooks";

    ".claude/statusline.sh" = {
      source = mkLink "config/claude/statusline.sh";
      executable = true;
    };
  };

  home.activation.installClaudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.claude/settings.json"
    if [ ! -e "$target" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.claude"
      $DRY_RUN_CMD install -Dm644 ${../../config/claude/settings.json} "$target"
    fi
  '';
}
