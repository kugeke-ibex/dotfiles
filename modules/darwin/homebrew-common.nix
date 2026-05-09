{ ... }:
{
  # 共通: personal / work 両方で入れる CLI・開発向け cask。
  #  leisure / 追加ブラウザ / AI デスクトップアプリは homebrew-personal.nix（profile=personal のみ）。
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # work や実験用 brew を消したくないホストの既定。personal は hosts/personal で uninstall に上書き。
      cleanup = false;
      upgrade = true;
    };

    global = {
      brewfile = true;
      lockfiles = false;
    };

    taps = [
      "hashicorp/tap"
      "idoavrah/homebrew"
      "kayac/tap"
    ];

    brews = [
      "asdf"
      "aws-vault"
      "awscli"
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
      "k9s"
      "kubernetes-cli"
      "kustomize"
      "mas"
      "mkcert"
      "mysql"
      "nb"
      "nodebrew"
      "peco"
      "pnpm"
      "protobuf"
      "protobuf@21"
      "pyenv"
      "python-setuptools"
      "python@3.12"
      "rbenv"
      "stern"
      "tenv"
      "vegeta"
      "yarn"
      "zsh-completions"
      "zsh-git-prompt"
      "cairo"
      "libffi"
      "libvips"
      "libpq"
      "luarocks"
      "poppler"
      "postgresql@14"
      "ruby-build"
      "hashicorp/tap/terraform"
      "idoavrah/homebrew/tftui"
      "kayac/tap/ecspresso"
    ];

    casks = [
      "wezterm"
      "ghostty"
      "raycast"
      "bitwarden"
      "karabiner-elements"

      "claude-code"
      "codex"
      "cursor-cli"
      "cursor"

      "docker-desktop"
      "postman"
      "tableplus"

      "google-chrome"
      "zoom"
    ];

    masApps = {
      "Slack" = 803453959;
    };
  };
}
