{ pkgs, ... }:
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

      nix-switch = "darwin-rebuild switch --flake ~/Development/dotfiles";
      nfu = "nix flake update --flake ~/Development/dotfiles";
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

  home.packages = with pkgs; [
    ripgrep
    fd
    yq
    tree
    htop
    wget
  ];
}
