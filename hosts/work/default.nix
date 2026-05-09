{ ... }:
{
  networking.hostName = "work";
  networking.computerName = "work";
  networking.localHostName = "work";

  # Homebrew の一覧は modules/darwin/homebrew.nix をそのまま継承する。
  # 空の brews/casks をここで定義すると上書きで一覧が消える恐れがあるため置かない。
}
