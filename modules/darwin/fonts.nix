{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # `ricty-diminished` は nixpkgs から削除済み。
    # 後継として diminished + FiraCode ligatures 版を採用 (純正 ricty は `pkgs.ricty`)。
    rictydiminished-with-firacode
    nerd-fonts.meslo-lg
    hack-font
    hackgen-font
    hackgen-nf-font
  ];
}
