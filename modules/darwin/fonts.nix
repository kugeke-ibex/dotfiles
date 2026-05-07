{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    ricty-diminished
    nerd-fonts.meslo-lg
  ];
}
