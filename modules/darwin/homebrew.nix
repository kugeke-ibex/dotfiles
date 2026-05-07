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
    ];

    masApps = {};
  };
}
