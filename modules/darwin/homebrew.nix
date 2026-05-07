{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = true;
    };

    global = {
      brewfile = true;
      lockfiles = false;
    };

    taps = [];
    brews = [];
    casks = [];
    masApps = {};
  };
}
