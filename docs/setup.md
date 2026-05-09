# Setup Guide

## 前提

- macOS (Apple Silicon)
- Command Line Tools for Xcode (`xcode-select --install`)

## 手順

### 1. リポジトリ取得

```bash
mkdir -p ~/Development
git clone github:kugeke-ibex/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
```

### 2. bootstrap

```bash
./bootstrap.sh personal      # 個人 PC
./bootstrap.sh work          # 社用 PC（例）
./bootstrap.sh work-office   # 別の社用 Mac（例・flake にエントリがあるものだけ）
```

利用可能な `<host>` は `hosts/<host>/default.nix` がある名前（`fragments` は除外）。迷ったら `./bootstrap.sh` で一覧を表示する。

初回は Nix 導入のみで終了するので、新しいシェルを開いて再実行する。

### 3. 完了確認

```bash
nix --version
darwin-rebuild --version
nix-switch     # darwin-rebuild switch（flake の dotfiles ルート）
```

## Manual steps

| 項目                | 備考                                                                         |
| ------------------- | ---------------------------------------------------------------------------- |
| Apple ID サインイン | App Store / iCloud / Mail                                                    |
| GitHub SSH 鍵       | `ssh-keygen -t ed25519 -C "kugetyan0211@gmail.com"` で生成し GitHub に登録   |
| 1Password           | アカウントログイン後、CLI 連携を有効化                                       |
| Slack / Zoom        | アカウント別ログイン (`work` は業務アカウント)                               |
| 業務メール反映      | `modules/home/profiles/work.nix` の `userEmail` を業務用に置換               |

## Troubleshooting

- 既存の `/etc/zshrc` がリンクではなくファイルだと nix-darwin が失敗する → `bootstrap.sh` が自動退避するが、手動で退避する場合は:

  ```bash
  sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin.$(date +%Y%m%d)
  ```

- `darwin-rebuild` が `command not found` になった場合は新しいシェルを開く。

## Updating

```bash
nfu          # flake.lock を最新化
nix-switch   # 反映
ngc          # 古い世代を GC
```
