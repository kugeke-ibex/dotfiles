# テンプレ（dotfiles）と実機だけコピーされる設定の差を switch 時に通知する。
# 自動マージはしない（Karabiner は UI 編集で必ず差が出るため、参考情報のみ）。
{
  config,
  lib,
  pkgs,
  ...
}:
let
  codexTemplate = pkgs.substituteAll {
    src = ../../config/codex/config.toml;
    homeDirectory = config.home.homeDirectory;
  };
in
{
  home.activation.dotfilesManagedDriftHints = lib.hm.dag.entryAfter [ "installKarabinerConfig" ] ''
    template_claude=${../../config/claude/settings.json}
    template_karabiner=${../../karabiner/karabiner.json}
    template_codex=${codexTemplate}
    warned=false
    if [[ -f "$HOME/.claude/settings.json" ]] && ! cmp -s "$template_claude" "$HOME/.claude/settings.json"; then
      printf >&2 '\n[home-manager] ~/.claude/settings.json が dotfiles のテンプレと異なります。マージ先: config/claude/settings.json\n'
      warned=true
    fi
    if [[ -f "$HOME/.codex/config.toml" ]] && ! cmp -s "$template_codex" "$HOME/.codex/config.toml"; then
      printf >&2 '\n[home-manager] ~/.codex/config.toml が dotfiles のテンプレと異なります。マージ先: config/codex/config.toml\n'
      warned=true
    fi
    if [[ -f "$HOME/.config/karabiner/karabiner.json" ]] && [[ "$template_karabiner" -nt "$HOME/.config/karabiner/karabiner.json" ]]; then
      printf >&2 '\n[home-manager] dotfiles 側の karabiner.json が実機より新しいです。取り込み検討: cp ~/.config/karabiner/karabiner.json karabiner/karabiner.json のあと内容をマージ\n'
      warned=true
    fi
    if [[ "$warned" == true ]]; then
      printf >&2 '[home-manager] 初回のみコピー戦略のため、テンプレ更新時は手動マージを検討してください。\n\n'
    fi
  '';
}
