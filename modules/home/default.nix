{ profile, username, ... }:
{
  imports = [
    ./shell.nix
    ./git.nix
    ./editor.nix
    ./tmux.nix
    ./terminal.nix
    ./karabiner.nix
    ./vscode.nix
    ./cursor.nix
    ./claude-code.nix
    ./codex.nix
    ./zeno.nix
    ./config-drift-warnings.nix
    ./profiles/${profile}.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
