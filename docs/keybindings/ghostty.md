# Ghostty キーバインド

## Hotkey Window（iTerm2 相当）

Quick Terminal（オーバーレイ）は使わない。Karabiner から通常ウィンドウの表示/非表示をトグルする。

| キー         | 動作                                                    |
| ------------ | ------------------------------------------------------- |
| `Ctrl+Opt+G` | Karabiner → `toggle-ghostty-hotkey` で表示/非表示トグル |

| 項目             | 説明                                                                 |
| ---------------- | -------------------------------------------------------------------- |
| 実装             | `config/bin/toggle-ghostty-hotkey.zsh`                               |
| アクセシビリティ | **Karabiner-Elements**（推奨。無しでも状態ファイルでフォールバック） |

## 通常ウィンドウ

`maximize = true` などは `config/ghostty/config` を参照。

## その他

| キー                    | 動作                                                         |
| ----------------------- | ------------------------------------------------------------ |
| `Cmd+D` / `Cmd+Shift+D` | ペイン分割                                                   |
| `Cmd+[` / `Cmd+]`       | ペイン移動（前 / 次の split）                                |
| `Cmd+W`                 | ペイン閉じ（確認なし、`confirm-close-surface = false`）      |
| `Ctrl+Shift+矢印`       | ペインリサイズ（50px/回、`resize-overlay-duration = 150ms`） |

## AI エージェントランチャ（cmux 風）

`Cmd+Shift+A` を prefix にしたシーケンス。次の 1 キーで各エージェントを起動する。
起動は `config/zsh/ai-agents.zsh` の `claude` / `codex` / `gemini` ラッパを経由し、
タブタイトルが `🤖 <agent> · <branch>` になる（どのタブがどのエージェントか一目で分かる）。

| キー              | 動作                                      |
| ----------------- | ----------------------------------------- |
| `Cmd+Shift+A` `c` | 現ペインで Claude Code 起動               |
| `Cmd+Shift+A` `x` | 現ペインで Codex 起動                     |
| `Cmd+Shift+A` `g` | 現ペインで Gemini 起動                    |
| `Cmd+Shift+A` `s` | 右に split（split 先で agent を起動する） |
| `Cmd+Shift+A` `t` | 新規タブ（タブ先で agent を起動する）     |

キーを使わず直接 `claude` / `codex` / `gemini`（または `ai claude` …）と打っても同じ
ラッパを踏むので、cmux でも同じ体験になる。「1 タブ = 1 エージェント」で並列運用する。
