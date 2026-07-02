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
      # Slack: 社用ホスト (hosts/fragments/work-common.nix) と同じ cask 版で統一。
      # 以前は Mac App Store 版 (masApps 803453959) だったが、インストール手段を揃えた。
      "slack"
    ];
  };
}
