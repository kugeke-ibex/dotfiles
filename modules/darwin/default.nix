{ pkgs, username, profile, lib, ... }:
{
  imports = [
    ./nix.nix
    ./homebrew-common.nix
    ./system.nix
    ./fonts.nix
  ]
  ++ lib.optionals (profile == "personal") [ ./homebrew-personal.nix ];

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
