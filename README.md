# dotfiles

macOS (**Apple Silicon / `aarch64-darwin` のみ** — Intel Mac はこの flake のままではビルドできません) configuration managed declaratively with **Nix flake** + **nix-darwin** + **home-manager** + **nix-homebrew**.

## Hosts

| Host       | Purpose   |
| ---------- | --------- |
| `personal` | 個人 PC   |
| `work`     | 社用 PC   |

## Dotfiles のパス（重要）

Home Manager の **live symlink** は **`$HOME/<dotfilesRelative>`** を checkout ルートとして参照します（`dotfilesRelative` は `flake.nix` の `mkDarwin` でホストごとに変更可、既定は `Development/dotfiles`）。**ユーザー名**もホストごとに `mkDarwin` の `username` で上書きできます。

## Quick Start

```bash
git clone github:kugeke-ibex/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
./bootstrap.sh personal   # or: work
```

`bootstrap.sh` の挙動:

1. Nix が未導入なら **Determinate Systems** の `nix-installer` で導入
2. `/etc/zshrc` 等の既存設定をタイムスタンプ付きで `.before-nix-darwin.<ts>` に退避
3. `darwin-rebuild switch --flake .#<host>` で初回適用 (未導入時は `nix run nix-darwin --` 経由)

Nix を初めてインストールした場合は、新しいシェルを開いてから再実行してください。

## Daily Operations

| Alias        | 内容                                                       |
| ------------ | ---------------------------------------------------------- |
| `nix-switch` | `darwin-rebuild switch --flake $HOME/<dotfilesRelative>`（`flake.nix` の既定パス） |
| `nfu`        | `nix flake update --flake $HOME/<dotfilesRelative>`                         |
| `ngc`        | `sudo nix-collect-garbage -d && nix-collect-garbage -d`    |

## Layout

```text
.
├── bootstrap.sh                # Nix 導入 + 初回 switch
├── flake.nix                   # darwinConfigurations.{personal,work}
├── flake.lock                  # 自動生成
├── hosts/
│   ├── personal/default.nix    # 個人 PC 固有 (brew/cask/defaults)
│   └── work/default.nix        # 社用 PC 固有（ホスト名のみ。Homebrew は共通ファイルを継承）
├── modules/
│   ├── darwin/                 # nix-darwin (システム全体)
│   │   ├── default.nix
│   │   ├── homebrew-common.nix     # 共通 brew（work 既定、cleanup は無効）
│   │   ├── homebrew-personal.nix   # personal のみの追加 cask
│   │   └── system.nix          # macOS defaults (Dock/Finder/Keyboard)
│   └── home/                   # home-manager (ユーザー環境)
│       ├── default.nix
│       ├── shell.nix           # zsh + starship + fzf + eza + ...
│       ├── git.nix             # git + gh + lazygit
│       ├── editor.nix          # neovim
│       ├── tmux.nix
│       └── profiles/
│           ├── personal.nix    # 個人プロファイル
│           └── work.nix        # 社用プロファイル
└── docs/setup.md
```

## Manual Steps (after first switch)

- Apple ID へのサインイン
- iCloud / 各種アプリのログイン
- SSH 鍵の生成・配布
- 1Password / GPG 等の認証情報設定
- `modules/home/profiles/work.nix` の `userEmail` を業務メールに置換
