{ pkgs, config, dotfilesRelative, ... }:
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

    shellAliases = {
      ll = "eza -lah";
      la = "eza -lah";
      ls = "eza";
      tree = "eza --tree";
      g = "git";
      gs = "git status -sb";

      vi = "nvim";
      vim = "nvim";

      nix-switch = "darwin-rebuild switch --flake ${config.home.homeDirectory}/${dotfilesRelative}";
      nfu = "nix flake update --flake ${config.home.homeDirectory}/${dotfilesRelative}";
      ngc = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      nfmt = "nix fmt";
    };

    initExtra = ''
      bindkey -e
      setopt no_beep
      setopt auto_cd
      setopt auto_pushd
      setopt pushd_ignore_dups
      setopt extended_glob
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
}
