{
  pkgs,
  config,
  dotfilesRelative,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/${dotfilesRelative}";
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    # Nix 評価時にパスを展開する必要がある alias のみここで管理する。
    # それ以外の汎用 alias（tree / v / l / t 等）は config/zsh/common.zsh、
    # 個人 PC 専用は config/zsh/personal.zsh で raw zsh として管理する。
    shellAliases = {
      g = "git";
      gs = "git status -sb";
      vi = "nvim";
      vim = "nvim";

      nix-switch = "darwin-rebuild switch --flake ${dotfilesPath}";
      nfu = "nix flake update --flake ${dotfilesPath}";
      ngc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      nfmt = "nix fmt";
    };

    initContent = ''
      bindkey -e
      setopt no_beep
      setopt auto_cd
      setopt auto_pushd
      setopt pushd_ignore_dups
      setopt extended_glob

      # History を強化 (programs.zsh.history を補強)
      setopt EXTENDED_HISTORY      # 実行時間 / exit status を記録
      setopt hist_verify           # 履歴展開で即実行せず確認
      setopt hist_ignore_all_dups  # 全履歴で重複排除
      setopt hist_no_store         # `history` コマンド自体は履歴に残さない
      setopt hist_reduce_blanks    # 余分な空白を整理
      setopt hist_save_no_dups     # 保存時にも重複排除
      setopt hist_expand           # 履歴を即座に展開
      setopt inc_append_history    # コマンド完了直後に書き込み

      # Completion / Spell
      setopt correct               # スペル訂正
      setopt list_packed           # 補完候補を密に表示
      unsetopt list_types          # 補完候補末尾の type 表記を消す

      # Background job priority (bash と同じ ionice 挙動)
      unsetopt bg_nice

      # Disable Ctrl-S / Ctrl-Q on tty (vim でこれらを使えるように)
      [[ -t 0 ]] && stty -ixon

      # PC 共通の zsh エイリアス / 関数 (raw zsh で管理する分)
      if [ -f "${dotfilesPath}/config/zsh/common.zsh" ]; then
        source "${dotfilesPath}/config/zsh/common.zsh"
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../../config/starship.toml);
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = false;
    icons = "auto";
    git = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # bat / eza / fzf / ripgrep / zoxide は上記 programs.* または home.packages で提供
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    # 汎用設定 (manager / preview / opener / open rules / tasks / input / confirm / pick / which)。
    # keymap.toml / theme.toml は yazi 標準を使う。
    settings = builtins.fromTOML (builtins.readFile ../../config/yazi/yazi.toml);
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    yq
    tree
    htop
    wget
    bat
    jq
    bc # Claude Code statusline (~/.claude/statusline.sh) でレイテンシ表示に使用
    vim-startuptime
    gh
    gitflow
  ];

  # PC 共通の環境変数。Go の GOPATH / GO111MODULE は使わない環境でも害が無いので共通に。
  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
    GO111MODULE = "on";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/go/bin"
  ];
}
