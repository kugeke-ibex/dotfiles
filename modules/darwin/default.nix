{ pkgs, username, ... }:
{
  imports = [
    ./homebrew.nix
    ./system.nix
    ./fonts.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    interval = { Weekday = 7; };
    options = "--delete-older-than 30d";
  };

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.primaryUser = username;
  system.stateVersion = 5;

  programs.zsh.enable = true;

  environment.shells = with pkgs; [ bash zsh ];
}
