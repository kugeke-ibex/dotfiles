{ ... }:
{
  # 個人 PC のみ: Figma・追加ブラウザ・翻訳・実験 CLI 等
  homebrew = {
    brews = [
      "gemini-cli"
    ];

    casks = [
      "figma"
      "firefox"
      "microsoft-edge"
      "deepl"
    ];
  };
}
