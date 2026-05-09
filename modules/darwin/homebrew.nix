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
      "gemini-cli"
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

      # AI coding tools (personal/work 共通)
      "claude-code"
      "codex"
      "cursor-cli"

      # Editors
      # "visual-studio-code"  # home-manager programs.vscode (Nix) で管理
      "cursor"

      # Dev / Container / API（CLI は Docker Desktop に含まれるため docker cask は入れない）
      "docker-desktop"
      "postman"
      "tableplus"

      # Browsers
      "google-chrome"
      "arc"

      # Design / extra browsers（参考 homebrew）
      "figma"
      "firefox"
      "microsoft-edge"

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
