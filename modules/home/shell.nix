{
  pkgs,
  lib,
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
    # home-manager 既定の mkOrder だと syntax-highlighting (1550) の後に
    # history-substring-search (1600) が来てしまい、ZLE フック競合で
    # `_zsh_highlight: bad set of key/value pairs for associative array` が出る。
    # zsh-syntax-highlighting は README どおり「最後に source」する必要があるため手動で並べる。
    syntaxHighlighting.enable = false;
    historySubstringSearch.enable = false;

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

      # zsh では .# がグロブ/コメント扱いになるため flake 参照はクォートする
      nix-switch = "cd ${dotfilesPath} && nix run '${dotfilesPath}#switch' -- personal";
      nfu = "nix flake update --flake ${dotfilesPath}";
      ngc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      nfmt = "nix fmt";
    };

    initContent = lib.mkMerge [
      # autosuggestions (HM mkOrder 700) より前: zeno/fzf ウィジェットをラップしない
      (lib.mkOrder 650 ''
        typeset -ga ZSH_AUTOSUGGEST_IGNORE_WIDGETS
        ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(
          zeno-auto-snippet
          zeno-auto-snippet-and-accept-line
          zeno-insert-snippet
          fzf-completion
          fzf-tab-complete
          toggle-fzf-tab
          history-substring-search-up
          history-substring-search-down
        )
      '')
      (lib.mkOrder 100 ''
        # login 以外の対話シェル (IDE ターミナル等) でも maxfiles を引き上げる
        if [[ "$(uname -s)" == Darwin ]]; then
          ulimit -n 65536 2>/dev/null || ulimit -n 10240 2>/dev/null || true
        fi
      '')
      ''
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

        # dotfiles ルート（keys* コマンド等）。ホストごとの clone 先は flake の dotfilesRelative。
        export DOTFILES_ROOT="${dotfilesPath}"

        # PC 共通の zsh エイリアス / 関数 (raw zsh で管理する分)
        if [ -f "${dotfilesPath}/config/zsh/common.zsh" ]; then
          source "${dotfilesPath}/config/zsh/common.zsh"
        fi
        if [ -f "${dotfilesPath}/config/zsh/keys.zsh" ]; then
          source "${dotfilesPath}/config/zsh/keys.zsh"
        fi
      ''
      # fzf → starship → direnv → history-substring-search → fzf-tab (2650) → syntax-highlighting (2700)
      (lib.mkOrder 2500 ''
        if [[ -o zle ]]; then
          source <(${pkgs.fzf}/bin/fzf --zsh)
          # ^I は fzf-tab (2650) が最後に bind。fzf は ** トリガー等で fzf-completion を使う。
        fi
        if [[ $TERM != "dumb" ]]; then
          eval "$(${pkgs.starship}/bin/starship init zsh)"
        fi
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

        source "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
      '')
      # zsh-syntax-highlighting は README どおり .zshrc の最後 (fzf-tab 2650 の後)
      (lib.mkOrder 2700 ''
        if (( ! ''${+functions[_zsh_highlight]} )); then
          # zsh 5.9 の zle-line-pre-redraw + memo=0 は autosuggest/zeno と相性が悪い。
          # add-zle-hook-widget を一時的に隠し、従来の widget ラップ経路を使う (issues #579/#735)。
          if (( $+functions[add-zle-hook-widget] )); then
            functions[_dotfiles_add_zle_hook_widget]=$functions[add-zle-hook-widget]
            unfunction add-zle-hook-widget
          fi
          (( ''${+zsh_highlight__memo_feature} )) || integer -g zsh_highlight__memo_feature=0
          source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
          ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
          if (( $+functions[_dotfiles_add_zle_hook_widget] )); then
            functions[add-zle-hook-widget]=$_dotfiles_add_zle_hook_widget
          fi
        fi
        bindkey "^[[A" history-substring-search-up
        bindkey "^[[B" history-substring-search-down
      '')
    ];
  };

  # Zsh 統合は mkOrder 2500 で syntax-highlighting (2700) より前に手動読み込み (順序固定)
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    settings = builtins.fromTOML (builtins.readFile ../../config/starship.toml);
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
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
    enableZshIntegration = false;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      # cat 関数から --paging=never を渡す。ここは less 連携用の既定。
      pager = "less -FRX";
    };
  };

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
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/go/bin"
  ];
}
