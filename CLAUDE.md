# CLAUDE.md

このファイルは **Git リポジトリ内のドキュメント**として、Claude Code / Cursor が本リポジトリで作業するときのガイドです。**要点のみ**は [`AGENTS.md`](AGENTS.md) にまとめてあり、本ファイルは詳細版です。

グローバルなエージェント向けルール（全プロジェクト共通）は `config/ai-tools/global-rules.md` にあり、`~/.claude/CLAUDE.md` および `~/.codex/AGENTS.md` はそのファイルへの symlink です（リポジトリ直下のこの CLAUDE.md とは別物）。

## リポジトリの目的

macOS (Apple Silicon) 向けの個人 PC **1** と社用 PC **複数**を **Nix flake + nix-darwin + home-manager + nix-homebrew** で宣言的に管理する dotfiles。`darwinConfigurations` は `personal` と 1 つ以上の `work*` ホスト（例: `work`, `work-office`）。

## 技術スタック

- **Nix flake** (`flake.nix`) — `darwinConfigurations.{personal,work,…}`（社用は台数分エントリを追加）
- **nix-darwin** — システム設定 (Dock/Finder/Keyboard 等の defaults、Homebrew 統合)
- **home-manager** — ユーザー環境 (zsh, git, neovim, terminals 等。 multiplexer は cmux 内蔵を使うため tmux モジュールは持たない)
- **nix-homebrew** — Homebrew を flake input で固定 (`mutableTaps = false`)
- **Determinate Systems nix-installer** — Nix の導入

## ディレクトリ構成

```text
.
├── flake.nix                        # darwinConfigurations entry
├── bootstrap.sh                     # Nix 導入 + 初回 switch
├── hosts/
│   ├── fragments/
│   │   └── work-common.nix          # 全社用ホストで import（共通フラグメント）
│   ├── personal/default.nix         # 個人 PC 固有 (brews/casks/masApps)
│   ├── work/default.nix             # 社用 PC（汎用ホスト名）
│   └── work-office/default.nix      # 例: 2 台目の社用 PC（複製して増やす）
├── modules/
│   ├── darwin/                      # システム設定 (nix-darwin)
│   │   ├── default.nix
│   │   ├── homebrew-common.nix      # 共通 brews/casks（work / personal 基底）
│   │   ├── homebrew-personal.nix    # personal のみ（追加 cask / gemini-cli）
│   │   ├── system.nix               # macOS defaults
│   │   └── fonts.nix                # ricty-diminished, nerd-fonts.meslo-lg
│   └── home/                        # ユーザー環境 (home-manager)
│       ├── default.nix
│       ├── shell.nix                # zsh + starship + fzf + ...
│       ├── git.nix                  # git + gh + lazygit
│       ├── editor.nix               # neovim
│       ├── terminal.nix             # WezTerm + Ghostty 設定の配置 (cmux も ghostty.config を流用)
│       ├── iterm2.nix               # iTerm2 plist の symlink
│       ├── karabiner.nix            # karabiner.json の初回コピー
│       └── profiles/
│           ├── personal.nix         # 個人プロファイル (git email 等)
│           └── work.nix             # 業務プロファイル (git userEmail。業務アドレスに差し替え、placeholder をそのままコミットしない)
├── karabiner/karabiner.json         # Karabiner-Elements テンプレート
├── config/
│   ├── wezterm/wezterm.lua
│   ├── ghostty/config
│   ├── iterm2/com.googlecode.iterm2.plist
│   └── starship.toml                # Tokyo Night preset (公式)
└── docs/
    ├── setup.md
    └── keybindings/
        ├── README.md
        ├── wezterm.md
        ├── ghostty.md
        ├── cmux.md
        ├── iterm2.md
        └── karabiner.md
```

## コアルール

### 1. ホスト分岐 (どこに置くか)

| 用途                                                  | 配置先                                                                                                                                                                          |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| personal / work どちらでも使う brew 基底              | `modules/darwin/homebrew-common.nix`                                                                                                                                            |
| すべての社用ホストで共通（ホスト名以外の nix-darwin） | `hosts/fragments/work-common.nix` を各社用 `hosts/<名前>/default.nix` から `imports`                                                                                            |
| 個人 PC にだけ入れたい cask / brew                    | `modules/darwin/homebrew-personal.nix`（`profile == "personal"` のときだけ読込）                                                                                                |
| 個人 PC のみで使う                                    | `hosts/personal/default.nix`（追加 brew / `cleanup = uninstall`）                                                                                                               |
| 社用 PC（マシンごと）                                 | `hosts/<名前>/default.nix`（例: `work`, `work-office`）。**flake.nix に `darwinConfigurations.<名前>` を追加**すること（`mkDarwin` の `hostname` はディレクトリ名と一致させる） |

共通フラグメント（`hosts/fragments/`）とホスト別ディレクトリを組み合わせると、社用マシンを増やしやすい。

判断に迷ったら **共通寄り** にする。後から個別に分けるのは容易だが、最初から個別に置くと共通化が漏れる。

### 2. CLI ツール: Nix 経由 vs Homebrew 経由

| 配置先                                      | 例                                                                             | 判断基準                                                  |
| ------------------------------------------- | ------------------------------------------------------------------------------ | --------------------------------------------------------- |
| `modules/home/shell.nix` の `home.packages` | `ripgrep`, `fd`, `yq`, `tree`, `htop`, `wget`                                  | Nix pkgs にあり、特別な設定が不要なもの                   |
| `modules/home/<x>.nix` の `programs.<tool>` | `git`, `gh`, `lazygit`, `neovim`, `starship`, `fzf`, `zoxide`, `eza`, `direnv` | home-manager に専用モジュールがあり、設定込みで便利なもの |
| `homebrew.brews` (共通 or ホスト)           | `aws-vault`, `k9s`, `kubernetes-cli`, `asdf`, `mas`, `mysql`                   | macOS 専用 / 上記で扱いにくいもの                         |

**重複インストールを避ける**: 同じツールを home-manager と brew の両方で管理しないこと。例: `gh` は home-manager 側 (`programs.gh.enable`) のみで管理。

### 3. キーバインド・設定変更時はドキュメントを同期

**設定ファイルとドキュメントは同じコミットで更新する**。

| 設定ファイル                          | 対応するドキュメント            |
| ------------------------------------- | ------------------------------- |
| `config/wezterm/wezterm.lua`          | `docs/keybindings/wezterm.md`   |
| `config/ghostty/config`               | `docs/keybindings/ghostty.md`   |
| `config/ghostty/config` (cmux も共有) | `docs/keybindings/cmux.md`      |
| `config/iterm2/com.googlecode.iterm2.plist` | `docs/keybindings/iterm2.md`    |
| `karabiner/karabiner.json`            | `docs/keybindings/karabiner.md` |

### 4. エディタ・ランチャー管理

| アプリ      | 本体                                  | 設定                                                                                                                                             | 拡張                                                                                                       |
| ----------- | ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------- |
| **VSCode**  | `programs.vscode` (Nix `pkgs.vscode`) | `programs.vscode.profiles.default.{userSettings,keybindings}` を `builtins.fromJSON` で `config/vscode/{settings,keybindings}.json` から読み込み | `config/vscode/extensions.txt` (`code --list-extensions` の出力)、`mutableExtensionsDir = true` で手動許容 |
| **Cursor**  | brew cask `cursor` (Nix package 無し) | `home.file` で `config/cursor/{settings,keybindings}.json` を symlink (JSONC 含むため Nix 解析しない)                                            | `config/cursor/extensions.txt` (cursor CLI で出力)                                                         |
| **Raycast** | brew cask `raycast`                   | `config/raycast/raycast.rayconfig` を手動エクスポートしてコミット                                                                                | (Hotkey は SQLite DB のため `.rayconfig` で一括管理)                                                       |
| **iTerm2**  | brew cask `iterm2` (共通)             | `home.file` で `config/iterm2/com.googlecode.iterm2.plist` を symlink（XML plist。UI 保存で dotfiles に直接書き込み）                            | —                                                                                                          |

**重要**: VSCode の cask `visual-studio-code` は Nix で本体管理するため共通 cask から外してある (`modules/darwin/homebrew-common.nix` を参照)。誤って戻さないこと。

**work プロファイル**: `profiles/work.nix` で `programs.vscode.enable = false`（Cursor 中心で二重メンテを避ける）。VS Code が必要なら `true` に戻す。`modules/home/vscode.nix` は `mkIf config.programs.vscode.enable` で JSON を読み込むため、**無効時は `config/vscode/*.json` が壊れていてもビルドは通る**。

**設定の取り込み・反映フロー**:

- **VSCode**: エディタ側でいじった結果をリポジトリへ載せるときは、引き続き `config/vscode/` へ `cp` してから `darwin-rebuild switch`（`programs.vscode` が JSON を読み込む）。
- **Cursor**: `~/Library/.../User/*.json` は **`$HOME/<dotfilesRelative>/config/cursor/`**（`flake.nix` の `dotfilesRelative` と `home.homeDirectory`）への symlink。日常の編集は **リポジトリ内の `config/cursor/settings.json` / `keybindings.json` を直接編集**すればよく（Cursor を開いたまま保存すればその場で反映）、rebuild は不要。下の `cp` は **別マシンの実ファイルから初めて取り込む**ときや、symlink 適用前に Library 側だけ弄っている場合の **一回どり**向け。

```bash
# VSCode — UI で変えた設定を dotfiles に反映
cp ~/Library/Application\ Support/Code/User/settings.json    config/vscode/settings.json
cp ~/Library/Application\ Support/Code/User/keybindings.json config/vscode/keybindings.json
code --list-extensions > config/vscode/extensions.txt

# Cursor — 上記のような「Library → リポジトリへの複製」が必要なときだけ
cp ~/Library/Application\ Support/Cursor/User/settings.json    config/cursor/settings.json
cp ~/Library/Application\ Support/Cursor/User/keybindings.json config/cursor/keybindings.json
cursor --list-extensions > config/cursor/extensions.txt   # cursor CLI が PATH にある場合
```

**JSON 制約**: VSCode は `builtins.fromJSON` で読み込むため、**厳密 JSON のみ受理** (trailing comma / `//` コメント NG)。Cursor は symlink 先のファイルがそのまま使われるため **JSONC**（コメント・末尾カンマ）も可。

### 5. Karabiner-Elements の特殊な扱い

`karabiner/karabiner.json` は **symlink せず、初回 activation でコピー** ([modules/home/karabiner.nix](modules/home/karabiner.nix))。

理由: Karabiner-Elements UI が `~/.config/karabiner/karabiner.json` を直接書き換えるため、symlink にするとリポジトリが書き換えられたり Karabiner 側でエラーになる。

- **dotfiles → 実機**: `~/.config/karabiner/karabiner.json` を退避してから `darwin-rebuild switch` で初回コピー
- **実機 → dotfiles** (UI で編集後): `cp ~/.config/karabiner/karabiner.json karabiner/karabiner.json` で取り込み、`git diff` で確認

### 6. masApps の App ID 確認方法

```bash
mas search "App Name"
```

または `https://apps.apple.com/jp/app/<slug>/id<APP_ID>` の URL から取得。書式:

```nix
masApps = {
  "App Name" = 1234567890;
};
```

### 7. README.md は linter による自動整形に注意

過去に linter が References / Roadmap セクションを削除したことがある。**README.md を編集する場合は必ず Read してから Edit / Write すること**。`Write` で全体上書きすると linter が消した内容を意図せず復活させる可能性がある。

### 8. Commit メッセージ（英語・意図が伝わること）

1 行目は **何を・なぜ（必要なら）** が分かる英語にする。**[Conventional Commits](https://www.conventionalcommits.org/) 形式を推奨**する（例: `feat:`, `fix:`, `refactor:`, `docs:`, `home:` に続けて簡潔な説明）。厳密でなくてよいが、履歴を眺めたときに検索しやすいプレフィックスがあるとよい。

本文は任意。変更点の列挙や背景（WHY）を書いてよい。エージェント経由のコミットでは末尾に Co-Authored-By を付けてよい。

```text
home: add bc for Claude statusline

- Install bc alongside jq for statusline latency display.
- Extend Claude Code Bash permissions for gh / pytest / cargo.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
```

フリーフォームの一行だけでもよい例:

```text
Phase 2: GUI casks, fonts, Karabiner, terminals, brew migration
```

### 9. Commit & Push の運用

ユーザーが「commit して」「変更お願い」等と言った時点で **push まで実行する**のが本リポジトリの慣習。push を明示的に避けたい場合のみユーザーが指定する。

### 10. cleanup ポリシー

- **共通（work 含む）**: `modules/darwin/homebrew-common.nix` の既定は `onActivation.cleanup = "none"`。宣言に無い brew/cask は **自動では削除されない**（実験インストール向け）。※ nix-darwin 26 以降は bool 不可、enum (`"none" | "check" | "uninstall" | "zap"`) のみ。
- **個人 PC**: `hosts/personal/default.nix` で `onActivation.cleanup = "uninstall"` を指定し、Brewfile に無い formula/cask を **uninstall**（`zap` は使わない。アプリ設定データは概ね保持）。

### 11. テンプレ同期のヒント（Claude / Codex / Karabiner）

`switch` 時、`modules/home/config-drift-warnings.nix` の activation がテンプレと実機の差を **stderr に通知**する（自動マージはしない）。Karabiner は **テンプレの方が新しいときだけ**通知し、UI で編集しただけではノイズにならないようにしている。

### `nix run` ショートカット (alias 不要、CI でも使える)

```bash
nix run .#switch              # darwin-rebuild switch (デフォルト host=personal)
nix run .#switch -- work      # work ホストで switch
nix run .#build               # build のみ (適用しない、検証用)
nix run .#check               # darwin-rebuild check
nix run .#update              # nix flake update + switch を一気に
```

### フォーマッタ (treefmt-nix)

```bash
nix fmt                       # nixfmt / stylua / shfmt / taplo / yamlfmt / prettier を一括
nix flake check               # formatting 違反 + flake 構文を検査
```

`treefmt.nix` で対象ファイルパターンを管理。Cursor の JSONC や Karabiner JSON は exclude 済み。

### 旧来コマンド (zsh alias 経由でも可)

```bash
darwin-rebuild build  --flake .#personal
darwin-rebuild switch --flake .#personal
```

設定変更後は `nix flake check` → `nix run .#build` → `nix run .#switch` の順で確認するのが安全。

## よく使うワークフロー

### 社用 Mac を増やす（個人 1 : 社用 N）

1. `hosts/work-office/default.nix` を複製して `hosts/<新ホスト名>/default.nix` を作成する（`imports = [ ../fragments/work-common.nix ];` と `networking.hostName` / `computerName` / `localHostName` をそのマシンに合わせる）。
2. `flake.nix` の `darwinConfigurations` に  
   `<新ホスト名> = mkDarwin { hostname = "<新ホスト名>"; profile = "work"; };`  
   を追加する（ユーザー名・`dotfilesRelative` が違えば `mkDarwin` 引数で上書き）。
3. 対象 Mac で `./bootstrap.sh <新ホスト名>` または `darwin-rebuild switch --flake .#<新ホスト名>`。
4. テンプレの `work-office` を使わない場合は `hosts/work-office/` と flake の対応エントリを削除してよい。

### 新しい cask を追加する

1. 共通 ([modules/darwin/homebrew-common.nix](modules/darwin/homebrew-common.nix)) か個人拡張 ([modules/darwin/homebrew-personal.nix](modules/darwin/homebrew-personal.nix)) か個別ホスト ([hosts/personal/default.nix](hosts/personal/default.nix)) かを判断
2. `casks = [ ... ]` に追記 (カテゴリコメントを保つ)
3. cask 名を `brew search --casks <name>` で確認 (実体験から: `eset-cyber-security` のように `-pro` を付けない場合あり)
4. commit + push

### 新しいキーバインドを追加 (例: WezTerm)

1. `config/wezterm/wezterm.lua` の `config.keys` テーブルに追加
2. `docs/keybindings/wezterm.md` の表に追加 (1 コミットで両方)
3. commit + push

### 新しい brew tap が必要なパッケージ

1. `flake.nix` の `inputs` に `homebrew-<name> = { url = "github:..."; flake = false; };` を追加
2. `flake.nix` の `nix-homebrew.taps` に `"<user>/homebrew-<tap>" = inputs.homebrew-<name>;` を追加
3. `homebrew.taps` リスト (共通 or ホスト) に `"<user>/<tap>"` を追加 (brew 表記)
4. `homebrew.brews` に tap-prefixed 名 (`<user>/<tap>/<formula>`) で追加

### 新しい masApp を追加

1. `mas search "<name>"` で App ID を確認
2. 共通 ([modules/darwin/homebrew-common.nix](modules/darwin/homebrew-common.nix)) か個人拡張 ([modules/darwin/homebrew-personal.nix](modules/darwin/homebrew-personal.nix)) か個別ホスト ([hosts/personal/default.nix](hosts/personal/default.nix)) かを判断
3. `masApps = { "Name" = <App ID>; };` に追加
4. commit + push

### Starship のテーマ変更

1. <https://starship.rs/presets/> から TOML を取得
2. `config/starship.toml` を上書き
3. `programs.starship.settings = builtins.fromTOML (builtins.readFile ../../config/starship.toml);` のままで反映される
4. commit + push

### Karabiner ルールを追加

1. Karabiner-Elements UI で動作確認 (試行錯誤しやすい)
2. `~/.config/karabiner/karabiner.json` から該当ルールを `karabiner/karabiner.json` にコピー
3. `docs/keybindings/karabiner.md` に説明を追加
4. commit + push

## メンテナンス対象 (日常的に手を入れる場所)

ユーザーは以下を頻繁に更新する想定:

- **WezTerm** (`config/wezterm/wezterm.lua`) — フォント、テーマ、キーバインド
- **Ghostty** (`config/ghostty/config`) — 同上
- **Starship** (`config/starship.toml`) — プロンプトテーマ
- **Neovim** (`modules/home/editor.nix`, `config/nvim/`) — **work** は `pkgs.neovim`（安定）、**personal** は nightly overlay。ほかは LazyVim 構成どおり。`config/nvim/lazy-lock.json` はコミット対象（プラグインの版を固定。`:Lazy sync` 後に `git diff` で確認してから commit）。
- **cmux** (Homebrew cask、設定は `~/.config/ghostty/config` と Settings GUI) — multiplexer 機能を内蔵、SSH 先での multiplexer が必要なときだけ tmux を手動導入する
- **Karabiner** (`karabiner/karabiner.json`) — 業務効率化のキーマップ追加
- **VSCode** (`config/vscode/`, `modules/home/vscode.nix`) — settings/keybindings/extensions。**work プロファイルでは既定で無効**（`profiles/work.nix`）。
- **Cursor** (`config/cursor/`, `modules/home/cursor.nix`) — symlink 先は **`$HOME/<dotfilesRelative>/config/cursor/`**（`flake.nix` の `mkDarwin` で `dotfilesRelative` / `username` をホストごとに上書き可）。
- **Raycast** (`config/raycast/raycast.rayconfig`) — 手動エクスポート (機密情報チェック必須)
- **Claude Code / Codex** (`modules/home/{claude-code,codex}.nix`) — `~/.claude` と `~/.codex` を管理。共通ルールは `config/ai-tools/global-rules.md` に統合（ホームの `~/.claude/CLAUDE.md` / `~/.codex/AGENTS.md` が指す symlink 先。**リポジトリ直下の** `CLAUDE.md`・`AGENTS.md` は dotfiles 用ドキュメント）。commands / skills / agents / `statusline.sh` は `mkOutOfStoreSymlink` で dotfiles を直接指す symlink。settings.json / config.toml は **初回のみコピー** (UI / runtime が書き戻すため上書きしない)。テンプレ更新は `config/claude/settings.json` を既存の `~/.claude/settings.json` に手動マージ

これらに変更を加える際は **必ず対応する `docs/keybindings/*.md` を同期** する (ルール 3)。

## 環境前提

- macOS Apple Silicon (`aarch64-darwin`)
- Nix は Apple Silicon ネイティブの `/nix/store` (Determinate Systems インストーラ)
- Homebrew は ARM64 ネイティブの `/opt/homebrew` (Intel `/usr/local` ではない — 移行手順は `README.md` 参照)
- Git remote は `github:kugeke-ibex/dotfiles.git` (SSH config alias 経由)
- **複数 Mac**: `flake.nix` の `mkDarwin` でホストごとに `username` と `dotfilesRelative`（`$HOME` からの相対パス）を指定できる。`home.homeDirectory` と実際のログイン名が一致すること。

## 参考リポジトリ

- <https://github.com/mozumasu/dotfiles> — Nix 構成、ホスト分岐、付随ツール (lefthook/sops 等)
- <https://github.com/yuya-matsushima/dotfiles> — Makefile + Shell 構成、用途別ターゲット (`make setup` / `make develop`)
