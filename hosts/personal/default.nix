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
      "Kindle" = 405399194;
    };

    # 宣言に無い brew/cask を自動削除する（共通は cleanup=false のためここで上書き）
    onActivation.cleanup = "uninstall";
  };
}
