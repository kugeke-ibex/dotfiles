{
  lib,
  username,
  ...
}:
let
  # /opt/homebrew は現ユーザー (${username}) 所有が前提。
  # 旧 Intel Homebrew / root 経由 install / 過去の switch 失敗等で
  # subdir が root 所有のままだと、nix-homebrew の tap symlink 作成や
  # brew bundle の `git clone` が "Permission denied" で落ちる。
  # find -not -user ... -print -quit で 1 件でも他所有を検出したら
  # sudo chown -R で一括修復する。正常時は find が即 return するので軽量。
  homebrewOwnershipFix = ''
    if [ -d /opt/homebrew ]; then
      if /usr/bin/find /opt/homebrew -not -user ${username} -print -quit 2>/dev/null | /usr/bin/grep -q .; then
        echo "[homebrew] /opt/homebrew に ${username} 以外が所有するパスを検出。${username}:admin に修復します"
        /usr/sbin/chown -R ${username}:admin /opt/homebrew
      fi
    fi
  '';
in
{
  # 二段構えで自己修復する:
  #  1. preActivation 最先頭 (mkBefore) で chown → nix-homebrew が tap symlink を貼る前に直す
  #  2. brew bundle 直前 (homebrew.text の mkBefore) でもう 1 回 chown
  #     → activation 中に root 権限で新規ディレクトリが作られて root 所有になった場合の保険
  system.activationScripts.preActivation.text = lib.mkBefore homebrewOwnershipFix;
  system.activationScripts.homebrew.text = lib.mkBefore homebrewOwnershipFix;

  # 共通: personal / work 両方で入れる CLI・開発向け cask。
  # 個人のみの追加ブラウザ・デザイン・翻訳・実験 CLI 等は homebrew-personal.nix。
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # work や実験用 brew を消したくないホストの既定。personal は hosts/personal で "uninstall" に上書きするので mkDefault。
      # ※ nix-darwin 26 以降 bool は不可、`"none" | "check" | "uninstall" | "zap"` の enum。
      cleanup = lib.mkDefault "none";
      upgrade = true;
    };

    # Homebrew Bundle は 4.4.0 (Oct 2024) で lockfile support 廃止。
    # nix-darwin 側の `homebrew.global.lockfiles` / `noLock` も effect 無しの deprecated。
    global = {
      brewfile = true;
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
      "cmux"
      "raycast"
      "bitwarden"
      "karabiner-elements"

      "claude-code"
      "codex"
      "cursor-cli"
      "cursor"

      "arc"
      "claude"
      "chatgpt"
      "notion"

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
