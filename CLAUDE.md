# CLAUDE.md

このファイルは **Git リポジトリ内のドキュメント**として、Claude Code / Cursor が本リポジトリで作業するときのガイドです。

グローバルなエージェント向けルール（全プロジェクト共通）は `config/ai-tools/global-rules.md` にあり、`~/.claude/CLAUDE.md` および `~/.codex/AGENTS.md` はそのファイルへの symlink です（リポジトリ直下のこの CLAUDE.md とは別物）。

## リポジトリの目的

macOS (Apple Silicon) 向けの個人 / 業務 PC セットアップを **Nix flake + nix-darwin + home-manager + nix-homebrew** で宣言的に管理する dotfiles。`personal` / `work` の 2 ホスト構成。

## 技術スタック

- **Nix flake** (`flake.nix`) — `darwinConfigurations.{personal,work}` を定義
- **nix-darwin** — システム設定 (Dock/Finder/Keyboard 等の defaults、Homebrew 統合)
- **home-manager** — ユーザー環境 (zsh, git, neovim, tmux, terminals 等)
- **nix-homebrew** — Homebrew を flake input で固定 (`mutableTaps = false`)
- **Determinate Systems nix-installer** — Nix の導入

## ディレクトリ構成

```text
.
├── flake.nix                        # darwinConfigurations entry
├── bootstrap.sh                     # Nix 導入 + 初回 switch
├── hosts/
│   ├── personal/default.nix         # 個人 PC 固有 (brews/casks/masApps)
│   └── work/default.nix             # 社用 PC 固有
├── modules/
│   ├── darwin/                      # システム設定 (nix-darwin)
│   │   ├── default.nix
│   │   ├── homebrew.nix             # 共通 brews/casks/masApps
│   │   ├── system.nix               # macOS defaults
│   │   └── fonts.nix                # ricty-diminished, nerd-fonts.meslo-lg
│   └── home/                        # ユーザー環境 (home-manager)
│       ├── default.nix
│       ├── shell.nix                # zsh + starship + fzf + ...
│       ├── git.nix                  # git + gh + lazygit
│       ├── editor.nix               # neovim
│       ├── tmux.nix
│       ├── terminal.nix             # WezTerm + Ghostty 設定の配置
│       ├── karabiner.nix            # karabiner.json の初回コピー
│       └── profiles/
│           ├── personal.nix         # 個人プロファイル (git email 等)
│           └── work.nix             # 業務プロファイル (TODO: 業務メール置換)
├── karabiner/karabiner.json         # Karabiner-Elements テンプレート
├── config/
│   ├── wezterm/wezterm.lua
│   ├── ghostty/config
│   └── starship.toml                # Tokyo Night preset (公式)
└── docs/
    ├── setup.md
    └── keybindings/
        ├── README.md
        ├── wezterm.md
        ├── ghostty.md
        ├── tmux.md
        └── karabiner.md
```

## コアルール

### 1. ホスト分岐 (どこに置くか)

| 用途 | 配置先 |
| --- | --- |
| personal / work どちらでも使う | `modules/darwin/homebrew.nix` (**共通**) |
| 個人 PC のみで使う | `hosts/personal/default.nix` |
| 社用 PC のみで使う | `hosts/work/default.nix` |

判断に迷ったら **共通寄り** にする。後から個別に分けるのは容易だが、最初から個別に置くと共通化が漏れる。

### 2. CLI ツール: Nix 経由 vs Homebrew 経由

| 配置先 | 例 | 判断基準 |
| --- | --- | --- |
| `modules/home/shell.nix` の `home.packages` | `ripgrep`, `fd`, `yq`, `tree`, `htop`, `wget` | Nix pkgs にあり、特別な設定が不要なもの |
| `modules/home/<x>.nix` の `programs.<tool>` | `git`, `gh`, `lazygit`, `neovim`, `tmux`, `starship`, `fzf`, `zoxide`, `eza`, `direnv` | home-manager に専用モジュールがあり、設定込みで便利なもの |
| `homebrew.brews` (共通 or ホスト) | `aws-vault`, `k9s`, `kubernetes-cli`, `asdf`, `mas`, `mysql` | macOS 専用 / 上記で扱いにくいもの |

**重複インストールを避ける**: 同じツールを home-manager と brew の両方で管理しないこと。例: `gh` は home-manager 側 (`programs.gh.enable`) のみで管理。

### 3. キーバインド・設定変更時はドキュメントを同期

**設定ファイルとドキュメントは同じコミットで更新する**。

| 設定ファイル | 対応するドキュメント |
| --- | --- |
| `config/wezterm/wezterm.lua` | `docs/keybindings/wezterm.md` |
| `config/ghostty/config` | `docs/keybindings/ghostty.md` |
| `modules/home/tmux.nix` の `extraConfig` | `docs/keybindings/tmux.md` |
| `karabiner/karabiner.json` | `docs/keybindings/karabiner.md` |

### 4. エディタ・ランチャー管理

| アプリ | 本体 | 設定 | 拡張 |
| --- | --- | --- | --- |
| **VSCode** | `programs.vscode` (Nix `pkgs.vscode`) | `programs.vscode.profiles.default.{userSettings,keybindings}` を `builtins.fromJSON` で `config/vscode/{settings,keybindings}.json` から読み込み | `config/vscode/extensions.txt` (`code --list-extensions` の出力)、`mutableExtensionsDir = true` で手動許容 |
| **Cursor** | brew cask `cursor` (Nix package 無し) | `home.file` で `config/cursor/{settings,keybindings}.json` を symlink (JSONC 含むため Nix 解析しない) | `config/cursor/extensions.txt` (cursor CLI で出力) |
| **Raycast** | brew cask `raycast` | `config/raycast/raycast.rayconfig` を手動エクスポートしてコミット | (Hotkey は SQLite DB のため `.rayconfig` で一括管理) |

**重要**: VSCode の cask `visual-studio-code` は Nix で本体管理するため共通 cask から外してある (`modules/darwin/homebrew.nix` を参照)。誤って戻さないこと。

**設定の取り込み・反映フロー**:

```bash
# VSCode 設定が更新された時
cp ~/Library/Application\ Support/Code/User/settings.json    config/vscode/settings.json
cp ~/Library/Application\ Support/Code/User/keybindings.json config/vscode/keybindings.json
code --list-extensions > config/vscode/extensions.txt

# Cursor も同様
cp ~/Library/Application\ Support/Cursor/User/settings.json    config/cursor/settings.json
cp ~/Library/Application\ Support/Cursor/User/keybindings.json config/cursor/keybindings.json
cursor --list-extensions > config/cursor/extensions.txt   # cursor CLI が PATH にある場合
```

**JSON 制約**: VSCode は `builtins.fromJSON` で読み込むため、**厳密 JSON のみ受理** (trailing comma / `//` コメント NG)。Cursor は `home.file` で raw 配置なので JSONC OK。

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

### 8. Commit メッセージは英語で簡潔に

Conventional Commits は使わない。1 行目で **意図** を表す:

```text
Phase 2: GUI casks, fonts, Karabiner, terminals, brew migration

- Add common casks: ...
- ...

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
```

### 9. Commit & Push の運用

ユーザーが「commit して」「変更お願い」等と言った時点で **push まで実行する**のが本リポジトリの慣習。push を明示的に避けたい場合のみユーザーが指定する。

### 10. cleanup ポリシー

`modules/darwin/homebrew.nix` の `onActivation.cleanup = "uninstall"` (zap ではない)。Brewfile に書かれていない brew/cask は **uninstall** されるが、関連データ (アプリ設定) は保持される。`zap` は危険なので使わない。

## 検証 / 適用コマンド

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

### 新しい cask を追加する

1. 共通 ([modules/darwin/homebrew.nix](modules/darwin/homebrew.nix)) か個人 ([hosts/personal/default.nix](hosts/personal/default.nix)) かを判断
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
2. 共通 ([modules/darwin/homebrew.nix](modules/darwin/homebrew.nix)) か個人 ([hosts/personal/default.nix](hosts/personal/default.nix)) かを判断
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
- **Neovim** (`modules/home/editor.nix`, `config/nvim/`) — LazyVim ベース。`init.lua` は `require("config.lazy")` のみで、設定は `lua/config/` (autocmds/keymaps/options/lazy) と `lua/plugins/` に分離。`mkOutOfStoreSymlink` で dotfiles を直接指す symlink なので編集が即時反映される
- **tmux** (`modules/home/tmux.nix`) — キーバインド、status line
- **Karabiner** (`karabiner/karabiner.json`) — 業務効率化のキーマップ追加
- **VSCode** (`config/vscode/`, `modules/home/vscode.nix`) — settings/keybindings/extensions
- **Cursor** (`config/cursor/`, `modules/home/cursor.nix`) — settings/keybindings は WezTerm と同様 **`flake.nix` の `dotfilesPath` 経由の live symlink**。拡張リストは `config/cursor/extensions.txt`（`cursor --list-extensions` で更新）
- **Raycast** (`config/raycast/raycast.rayconfig`) — 手動エクスポート (機密情報チェック必須)
- **Claude Code / Codex** (`modules/home/{claude-code,codex}.nix`) — `~/.claude` と `~/.codex` を管理。共通ルールは `config/ai-tools/global-rules.md` に統合 (CLAUDE.md と AGENTS.md 共用)。commands / skills / agents / `statusline.sh` は `mkOutOfStoreSymlink` で dotfiles を直接指す symlink。settings.json / config.toml は **初回のみコピー** (UI / runtime が書き戻すため上書きしない)。テンプレ更新は `config/claude/settings.json` を既存の `~/.claude/settings.json` に手動マージ

これらに変更を加える際は **必ず対応する `docs/keybindings/*.md` を同期** する (ルール 3)。

## 環境前提

- macOS Apple Silicon (`aarch64-darwin`)
- Nix は Apple Silicon ネイティブの `/nix/store` (Determinate Systems インストーラ)
- Homebrew は ARM64 ネイティブの `/opt/homebrew` (Intel `/usr/local` ではない — 移行手順は `README.md` 参照)
- Git remote は `github:kugeke-ibex/dotfiles.git` (SSH config alias 経由)

## 参考リポジトリ

- <https://github.com/mozumasu/dotfiles> — Nix 構成、ホスト分岐、付随ツール (lefthook/sops 等)
- <https://github.com/yuya-matsushima/dotfiles> — Makefile + Shell 構成、用途別ターゲット (`make setup` / `make develop`)
