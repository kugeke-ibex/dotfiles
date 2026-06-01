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
  # 2026-05: Homebrew の python@3.12/3.13/3.14 の pyexpat.so が macOS 同梱の古い
  # /usr/lib/libexpat.1.dylib をロードし、`_XML_SetAllocTrackerActivationThreshold` not found で
  # クラッシュする。install_name_tool でリンク先を Homebrew の expat に書き換えて永続修正する。
  # DYLD_LIBRARY_PATH は SIP に除去され、Homebrew も formula ビルド時に除去するため使えない。
  # CLT を Xcode 26.3 に更新し、brew reinstall python@3.* すれば不要になるはず。
  system.activationScripts.homebrew.text = lib.mkBefore ''
    ${homebrewOwnershipFix}
    _expat_lib="/opt/homebrew/opt/expat/lib/libexpat.1.dylib"
    if [ -f "$_expat_lib" ]; then
      for _so in /opt/homebrew/Cellar/python@3.*/*/Frameworks/Python.framework/Versions/*/lib/python*/lib-dynload/pyexpat.cpython-*-darwin.so; do
        [ -f "$_so" ] || continue
        _current=$(/usr/bin/otool -L "$_so" 2>/dev/null | /usr/bin/grep -o '/usr/lib/libexpat\.1\.dylib' || true)
        if [ -n "$_current" ]; then
          echo "[pyexpat] $_so のリンク先を Homebrew expat に書き換えます"
          /usr/bin/install_name_tool -change /usr/lib/libexpat.1.dylib "$_expat_lib" "$_so"
          /usr/bin/codesign --force --sign - "$_so" 2>/dev/null || true
        fi
      done
    fi
  '';

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
      "expat"
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
      "pipx"
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
      # NOTE: `hashicorp/tap/terraform` は `tenv` (上で入れている Terraform/OpenTofu version manager)
      # が /opt/homebrew/bin/terraform を shim として提供するのと完全に衝突する。
      # tenv を使う前提なら terraform 本体は不要なので外す。
      # 「最新 terraform 一本でいい」ホストが出てきたら tenv の方を外してこちらを復活させる。
      # "hashicorp/tap/terraform"
      "idoavrah/homebrew/tftui"
      "kayac/tap/ecspresso"
    ];

    casks = [
      "iterm2"
      "wezterm"
      "ghostty"
      "cmux"
      "raycast"
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
