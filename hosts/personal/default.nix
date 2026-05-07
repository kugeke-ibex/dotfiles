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
      "gcloud-cli"
      "gyazo"
      "loom"
      "temurin@11"
    ];

    masApps = {};
  };
}
