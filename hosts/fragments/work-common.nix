# すべての社用ホスト（profile=work）で共有する nix-darwin フラグメント。
# マシン別ディレクトリ（hosts/work-office など）から imports する。
#
# 参考構成: https://github.com/mozumasu/dotfiles/tree/main/.config/nix/hosts
# （common + ホスト名ごとのディレクトリで積み上げるパターン）
{ ... }:
{
  # 例: 社用共通の system.defaults、追加 taps、ホスト横断で揃えたい brew だけ など
}
