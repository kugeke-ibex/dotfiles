# 例: 2 台目以降の社用 Mac。flake.nix の darwinConfigurations に同名エントリを追加して使う。
# 複製して work-laptop 等にリネームしてよい。
{ ... }:
{
  imports = [ ../fragments/work-common.nix ];

  networking.hostName = "work-office";
  networking.computerName = "work-office";
  networking.localHostName = "work-office";

  # 例: このマシンだけ office 用 brew を足す（空のリストで上書きしないこと）
  # homebrew.brews = [ "something-corp" ];
}
