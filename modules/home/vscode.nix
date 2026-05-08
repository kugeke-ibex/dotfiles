{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    # 拡張は config/vscode/extensions.txt で管理 (Nix 化していない)
    mutableExtensionsDir = true;

    profiles.default = {
      userSettings = builtins.fromJSON (builtins.readFile ../../config/vscode/settings.json);
      keybindings  = builtins.fromJSON (builtins.readFile ../../config/vscode/keybindings.json);
    };
  };
}
