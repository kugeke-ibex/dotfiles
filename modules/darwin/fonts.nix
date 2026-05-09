{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    ricty-diminished
    nerd-fonts.meslo-lg
    hack-font
    hackgen-font
    hackgen-nf-font
  ];
}
