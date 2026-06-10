{ ... }:
{
  imports = [ ../fragments/work-common.nix ];

  networking.hostName = "work";
  networking.computerName = "work";
  networking.localHostName = "work";

  homebrew = {
    brews = [
      # homebrew-core の `atlas` は community 版 (ent:// 非対応) のため、
      # ent の versioned migration 生成に必要な non-community 版を Ariga 公式 tap から入れる。
      "ariga/tap/atlas"
    ];
  };

  # Homebrew の核は modules/darwin/homebrew-common.nix（work は追加ブラウザ等なし）。個人向けは homebrew-personal.nix。
  # 空の brews/casks をここで定義すると上書きで一覧が消える恐れがあるため置かない。
}
