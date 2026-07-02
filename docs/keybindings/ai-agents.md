# AI エージェントランチャ（cmux 風）

Claude Code / Codex / Gemini を「1 タブ = 1 エージェント」で並列運用するための、
ターミナル横断のランチャ。cmux の「専用ターミナル」体験を WezTerm / Ghostty /
cmux 共通で、宣言管理のまま実現する。

- 実体は `config/zsh/ai-agents.zsh`（`claude` / `codex` / `gemini` の関数ラッパ）。
- 起動すると端末タイトルが `🤖 <agent> · <branch>` になり、どのタブがどのエージェントか一目で分かる。
- WezTerm では `SetUserVar` 経由でタブタイトルに agent 名と git ブランチが出る（`modules/status.lua`）。
- Ghostty / cmux では OSC 0 タイトルとして反映される。

## シェルコマンド（全ターミナル + cmux 共通）

| コマンド     | 動作                                                       |
| ------------ | ---------------------------------------------------------- |
| `claude`     | Claude Code 起動。タイトルを `🤖 claude · <branch>` に設定 |
| `codex`      | Codex 起動                                                 |
| `gemini`     | Gemini 起動                                                |
| `ai <agent>` | `ai claude` / `ai codex` / `ai gemini` のディスパッチャ    |

本体が入っているホストでだけ関数ラップされる（未導入なら素の PATH 解決に任せる）。

## WezTerm キーバインド

`Cmd+Shift+A` で `agent_mode`（one_shot）に入り、次の 1 キーで起動する。実装は
`config/wezterm/modules/agents.lua`。詳細は [wezterm.md](wezterm.md)。

| キー                | 動作                              |
| ------------------- | --------------------------------- |
| `Cmd+Shift+A` `c`   | 新規タブで Claude Code 起動       |
| `Cmd+Shift+A` `x`   | 新規タブで Codex 起動             |
| `Cmd+Shift+A` `g`   | 新規タブで Gemini 起動            |
| `Cmd+Shift+A` `s`   | 右 split で Claude 起動（並列用） |
| `Cmd+Shift+A` `Esc` | キャンセル                        |

## Ghostty キーバインド

`Cmd+Shift+A` を prefix にしたシーケンス。設定は [config/ghostty/config](../../config/ghostty/config)、
詳細は [ghostty.md](ghostty.md)。

| キー              | 動作                                      |
| ----------------- | ----------------------------------------- |
| `Cmd+Shift+A` `c` | 現ペインで Claude Code 起動               |
| `Cmd+Shift+A` `x` | 現ペインで Codex 起動                     |
| `Cmd+Shift+A` `g` | 現ペインで Gemini 起動                    |
| `Cmd+Shift+A` `s` | 右に split（split 先で agent を起動する） |
| `Cmd+Shift+A` `t` | 新規タブ（タブ先で agent を起動する）     |

## cmux

cmux は AI エージェント専用ターミナルだが、起動は上記シェルコマンドを共有する
（libghostty 内蔵で zsh を共有するため）。cmux 標準のブランチ / PR / ポート表示と
併用できる。cmux 本体のキーバインドは Settings GUI 管理のため、必要なら同等の
シーケンスを GUI 側で割り当てる。詳細は [cmux.md](cmux.md)。

## シェルで開く

`keys-agents`（alias `ka`）でこのドキュメントと実効設定（Ghostty の agent keybind /
利用可能なランチャ）を表示できる。
