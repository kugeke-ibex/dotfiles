# Setup Guide

## 前提

- macOS (Apple Silicon)
- Command Line Tools for Xcode (`xcode-select --install`)

## 事前準備 (Apple Silicon × Intel Homebrew の移行)

このリポジトリは Apple Silicon ネイティブ (`/opt/homebrew`) を前提にしている。
すでに **Intel 版 Homebrew (`/usr/local/bin/brew`)** が入っている環境では、
初回適用の前に以下を行うのが安全:

```bash
# 1. 既存 Intel Homebrew の状態を念のためバックアップ
brew bundle dump --file ~/brewfile.intel.bak --force

# 2. (強く推奨) Intel Homebrew をアンインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

ステップ 2 を省略して `./bootstrap.sh` を走らせると、Intel の `/usr/local/bin/brew`
と nix-homebrew が ARM64 で導入する `/opt/homebrew/bin/brew` が **共存する**。
動作はするものの、重複インストール / PATH 順位の混乱 / どの brew を実行しているか
不透明という負債になるため、移行のタイミングで揃えておくのを推奨する。

> ※ Intel Mac から Apple Silicon Mac に移行ツールで引き継いだ環境では、
> 旧 Intel Homebrew がそのまま残っているケースが多い。`brew --prefix` の出力が
> `/usr/local` のときが該当する (Apple Silicon ネイティブなら `/opt/homebrew`)。

退避済みの Brewfile (`~/brewfile.intel.bak`) から個別の brew / cask 名を確認したい
ときに参照する。同名のものが現リポジトリの brew リストに無ければ
[`modules/darwin/homebrew-common.nix`](../modules/darwin/homebrew-common.nix) や
[`hosts/personal/default.nix`](../hosts/personal/default.nix) に追記する。

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

| 項目                | 備考                                                                       |
| ------------------- | -------------------------------------------------------------------------- |
| Apple ID サインイン | App Store / iCloud / Mail                                                  |
| GitHub SSH 鍵       | `ssh-keygen -t ed25519 -C "kugetyan0211@gmail.com"` で生成し GitHub に登録 |
| 1Password           | アカウントログイン後、CLI 連携を有効化                                     |
| Slack / Zoom        | アカウント別ログイン (`work` は業務アカウント)                             |
| 業務メール反映      | `modules/home/profiles/work.nix` の `userEmail` を業務用に置換             |

## Troubleshooting

- 既存の `/etc/zshrc` がリンクではなくファイルだと nix-darwin が失敗する → `bootstrap.sh` が自動退避するが、手動で退避する場合は:

  ```bash
  sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin.$(date +%Y%m%d)
  ```

- `darwin-rebuild` が `command not found` になった場合は新しいシェルを開く。

- `brew install ...` 中に `Error: The following directories are not writable by your user: /opt/homebrew/share` のような permission error が出る場合は、`/opt/homebrew` の所有者が現ユーザーではない subdir が残っている (Intel Homebrew からの移行や root 経由のインストール跡)。 `bootstrap.sh` 経由なら自動修復するが、 手動で直す場合は:

  ```bash
  sudo chown -R "$(id -un)":admin /opt/homebrew
  ```

## Updating

```bash
nfu          # flake.lock を最新化
nix-switch   # 反映
ngc          # 古い世代を GC
```
