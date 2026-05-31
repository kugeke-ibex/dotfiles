{ ... }:
{
  networking.hostName = "personal";
  networking.computerName = "personal";
  networking.localHostName = "personal";

  homebrew = {
    brews = [
      "cloud-sql-proxy"
      "php@8.2"
      "powerlevel10k"
      "python@3.9"
    ];

    casks = [
      # "fig"  # discontinued (廃止)
      "discord"
      "eset-cyber-security"
      "gcloud-cli"
      "gyazo"
      "loom"
      "notion-calendar"
      "orbstack"
      "temurin@11"
    ];

    masApps = {
      "LINE" = 539883307;
      # Kindle は App Store から削除済み (Amazon が Web 版に移行)
    };
  };
}
