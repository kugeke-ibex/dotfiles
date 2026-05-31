# AGENTS.md — Cursor / AI エージェント向け（本リポジトリ）

このファイルは **この dotfiles リポジトリで作業するとき**の要点だけをまとめたものです。**網羅的なルール・手順・ワークフローは [`CLAUDE.md`](CLAUDE.md) を必ず参照**してください。

マシン全体に効く短文ルール（全プロジェクト共通）は [`config/ai-tools/global-rules.md`](config/ai-tools/global-rules.md) です（ユーザーの `~/.claude/CLAUDE.md` 等と内容を揃える想定）。**リポジトリ固有の運用は CLAUDE.md と本ファイルが担当**します。

---

## プロジェクト概要

- **対象**: macOS **Apple Silicon** (`aarch64-darwin`) のみ。
- **構成**: Nix flake + nix-darwin + home-manager + nix-homebrew。
- **ホスト**: 個人 **1** (`personal`) + 社用 **複数**（`work`, `work-office` など）。`hosts/<名前>/default.nix` と `flake.nix` の `darwinConfigurations.<名前>` を対応させる。社用共通は [`hosts/fragments/work-common.nix`](hosts/fragments/work-common.nix)。

---

## 変更をどこに書くか（迷ったら共通寄り）

| 用途                                  | 置き場所                                                                                                                         |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| 共通 brew / 多くの cask               | [`modules/darwin/homebrew-common.nix`](modules/darwin/homebrew-common.nix)                                                       |
| personal のみの brew/cask             | [`modules/darwin/homebrew-personal.nix`](modules/darwin/homebrew-personal.nix)                                                   |
| 個人マシンだけの差分                  | [`hosts/personal/default.nix`](hosts/personal/default.nix)                                                                       |
| 社用マシンごとの差分                  | [`hosts/<名前>/default.nix`](hosts/work/default.nix)                                                                             |
| Home Manager（シェル・git・nvim 等）  | [`modules/home/`](modules/home/)                                                                                                 |
| WezTerm / Ghostty / Neovim の設定本文 | [`config/wezterm/`](config/wezterm/), [`config/ghostty/`](config/ghostty/), [`config/nvim/`](config/nvim/)                       |
| Cursor の設定                         | [`config/cursor/settings.json`](config/cursor/settings.json), [`config/cursor/keybindings.json`](config/cursor/keybindings.json) |
| VS Code（厳密 JSON）                  | [`config/vscode/`](config/vscode/) + [`modules/home/vscode.nix`](modules/home/vscode.nix)                                        |

---

## 変更を反映するには

- **`*.nix`・`flake.nix`・`hosts/` を編集した** → `darwin-rebuild switch --flake ~/Development/dotfiles#<host>` または `nix run .#switch -- <host>`（[`README.md`](README.md) の「変更の反映」表も参照）。**ファイル保存だけでは環境は変わらない**。
- **WezTerm / Ghostty / Neovim / Cursor のリポジトリ内設定** → `mkOutOfStoreSymlink` 経由のため、**中身の編集だけなら switch は不要**（アプリのリロード・再起動は別）。
- **`config/vscode/*.json`・`config/starship.toml`** → Nix が評価時に読み込むため **switch が必要**。

---

## Cursor まわり（このリポジトリ）

- 設定のソース・オブ・トゥルースは **リポジトリの `config/cursor/`**。実機は symlink（[`modules/home/cursor.nix`](modules/home/cursor.nix)）。**JSONC（コメント・末尾カンマ）可**。
- 拡張リストは [`config/cursor/extensions.txt`](config/cursor/extensions.txt)（ヘッダの手順に従う）。
- **work プロファイル**では VS Code は既定オフ（[`modules/home/profiles/work.nix`](modules/home/profiles/work.nix)）。Cursor と二重メンテを避ける意図。

---

## キーバインド・ターミナル系

**設定ファイルと `docs/keybindings/*.md` は同一コミットで更新**する（対応表は CLAUDE.md「コアルール 3」）。

---

## Git・コミット

- メッセージは **英語**、[Conventional Commits](https://www.conventionalcommits.org/) 形式を推奨（`feat:`, `fix:`, `docs:`, `home:` など）。
- ユーザーがコミットを依頼した場合、**push まで行うのがこのリポジトリの慣習**（明示的に止める指示がない限り）。

---

## 注意（よくある落とし穴）

- **同じ CLI を Homebrew と home-manager の両方で入れない**（例: `gh` は home-manager のみ）。
- **VS Code の cask を `homebrew-common` に戻さない**（本体は Nix の `programs.vscode` で管理）。
- **Karabiner** は symlink ではなく初回コピー運用。UI で編集したあとは `karabiner/karabiner.json` への取り込み手順を CLAUDE.md に従う。
- **`README.md` を全体 `Write` で上書きしない**（セクション消失の経緯あり）。既存内容を読んでから部分編集する。

---

## 調べる順序の提案

1. 目的に近い節を **`CLAUDE.md` で検索**する。
2. ホスト追加・bootstrap・switch コマンドは **`README.md`**。
3. 初回セットアップの人向け短文は **`docs/setup.md`**。
