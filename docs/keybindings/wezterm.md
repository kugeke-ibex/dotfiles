# WezTerm キーバインド

## 通常ウィンドウ

| 操作                    | 動作                                   |
| ----------------------- | -------------------------------------- |
| 通常ウィンドウ起動      | 画面いっぱい（`gui-startup` で最大化） |
| `Cmd+D` / `Cmd+Shift+D` | ペイン分割（水平 / 垂直）              |
| `Cmd+[` / `Cmd+]`       | ペイン移動（前 / 次、iTerm2 風）       |
| `Ctrl+Shift+矢印`       | ペインリサイズ                         |
| `Cmd+Z`                 | ペインズーム                           |
| `Cmd+W`                 | ペイン閉じ（確認なし）                 |
| `Cmd+K`                 | スクロールバッククリア                 |
| `Cmd+Opt+[`             | コピーモード                           |
| `Cmd+Shift+R`           | 設定リロード                           |

## Hotkey Window（iTerm2 相当）

workspace `hotkey` の専用ウィンドウ。オーバーレイではなく通常の最大化ウィンドウ。

| キー         | 動作                                                    |
| ------------ | ------------------------------------------------------- |
| `Ctrl+Opt+W` | Karabiner → `toggle-wezterm-hotkey` で表示/非表示トグル |

| 項目     | 設定                                                          |
| -------- | ------------------------------------------------------------- |
| 実装     | `modules/hotkey.lua` + `config/bin/toggle-wezterm-hotkey.zsh` |
| タイトル | `WezTerm Hotkey`                                              |

`darwin-rebuild switch` で `~/.local/bin/toggle-wezterm-hotkey` がインストールされる。通常の WezTerm は Dock / `Cmd+N` から従来どおり。

## AI エージェントランチャ（cmux 風）

`Cmd+Shift+A` で `agent_mode`（one_shot）に入り、次の 1 キーで各エージェントを起動する。
実装は `modules/agents.lua`。起動は `config/zsh/ai-agents.zsh` の `claude` / `codex` /
`gemini` ラッパを踏み、タブタイトルに `🤖 <agent>` と git ブランチが表示される
（`modules/status.lua` が `SetUserVar` を読む）。

| キー                | 動作                              |
| ------------------- | --------------------------------- |
| `Cmd+Shift+A` `c`   | 新規タブで Claude Code 起動       |
| `Cmd+Shift+A` `x`   | 新規タブで Codex 起動             |
| `Cmd+Shift+A` `g`   | 新規タブで Gemini 起動            |
| `Cmd+Shift+A` `s`   | 右 split で Claude 起動（並列用） |
| `Cmd+Shift+A` `Esc` | キャンセル                        |

`agent_mode` は one_shot なので、未割り当てキーを押すと自動的に抜ける。タブタイトルの
ブランチ表示は precmd（`config/zsh/ai-agents.zsh`）が全タブに送るため、エージェント
未起動のタブでも現在のブランチが見える。
