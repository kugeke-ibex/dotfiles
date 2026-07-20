# AI エージェントランチャ

Claude Code / Codex / Gemini を素の WezTerm / Ghostty タブで手軽に起動するための、
`Cmd+Shift+A` prefix キーバインド。**本格的な並列管理・状態表示は端末内マルチプレクサ
[herdr](herdr.md) に委ねる**（`Cmd+Shift+A h` で起動）。

- キーは各エージェントの**生コマンド**（`claude` / `codex` / `gemini`）を送るだけ。
- 以前あった zsh ラッパ（タブに `🤖 agent · branch` を表示、`ai` ディスパッチャ）は
  herdr 移行に伴い廃止した。git ブランチは starship プロンプトに常時表示される。

## シェルコマンド（全ターミナル共通）

| コマンド | 動作                                             |
| -------- | ------------------------------------------------ |
| `claude` | Claude Code 起動                                 |
| `codex`  | Codex 起動                                       |
| `gemini` | Gemini 起動                                      |
| `herdr`  | 端末内マルチプレクサ起動（[herdr.md](herdr.md)） |

## WezTerm キーバインド

`Cmd+Shift+A` で `agent_mode`（one_shot）に入り、次の 1 キーで起動する。実装は
`config/wezterm/modules/agents.lua`。詳細は [wezterm.md](wezterm.md)。

| キー                | 動作                                          |
| ------------------- | --------------------------------------------- |
| `Cmd+Shift+A` `c`   | 新規タブで Claude Code 起動                   |
| `Cmd+Shift+A` `x`   | 新規タブで Codex 起動                         |
| `Cmd+Shift+A` `g`   | 新規タブで Gemini 起動                        |
| `Cmd+Shift+A` `h`   | 新規タブで herdr 起動（[herdr.md](herdr.md)） |
| `Cmd+Shift+A` `s`   | 右 split で Claude 起動（並列用）             |
| `Cmd+Shift+A` `Esc` | キャンセル                                    |

## Ghostty キーバインド

`Cmd+Shift+A` を prefix にしたシーケンス。設定は [config/ghostty/config](../../config/ghostty/config)、
詳細は [ghostty.md](ghostty.md)。

| キー              | 動作                                          |
| ----------------- | --------------------------------------------- |
| `Cmd+Shift+A` `c` | 現ペインで Claude Code 起動                   |
| `Cmd+Shift+A` `x` | 現ペインで Codex 起動                         |
| `Cmd+Shift+A` `g` | 現ペインで Gemini 起動                        |
| `Cmd+Shift+A` `h` | 現ペインで herdr 起動（[herdr.md](herdr.md)） |
| `Cmd+Shift+A` `s` | 右に split（split 先で agent を起動する）     |
| `Cmd+Shift+A` `t` | 新規タブ（タブ先で agent を起動する）         |

## herdr（本格的な並列管理）

このシェルランチャは「素の端末タブで 1 エージェント」向けの軽量手段。複数エージェントを
状態表示付きで並列管理するなら `Cmd+Shift+A h` で [herdr](herdr.md)（端末内マルチプレクサ、
旧 cmux の後継）を起動する。herdr は Blocked / Working / Done / Idle を自動検知し、SSH 越しでも
セッションが永続化される。上記シェルコマンド（`claude` / `codex` …）は herdr のペイン内でも
そのまま使える。

## シェルで開く

`keys-agents`（alias `ka`）でこのドキュメントと実効設定（Ghostty の agent keybind /
利用可能なランチャ）を表示できる。
