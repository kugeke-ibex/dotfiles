{ ... }:
{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@admin" ];
  };

  nix.gc = {
    automatic = true;
    interval = { Weekday = 7; };
    options = "--delete-older-than 30d";
  };
}
