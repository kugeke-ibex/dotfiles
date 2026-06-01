{ ... }:
{
  # 個人 PC のみ: Figma・追加ブラウザ・翻訳・実験 CLI 等
  homebrew = {
    brews = [
      "gemini-cli"
    ];

    casks = [
      "bitwarden"
      "figma"
      "firefox"
      "microsoft-edge"
      "deepl"
    ];

    # 個人 PC は Mac App Store 版 Slack。社用ホストは MAS が使えないことが多いため
    # work-common.nix で cask 版 ("slack") を入れる（インストール手段を分けている）。
    masApps = {
      "Slack" = 803453959;
    };
  };
}
