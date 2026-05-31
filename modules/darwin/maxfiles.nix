# macOS は GUI 起動プロセスの soft maxfiles が 256 になりやすい。
# zeno の socket クライアント / Nix ビルド等で "too many open files" が出るため引き上げる。
{ lib, ... }:
{
  launchd.daemons.limit-maxfiles = {
    serviceConfig = {
      Label = "limit.maxfiles";
      ProgramArguments = [
        "/bin/launchctl"
        "limit"
        "maxfiles"
        "65536"
        "200000"
      ];
      RunAtLoad = true;
      ServiceIPC = false;
    };
  };
}
