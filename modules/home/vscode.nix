{ config, pkgs, lib, ... }:
lib.mkMerge [
  {
    # personal 等では既定 ON。work は profiles/work.nix で false に上書き。
    programs.vscode.enable = lib.mkDefault true;
  }
  (lib.mkIf config.programs.vscode.enable {
    programs.vscode = {
      package = pkgs.vscode;

      # 拡張は config/vscode/extensions.txt で管理 (Nix 化していない)
      mutableExtensionsDir = true;

      profiles.default = {
        userSettings = builtins.fromJSON (builtins.readFile ../../config/vscode/settings.json);
        keybindings = builtins.fromJSON (builtins.readFile ../../config/vscode/keybindings.json);
      };
    };
  })
]
