{ pkgs, username, ... }:
{
  imports = [
    ./nix.nix
    ./homebrew.nix
    ./system.nix
    ./fonts.nix
  ];

  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.primaryUser = username;
  system.stateVersion = 5;

  programs.zsh.enable = true;

  environment.shells = with pkgs; [ bash zsh ];
}
