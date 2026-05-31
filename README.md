# dotfiles

macOS (**Apple Silicon / `aarch64-darwin` のみ** — Intel Mac はこの flake のままではビルドできません) configuration managed declaratively with **Nix flake** + **nix-darwin** + **home-manager** + **nix-homebrew**.

## Hosts

個人 PC は 1 ホスト、社用 PC はマシンごとにディレクトリと flake エントリを増やす（`hosts/<名前>/default.nix` + `darwinConfigurations.<名前>`）。社用間の共通設定は [`hosts/fragments/work-common.nix`](hosts/fragments/work-common.nix) にまとめ、各社用ホストから `imports` する。

| Host          | Purpose                                     |
| ------------- | ------------------------------------------- |
| `personal`    | 個人 PC                                     |
| `work`        | 社用 PC（1 台目の例）                       |
| `work-office` | 社用 PC（2 台目の例。複製して増やしてよい） |

`./bootstrap.sh` に渡せる名前は `hosts/<host>/default.nix` が存在するものだけ（`fragments` はホストにできない）。一覧は `./bootstrap.sh` または `./bootstrap.sh --help` で表示される。

## Dotfiles のパス（重要）

Home Manager の **live symlink** は **`$HOME/<dotfilesRelative>`** を checkout ルートとして参照します（`dotfilesRelative` は `flake.nix` の `mkDarwin` でホストごとに変更可、既定は `Development/dotfiles`）。**ユーザー名**もホストごとに `mkDarwin` の `username` で上書きできます。

## Quick Start

```bash
git clone github:kugeke-ibex/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
./bootstrap.sh personal      # 個人
./bootstrap.sh work          # 社用（例）
./bootstrap.sh work-office   # 別の社用マシン（例）
```

`bootstrap.sh` の挙動:

1. Nix が未導入なら **Determinate Systems** の `nix-installer` で導入
2. `/etc/zshrc` 等の既存設定をタイムスタンプ付きで `.before-nix-darwin.<ts>` に退避
3. `darwin-rebuild switch --flake .#<host>` で初回適用 (未導入時は `nix run nix-darwin --` 経由)

Nix を初めてインストールした場合は、新しいシェルを開いてから再実行してください。

## セットアップ手順（ケース別）

以下はいずれも **Apple Silicon Mac**、`flake.nix` の `mkDarwin` で既定どおり `dotfilesRelative = "Development/dotfiles"` の場合の例。clone 先やログイン名がホストごとに違うときは、先に [`flake.nix`](flake.nix) の該当 `mkDarwin { … }` で `dotfilesRelative` / `username` を直してから、**そのパスに clone** する。

### ケース 1: 個人 PC（`personal`）

1. リポジトリを取得する。

   ```bash
   mkdir -p ~/Development
   git clone github:kugeke-ibex/dotfiles.git ~/Development/dotfiles
   cd ~/Development/dotfiles
   ```

2. 初回適用する。

   ```bash
   ./bootstrap.sh personal
   ```

3. Nix をこの手順で初めて入れた場合は、**新しいターミナルを開いて** もう一度 `./bootstrap.sh personal` を実行する（インストーラの案内どおり）。

4. 下記 [Manual Steps](#manual-steps-after-first-switch) を進める。

### ケース 2: 社用 PC — すでに `flake.nix` に載っているホスト（例: `work`, `work-office`）

リポジトリ側でホスト定義が済んでいるマシンでの初回セットアップ。

1. 最新を取得してディレクトリに入る。

   ```bash
   mkdir -p ~/Development
   git clone github:kugeke-ibex/dotfiles.git ~/Development/dotfiles
   cd ~/Development/dotfiles
   # 既に clone 済みなら: git pull
   ```

2. そのマシン向けのホスト名で bootstrap する（`hosts/<名前>/default.nix` と `darwinConfigurations.<名前>` が一致していること）。

   ```bash
   ./bootstrap.sh work
   # または
   ./bootstrap.sh work-office
   ```

3. Nix 新規導入直後はケース 1 と同様、新しいシェルで再実行する。

4. [Manual Steps](#manual-steps-after-first-switch) のうち、業務用メール差し替えなど社用向け項目を実施する。

### ケース 3: 新しい社用 PC を増やす（リポジトリにホストを追加してから）

**手元の Mac（編集用）で:**

1. 既存の社用ホストを複製する（例）。

   ```bash
   cp -R hosts/work-office hosts/my-corp-mac
   ```

2. `hosts/my-corp-mac/default.nix` を開き、`networking.hostName` / `computerName` / `localHostName` をそのマシン用に変更する。全社用共通の設定は `imports = [ ../fragments/work-common.nix ];` のままにする。

3. [`flake.nix`](flake.nix) の `darwinConfigurations` に次を追加する（名前はディレクトリと揃える）。

   ```nix
   my-corp-mac = mkDarwin {
     hostname = "my-corp-mac";
     profile = "work";
     # username = "...";
     # dotfilesRelative = "...";
   };
   ```

4. 動作確認後、`git commit` / `git push` する。

**新しい社用 Mac で:**

```bash
mkdir -p ~/Development
git clone github:kugeke-ibex/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles
git pull   # 追加コミットを取り込む
./bootstrap.sh my-corp-mac
```

### 初回以降: 設定を反映し直す

リポジトリ直下で、**自分のホスト名**を付けて switch する。

```bash
cd ~/Development/dotfiles
# sudo switch だと git 所有権エラー (libgit2 GIT_EOWNER) になるため build → activate に分ける
darwin-rebuild build --flake '.#personal'
sudo darwin-rebuild activate
# 社用の例: '.#work' / '.#work-office' に読み替え
```

次でも同じ意味になる（**zsh では `.#` をクォート**しないと `no matches found` になる）。

```bash
cd ~/Development/dotfiles
nix run '.#switch' -- personal
nix run '.#switch' -- work-office
```

新規ファイルを Nix が参照する場合は先に `git add` する（flake が git リポジトリとして評価されるため）。

## Daily Operations

| Alias / 関数 | 内容                                                                                                                                                                                                                  |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `keys`       | キーバインド一覧（`docs/keybindings/README.md`）。個別は `kw` / `kg` / `kk` / `kn` 等（`config/zsh/keys.zsh`） |
| `nix-switch` | `cd $HOME/<dotfilesRelative> && nix run '$HOME/<dotfilesRelative>#switch' -- personal`（zsh は `#` をクォート） |
| `nfu`        | `nix flake update --flake $HOME/<dotfilesRelative>`                                                                                                                                                                   |
| `ngc`        | `sudo nix-collect-garbage -d && nix-collect-garbage -d`                                                                                                                                                               |

## 変更の反映（編集したもの別）

| 変更したもの                                                             | 手順                                                                                                                                                                               |
| ------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`*.nix`・`flake.nix`・`hosts/`・パッケージ一覧**                       | `darwin-rebuild build --flake '~/Development/dotfiles#<host>'` → `sudo darwin-rebuild activate`。または `nix run '.#switch' -- <host>`。 |
| **WezTerm / Ghostty / Neovim（`config/wezterm/`・`config/nvim/` など）** | `modules/home` が **live symlink** で繋いでいるため、**ファイル保存で反映**（ターミナル／エディタのリロードや再起動はアプリ側）。**switch は不要**。                               |
| **Cursor の `config/cursor/*.json`**                                     | 同上（symlink）。保存後に Cursor を再読込／再起動。                                                                                                                                |
| **iTerm2 の `config/iterm2/com.googlecode.iterm2.plist`**                | 同上（symlink）。Preferences 保存で反映。初回は `activate` で symlink 化。                                                                                                         |
| **VS Code の `config/vscode/*.json`・`config/starship.toml`**            | Nix がビルド時に読み込むため、変更後は **switch が必要**。                                                                                                                         |

**補足:** `config/claude/settings.json` や Codex のテンプレは **初回のみホームへコピー**される運用のため、既に `~/.claude/` 等にファイルがあると **リポジトリを直しただけでは自動では上書きされない**（手でマージするか、方針どおり取り直し）。詳細は該当モジュールのコメントを参照。

## Layout

```text
.
├── AGENTS.md                   # Cursor 向け要約（詳細は CLAUDE.md）
├── CLAUDE.md                   # エージェント向け詳細ガイド
├── bootstrap.sh                # Nix 導入 + 初回 switch
├── flake.nix                   # darwinConfigurations.{personal,work,work-office,...}
├── flake.lock                  # 自動生成
├── hosts/
│   ├── fragments/
│   │   └── work-common.nix     # 全社用ホスト共通（各 work* から imports）
│   ├── personal/default.nix    # 個人 PC 固有 (brew/cask/defaults)
│   ├── work/default.nix        # 社用 PC 例（ホスト名等）
│   └── work-office/default.nix # 別の社用 Mac 例（複製して増やす）
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
