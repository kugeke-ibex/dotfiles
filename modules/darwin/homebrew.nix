{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = true;
    };

    global = {
      brewfile = true;
      lockfiles = false;
    };

    taps = [];

    brews = [];

    casks = [
      "wezterm"
      "ghostty"
      "raycast"
      "bitwarden"
      "karabiner-elements"

      # AI coding tools (personal/work 共通)
      "claude-code"
      "codex"
      "cursor-cli"

      # Editors
      "visual-studio-code"
      "cursor"

      # Dev / Container / API
      "docker"
      "docker-desktop"
      "postman"
    ];

    masApps = {};
  };
}
