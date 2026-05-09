{ ... }:
{
  imports = [ ../fragments/work-common.nix ];

  networking.hostName = "work";
  networking.computerName = "work";
  networking.localHostName = "work";

  # Homebrew の核は modules/darwin/homebrew-common.nix（work は追加ブラウザ等なし）。個人向けは homebrew-personal.nix。
  # 空の brews/casks をここで定義すると上書きで一覧が消える恐れがあるため置かない。
}
