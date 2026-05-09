{ ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      # 24 時間表示（参考 nix-darwin defaults）
      AppleICUForce24HourTime = true;
      # サイドバーアイコンサイズ (1=小, 2=中, 3=大)
      NSTableViewDefaultSizeMode = 2;
      InitialKeyRepeat = 12;
      KeyRepeat = 1;
      "com.apple.swipescrolldirection" = true;
      "com.apple.keyboard.fnState" = false;
      ApplePressAndHoldEnabled = false;
      NSAutomaticWindowAnimationsEnabled = false;
      # システムビープ音量
      "com.apple.sound.beep.volume" = 0.0;
      # スマートダッシュ・スマート引用符を無効化
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
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
      # Finder の終了メニュー / 新規ウィンドウの表示先（参考設定）
      QuitMenuItem = true;
      NewWindowTarget = "Documents";
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
