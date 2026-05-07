{ ... }:
{
  networking.hostName = "personal";
  networking.computerName = "personal";
  networking.localHostName = "personal";

  homebrew = {
    taps = [
      "hashicorp/tap"
      "idoavrah/homebrew"
      "kayac/tap"
    ];

    brews = [
      "asdf"
      "aws-vault"
      "awscli"
      "cloud-sql-proxy"
      "cmake"
      "coreutils"
      "ghq"
      "git-secrets"
      "go-parquet-tools"
      "gobject-introspection"
      "golang-migrate"
      "golangci-lint"
      "graphviz"
      "grpcurl"
      "helm"
      "istioctl"
      "jq"
      "k9s"
      "kubernetes-cli"
      "kustomize"
      "mas"
      "mkcert"
      "mysql"
      "nodebrew"
      "peco"
      "php@8.2"
      "pnpm"
      "powerlevel10k"
      "protobuf"
      "protobuf@21"
      "pyenv"
      "python-setuptools"
      "python@3.12"
      "python@3.9"
      "rbenv"
      "stern"
      "tenv"
      "vegeta"
      "yarn"
      "zsh-completions"
      "zsh-git-prompt"
      "hashicorp/tap/terraform"
      "idoavrah/homebrew/tftui"
      "kayac/tap/ecspresso"
    ];

    casks = [
      "docker"
      "docker-desktop"
      # "fig"  # discontinued (廃止)
      "gcloud-cli"
      "gyazo"
      "loom"
      "postman"
      "temurin@11"
      "visual-studio-code"
    ];

    masApps = {};
  };
}
