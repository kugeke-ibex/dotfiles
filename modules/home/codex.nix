{ config, ... }:
{
  # Codex CLI 設定 (~/.codex/config.toml) を home-manager で生成したい場合の雛形。
  #
  # 参考: mozumasu/dotfiles の .config/nix/home-manager/codex.nix
  #
  # 必要になったら以下のように home.file.".codex/config.toml".text を有効化する:
  #
  # home.file.".codex/config.toml".text = ''
  #   personality = "pragmatic"
  #   model = "gpt-5"
  #   suppress_unstable_features_warning = true
  #
  #   [projects."${config.home.homeDirectory}/Development/dotfiles"]
  #   trust_level = "trusted"
  #
  #   [features]
  #   codex_git_commit = true
  #   undo = true
  # '';
}
