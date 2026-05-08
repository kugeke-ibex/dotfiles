{ ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      InitialKeyRepeat = 12;
      KeyRepeat = 1;
      "com.apple.swipescrolldirection" = true;
      "com.apple.keyboard.fnState" = false;
      ApplePressAndHoldEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
    };

    dock = {
      autohide = true;
      orientation = "bottom";
      tilesize = 48;
      show-recents = false;
      mru-spaces = false;
      minimize-to-application = true;
      launchanim = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      _FXShowPosixPathInTitle = true;
      DisableAllAnimations = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    loginwindow.GuestEnabled = false;

    screencapture.location = "~/Pictures/screenshots";

    # nix-darwin の標準オプションに無い defaults はここで追記
    CustomUserPreferences = {
      "NSGlobalDomain" = {
        "com.apple.trackpad.scaling" = 8;
        "com.apple.mouse.tapBehavior" = 1;
        "QLPanelAnimationDuration" = 0;
      };
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = false;
  };

  time.timeZone = "Asia/Tokyo";
}
