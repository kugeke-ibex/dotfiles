# Nix の設定（実験機能・GC・バイナリの版）はここにまとめる。
#
# 既定: nix-darwin が Nix をインストール／更新する構成（公式インストーラや multi-user の定番運用）。
# 手元が Determinate Nix ならデーモンが衝突するので、次の 2 点だけ入れ替える:
#   1) 下の nix.package の行を削除
#   2) nix.enable = false; を追加
#   https://github.com/LnL7/nix-darwin/blob/master/README.md#prerequisites
{ pkgs, ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@admin" ];
  };

  nix.package = pkgs.nix;

  nix.gc = {
    automatic = true;
    interval = { Weekday = 7; };
    options = "--delete-older-than 30d";
  };
}
