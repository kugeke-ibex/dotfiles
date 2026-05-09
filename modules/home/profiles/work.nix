{ ... }:
{
  # 業務用 Git email に差し替える（dummy のままコミットしないこと）
  programs.git.userEmail = "kugetyan0211+work@example.com";

  # Cursor を主に使う場合、VS Code（Nix）の二重メンテを避ける。必要なら true に戻す。
  programs.vscode.enable = false;
}
