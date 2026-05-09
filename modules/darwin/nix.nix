# Nix の設定。
#
# このリポジトリは bootstrap.sh で **Determinate Systems の nix-installer** を使うため、
# Nix 自体 (デーモン / store / バージョン) は Determinate Nix が管理する。nix-darwin に
# Nix を二重管理させると `nix-daemon` の launchd エントリ等で衝突するので、
# `nix.enable = false` で nix-darwin 側の管理を無効化する。
#
# `experimental-features = nix-command flakes` は Determinate Nix のデフォルトで有効。
# GC は Determinate のデーモンが (オプトインで) 週次 GC するため nix-darwin 側では設定しない。
#
# nix-darwin に Nix を管理させたい場合は以下に戻す:
#   1) `nix.enable = false;` を削除
#   2) `nix.package = pkgs.nix;` を追加
#   3) 下記コメントの nix.settings / nix.gc を有効化
#
# 参考: https://github.com/LnL7/nix-darwin/blob/master/README.md#prerequisites
{ ... }:
{
  nix.enable = false;

  # nix-darwin 管理に切り替えるとき用 (現在は無効):
  #
  # nix.settings = {
  #   experimental-features = [ "nix-command" "flakes" ];
  #   trusted-users = [ "@admin" ];
  # };
  # nix.package = pkgs.nix;
  # nix.gc = {
  #   automatic = true;
  #   interval = { Weekday = 7; };
  #   options = "--delete-older-than 30d";
  # };
}
