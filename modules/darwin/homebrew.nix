{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
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
      "jq"
      "k9s"
      "kubernetes-cli"
      "kustomize"
      "mas"
      "mkcert"
      "mysql"
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

      # AI coding tools (personal/work 共通)
      "claude-code"
      "codex"
      "cursor-cli"

      # Editors
      "visual-studio-code"
      "cursor"

      # Dev / Container / API
      "docker"
      "docker-desktop"
      "postman"
      "tableplus"

      # Browsers
      "google-chrome"
      "arc"

      # Communication
      "zoom"

      # AI desktop apps
      "claude"
      "chatgpt"

      # Productivity / Notes / Translation
      "notion"
      "deepl"
    ];

    masApps = {
      "Slack" = 803453959;
    };
  };
}
