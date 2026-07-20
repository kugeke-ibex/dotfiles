# herdr Keybindings

## 概要

[herdr](https://herdr.dev) は Rust 製の **AI コーディングエージェント用マルチプレクサ**。
WezTerm / Ghostty など既存のターミナルエミュレータ**の中で動く**（tmux に近いレイヤー。
ターミナルエミュレータそのものではない）。複数の agent（Claude Code / Codex / Cursor Agent
など 16+）をペインで並列管理し、各 agent の状態（Blocked / Working / Done / Idle）を
自動検知してサイドバーに色分け表示する。セッションは永続化され、ターミナルを閉じても
SSH が切れても agent は動き続け、再アタッチできる。

Homebrew では **cask ではなく formula**（`brew install herdr`、homebrew-core）。
このリポジトリでは [modules/darwin/homebrew-common.nix](../../modules/darwin/homebrew-common.nix)
の `brews` に `"herdr"` を追加済み（全ホスト）。

## cmux との違い（herdr を採用した理由）

| 観点             | cmux                                   | herdr                                           |
| ---------------- | -------------------------------------- | ----------------------------------------------- |
| 実体             | 独立ターミナルアプリ (libghostty 内蔵) | ターミナル内で走るバイナリ (tmux 相当)          |
| Homebrew         | cask (`.app`)                          | formula (`herdr` CLI)                           |
| 起動             | Dock / アプリとして                    | WezTerm/Ghostty 内で `herdr`                    |
| ホスト端末       | cmux 自身が端末                        | WezTerm / Ghostty をそのまま使う                |
| agent 状態表示   | 垂直タブに表示                         | サイドバーに Blocked/Working/Done/Idle を色分け |
| SSH 先での永続化 | 不可（クライアント GUI）               | 可（サーバ常駐 + 再アタッチ、SSH 越しも）       |
| ライセンス       | —                                      | AGPL-3.0（商用は別ライセンス）                  |

**採用の経緯**: agent 状態検知（サイドバー色分け）と SSH 越しのセッション永続化で cmux に
優る点を評価し、herdr を主軸に採用。cmux (cask) は削除済み（個人 PC は `cleanup = "uninstall"`
のため次回 switch で `cmux.app` が自動アンインストールされる）。

## 起動（このリポジトリのキーバインド）

WezTerm / Ghostty とも `Cmd+Shift+A` prefix の agent ランチャに `h` を追加してある。

| キー              | ターミナル | 動作                      |
| ----------------- | ---------- | ------------------------- |
| `Cmd+Shift+A` `h` | WezTerm    | 新規タブで `herdr` を起動 |
| `Cmd+Shift+A` `h` | Ghostty    | 現ペインで `herdr` を起動 |

キーを使わず直接 `herdr` と打っても同じ。**herdr を起動した後**のペイン/タブ/エージェント
操作は、下記の **herdr 内キーバインド**（prefix 方式、tmux 類似）で行う。マウス操作にも対応。

## herdr 内キーバインド（本リポジトリの prefix = `Ctrl+Space`）

tmux と同じく **prefix キーを押してから** 次のキーを押す（例: `Ctrl+Space` → `c` で新規タブ）。
herdr の既定 prefix は `Ctrl+B` だが、本リポジトリでは shell/readline や Ghostty の `Cmd` 系キー
との混同を避けるため **`Ctrl+Space`** に変更している（[config/herdr/config.toml](../../config/herdr/config.toml)）。
以下の表の `prefix` は `Ctrl+Space` を指す。

### 基本

| キー               | 動作                                  |
| ------------------ | ------------------------------------- |
| `prefix` `c`       | 新規タブ                              |
| `prefix` `v`       | ペインを右に分割                      |
| `prefix` `-`       | ペインを下に分割                      |
| `prefix` `h/j/k/l` | ペイン間フォーカス移動（左/下/上/右） |
| `prefix` `w`       | ワークスペース操作                    |
| `prefix` `q`       | デタッチ（セッションから離脱）        |

### ペイン

| キー                     | 動作                     |
| ------------------------ | ------------------------ |
| `prefix` `z`             | ズーム切替               |
| `prefix` `x`             | ペインを閉じる           |
| `prefix` `Shift+h/j/k/l` | ペインを入れ替え（swap） |
| `prefix` `r`             | リサイズモード           |
| `prefix` `[`             | コピーモード             |

### タブ

| キー               | 動作               |
| ------------------ | ------------------ |
| `prefix` `n` / `p` | 次 / 前のタブ      |
| `prefix` `1..9`    | タブ番号へジャンプ |
| `prefix` `Shift+t` | タブ名変更         |
| `prefix` `Shift+x` | タブを閉じる       |

### ワークスペース / セッション

| キー               | 動作                          |
| ------------------ | ----------------------------- |
| `prefix` `Shift+n` | 新規ワークスペース            |
| `prefix` `Shift+w` | ワークスペース名変更          |
| `prefix` `Shift+d` | ワークスペース削除            |
| `prefix` `g`       | Goto ピッカー（横断ジャンプ） |
| `prefix` `b`       | サイドバー表示切替            |

### コピーモード（`prefix` `[` で開始）

- 移動: `h/j/k/l`、`w/b/e`、`{`/`}`、`PageUp`/`PageDown`、`Ctrl+B`/`Ctrl+F`、`Ctrl+U`/`Ctrl+D`
- 検索: `/` または `?`、`n`/`N` で次/前へ
- 選択・コピー: `v` または `Space` で選択開始、`y` または `Enter` でコピー、`q`/`Esc` で終了

## 設定ファイル（`~/.config/herdr/config.toml`、TOML）

- 本リポジトリで管理: [config/herdr/config.toml](../../config/herdr/config.toml) を
  `~/.config/herdr/config.toml` へ **ファイル単体で live symlink**（[modules/home/terminal.nix](../../modules/home/terminal.nix)）。
  ディレクトリ全体を symlink しないのは、`~/.config/herdr/` に socket / `sessions/` など
  実行時状態も置かれるため。
- 反映: `herdr server reload-config`（サーバ再起動不要）。既定値は `herdr --default-config`。
- 現状は prefix を `ctrl+space` に変更しているだけ。以下は変更しうる主なキー（参考、既定値ベース）:

```toml
# prefix とキーバインドのカスタマイズ
[keys]
prefix = "ctrl+space"          # ← 本リポジトリの設定（既定は ctrl+b）
new_tab = "prefix+c"
next_tab = ["prefix+n", "ctrl+alt+]"]   # 複数割り当て可
focus_pane_left = "prefix+h"
split_horizontal = "prefix+minus"
switch_tab = "prefix+1..9"      # 番号ジャンプ

# カスタムコマンドを popup で起動（例: lazygit）
[[keys.command]]
key = "prefix+alt+g"
type = "popup"
command = "lazygit"
description = "run lazygit"
width = "80%"
height = "80%"

# テーマ（ライト/ダーク自動切替も可）
[theme]
name = "catppuccin"
auto_switch = true
light_name = "catppuccin-latte"
dark_name = "catppuccin"

# 通知（delivery: herdr | terminal | system | off）
[ui.toast]
delivery = "herdr"
delay_seconds = 1
[ui.toast.herdr]
position = "bottom-right"
```

## agent 状態検知（サイドバー色分けの中身）

- 検知される状態: **`idle`**（待機）/ **`working`**（処理中）/ **`blocked`**（承認・入力待ち）/ **`done`**（完了、表示継続）。
- 仕組み: **フック不要**。"screen manifest"（TOML のルール集）で端末下部バッファのスナップショットを
  リアルタイム評価し、既知の UI パターンに一致させて状態を分類する。`blocked` の判定は意図的に厳格。
- サイドバー: 状態は **ペイン → タブ → ワークスペース** へ集約表示（どのプロジェクトが判断待ちか一目で分かる）。
- 対応エージェント: Claude Code / Codex / Cursor Agent CLI / GitHub Copilot CLI / Pi / OpenCode / Devin CLI ほか 17+。

## CLI / Socket API（エージェント自動制御）

herdr は CLI と newline-delimited JSON の Socket API でワークスペースを外部操作できる
（エージェント自身が自分のペインを操作・状態報告することも可能）。

- ソケット: `~/.config/herdr/herdr.sock`（既定）/ `~/.config/herdr/sessions/<name>/herdr.sock`（名前付き）
- 解決順: `--session <name>` → `HERDR_SOCKET_PATH` → `HERDR_SESSION=<name>` → 既定
- ペイン/タブ ID: `w1:p1` = workspace1 の pane1、`w1:t1` = workspace1 の tab1
- エージェント検出用の環境変数: `HERDR_SOCKET_PATH` / `HERDR_WORKSPACE_ID` / `HERDR_TAB_ID` / `HERDR_PANE_ID`

```bash
# CLI 例
herdr workspace create --cwd ~/project --label api
herdr tab create --label logs
herdr pane split w1:p1 --direction right
herdr pane run w1:p2 "npm test"
herdr wait agent-status w1:p1 --status done   # done になるまで待つ
herdr pane read w1:p2 --source recent --lines 50
herdr notification show "build failed" --body "api workspace"
herdr api schema --json                        # API スキーマ出力
```

```jsonc
// Socket API（1 行 1 リクエストの JSON）
{"id":"req_1","method":"pane.split","params":{"direction":"right","ratio":0.333}}
{"id":"req_2","method":"pane.send_text","params":{"pane_id":"w1:p1","text":"ls"}}
// エージェント側から状態を報告
{"id":"req_3","method":"pane.report_agent","params":{"pane_id":"w1:p1","source":"custom:docs","agent":"docs-bot","state":"working","message":"building docs"}}
```

## サーバ運用 / SSH

herdr はセッション永続化のため**サーバプロセス**を使う。クライアント（`herdr`）が接続し、
切断してもサーバ側で agent が動き続ける（`prefix` `q` またはターミナルを閉じるとデタッチ）。

```bash
brew services start herdr     # ログイン時に常駐（推奨）
herdr server                  # 常駐不要なら都度起動
herdr                         # 起動 or 既定セッションへ再アタッチ
herdr server reload-config    # 設定リロード
herdr server stop             # サーバ停止（全 agent 終了）
```

SSH 越しでも使える（cmux との最大の差分）。リモートで herdr を動かして手元から再アタッチ:

```bash
herdr --remote workbox        # 手元から遠隔セッションへ接続
# もしくは: ssh <host> したうえで `herdr` を実行 → 切断してもリモートで生存、再 attach 可
```

## 参考

- 公式: <https://herdr.dev>
- GitHub: <https://github.com/ogulcancelik/herdr>
- 紹介記事 (Zenn): <https://zenn.dev/dragon1208/articles/45708cc45a7a7c>
- 共通の agent ランチャ設計は [ai-agents.md](ai-agents.md) を参照。
