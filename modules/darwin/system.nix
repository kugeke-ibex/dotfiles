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
      # DisableAllAnimations は nix-darwin に標準オプションが無いので
      # CustomUserPreferences."com.apple.finder" 側で defaults write 相当を直接指定する。
      # Finder の終了メニュー / 新規ウィンドウの表示先（参考設定）
      QuitMenuItem = true;
      NewWindowTarget = "Documents";
    };

    trackpad = {
      # タップでクリック
      Clicking = true;
      # ドラッグ（タップ＆ハーフ）。3 本指ドラッグを使うので有効化しておく
      Dragging = false;
      # 3 本指ドラッグ（ウィンドウ移動・テキスト選択を 3 本指で）
      TrackpadThreeFingerDrag = true;
      # 2 本指タップ＝副ボタン（右クリック）
      TrackpadRightClick = true;
      # クリック圧。0=弱(軽い) / 1=中 / 2=強
      FirstClickThreshold = 0;
      SecondClickThreshold = 0;
      # クリック音の強さ。0=サイレントクリック / 1=通常
      ActuationStrength = 0;
      # 3 本指タップで調べる/データ検出。0=無効 / 2=有効
      TrackpadThreeFingerTapGesture = 2;
    };

    loginwindow.GuestEnabled = false;

    screencapture.location = "~/Pictures/screenshots";

    # nix-darwin の標準オプションに無い defaults はここで追記
    CustomUserPreferences = {
      "NSGlobalDomain" = {
        # トラックパッドのカーソル速度（0〜3 相当のスケール、大きいほど速い）
        "com.apple.trackpad.scaling" = 8;
        # マウスのカーソル速度（-1 で加速無効、値が大きいほど速い）
        "com.apple.mouse.scaling" = 3.0;
        # マウスホイールのスクロール速度
        "com.apple.scrollwheel.scaling" = 0.5;
        # タップでクリック（NSGlobalDomain 側のミラー設定）
        "com.apple.mouse.tapBehavior" = 1;
        # 2 本指/3 本指スワイプでページ移動・履歴を戻る/進む
        "AppleEnableSwipeNavigateWithScrolls" = true;
        "QLPanelAnimationDuration" = 0;
      };
      "com.apple.finder" = {
        DisableAllAnimations = true;
      };
      # 内蔵トラックパッドのマルチタッチジェスチャ
      "com.apple.AppleMultitouchTrackpad" = {
        # タップでクリック / 2 本指で副ボタン
        Clicking = true;
        TrackpadRightClick = true;
        # ピンチでズーム / 2 本指で回転 / 2 本指ダブルタップでスマートズーム
        TrackpadPinch = true;
        TrackpadRotate = true;
        TrackpadTwoFingerDoubleTapGesture = true;
        # 右端から左へスワイプで通知センター
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
        # 3 本指上スワイプ=Mission Control / 下スワイプ=App Exposé
        TrackpadThreeFingerVertSwipeGesture = 2;
        # 3 本指左右スワイプは無効化し、4 本指側に寄せる
        TrackpadThreeFingerHorizSwipeGesture = 0;
        # 4 本指左右でフルスクリーンアプリ切替 / ピンチで Launchpad・デスクトップ表示
        TrackpadFourFingerHorizSwipeGesture = 2;
        TrackpadFourFingerVertSwipeGesture = 2;
        TrackpadFourFingerPinchGesture = 2;
      };
      # Bluetooth トラックパッド（Magic Trackpad）にも同じジェスチャを適用
      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadPinch = true;
        TrackpadRotate = true;
        TrackpadTwoFingerDoubleTapGesture = true;
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
        TrackpadThreeFingerVertSwipeGesture = 2;
        TrackpadThreeFingerHorizSwipeGesture = 0;
        TrackpadFourFingerHorizSwipeGesture = 2;
        TrackpadFourFingerVertSwipeGesture = 2;
        TrackpadFourFingerPinchGesture = 2;
      };
      # Magic Mouse（内蔵ドライバ）のジェスチャ・ボタン設定
      "com.apple.AppleMultitouchMouse" = {
        # 副ボタンを有効化（"OneButton"=右クリック無効 / "TwoButton"=右クリック有効）
        MouseButtonMode = "TwoButton";
        # 1 本指ダブルタップでスマートズーム
        MouseOneFingerDoubleTapGesture = 1;
        # 2 本指ダブルタップで Mission Control（0=無効 / 3=有効）
        MouseTwoFingerDoubleTapGesture = 3;
        # 2 本指左右スワイプでページ移動・履歴を戻る/進む
        MouseTwoFingerHorizSwipeGesture = 2;
        # 慣性スクロール
        MouseMomentumScroll = true;
        MouseHorizontalScroll = true;
        MouseVerticalScroll = true;
      };
      # Bluetooth 接続の Magic Mouse にも同じ設定を適用
      "com.apple.driver.AppleBluetoothMultitouch.mouse" = {
        MouseButtonMode = "TwoButton";
        MouseOneFingerDoubleTapGesture = 1;
        MouseTwoFingerDoubleTapGesture = 3;
        MouseTwoFingerHorizSwipeGesture = 2;
        MouseMomentumScroll = true;
        MouseHorizontalScroll = true;
        MouseVerticalScroll = true;
      };
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = false;
  };

  time.timeZone = "Asia/Tokyo";
}
