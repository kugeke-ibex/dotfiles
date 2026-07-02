# すべての社用ホスト（profile=work）で共有する nix-darwin フラグメント。
# マシン別ディレクトリ（hosts/work-office など）から imports する。
# パターン: 共通を fragments に置き、ホストごとの default.nix で imports して差分だけ書く。
{ ... }:
{
  # 例: 社用共通の system.defaults、追加 taps、ホスト横断で揃えたい brew だけ など

  # Slack: 個人 PC (modules/darwin/homebrew-personal.nix) と同じ cask 版で統一。
  # 社用 Mac は Apple ID / Mac App Store を使えないことが多いので cask 版に揃えている。
  homebrew.casks = [
    "slack"
  ];
}
