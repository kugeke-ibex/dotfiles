# dotfiles

macOS (Apple Silicon) configuration managed declaratively with **Nix flake** + **nix-darwin** + **home-manager** + **nix-homebrew**.

References: [mozumasu/dotfiles](https://github.com/mozumasu/dotfiles), [yuya-matsushima/dotfiles](https://github.com/yuya-matsushima/dotfiles).

## Hosts

| Host       | Purpose   |
| ---------- | --------- |
| `personal` | 個人 PC   |
| `work`     | 社用 PC   |

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
| `nix-switch` | `darwin-rebuild switch --flake ~/Development/dotfiles`     |
| `nfu`        | `nix flake update`                                         |
| `ngc`        | `sudo nix-collect-garbage -d && nix-collect-garbage -d`    |

## Layout

```text
.
├── bootstrap.sh                # Nix 導入 + 初回 switch
├── flake.nix                   # darwinConfigurations.{personal,work}
├── flake.lock                  # 自動生成
├── hosts/
│   ├── personal/default.nix    # 個人 PC 固有 (brew/cask/defaults)
│   └── work/default.nix        # 社用 PC 固有
├── modules/
│   ├── darwin/                 # nix-darwin (システム全体)
│   │   ├── default.nix
│   │   ├── homebrew.nix
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

## Roadmap

- [x] Phase 1: 最小構成 (zsh/git/neovim/tmux + bootstrap)
- [ ] Phase 2: macOS defaults と GUI cask (iTerm2 / Raycast / 1Password など)
- [ ] Phase 3: personal / work プロファイルの差分充実
- [ ] Phase 4: lefthook / sops / fonts / Karabiner

## Manual Steps (after first switch)

- Apple ID へのサインイン
- iCloud / 各種アプリのログイン
- SSH 鍵の生成・配布
- 1Password / GPG 等の認証情報設定
- `modules/home/profiles/work.nix` の `userEmail` を業務メールに置換
