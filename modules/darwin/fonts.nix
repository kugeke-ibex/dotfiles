{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    # `ricty-diminished` は nixpkgs から削除済み。
    # 後継として diminished + FiraCode ligatures 版を採用 (純正 ricty は `pkgs.ricty`)。
    rictydiminished-with-firacode
    nerd-fonts.meslo-lg
    # Powerlevel10k 推奨の Meslo。ファミリ名が "MesloLGS NF" で、
    # nerd-fonts.meslo-lg が提供する "MesloLGS Nerd Font" とは別名。
    # 各ターミナル/エディタ設定 (wezterm / ghostty / cursor / vscode / iterm2) は
    # "MesloLGS NF" を参照しているため、これを宣言的に入れて全ホストで解決させる
    # (個人 PC では手動 install 済みのため WezTerm が動いていた)。
    meslo-lgs-nf
    hack-font
    hackgen-font
    hackgen-nf-font
  ];
}
