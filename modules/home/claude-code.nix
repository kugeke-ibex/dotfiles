{ config, lib, pkgs, ... }:
{
  # Claude Code 設定 (~/.config/claude/settings.json など) を Nix で宣言したい場合の雛形。
  #
  # 参考: mozumasu/dotfiles の .config/nix/home-manager/claude-code.nix
  #   - permissions.{allow,deny,ask} を Nix attribute set で宣言
  #   - hooks (PreToolUse / PostToolUse / Stop / Notification) も Nix 化
  #   - settings.json は activation で **コピー** (Claude Code の /config エディタが書き戻すため)
  #   - CLAUDE.md / skills / hooks は symlink
  #   - 機密設定 (private marketplace 等) は sops-nix で別管理
  #
  # 現状はユーザーが既に ~/.claude/ を手動で運用しているため、自動置き換えはせずスタブのみ用意。
  # 必要になったら以下のような形で展開する:
  #
  # let
  #   publicSettings = {
  #     permissions = {
  #       allow = [ "Bash" "Read" "Edit" "Write" "WebFetch" ];
  #       deny  = [ "Bash(rm -rf:*)" "Bash(sudo:*)" "Read(.env)" "Read(~/.ssh/id_*)" ];
  #       ask   = [ "Bash(git push:*)" "Bash(git rebase:*)" ];
  #     };
  #     env.MAX_THINKING_TOKENS = "31999";
  #   };
  #   settingsFile = pkgs.writeText "claude-settings.json" (builtins.toJSON publicSettings);
  # in
  # {
  #   home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     mkdir -p "$HOME/.config/claude"
  #     install -Dm644 "${settingsFile}" "$HOME/.config/claude/settings.json"
  #   '';
  # }
}
