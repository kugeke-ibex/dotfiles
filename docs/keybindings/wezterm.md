# WezTerm キーバインド

## 通常ウィンドウ

| 操作 | 動作 |
|------|------|
| 通常ウィンドウ起動 | 画面いっぱい（`gui-startup` で最大化） |

## Hotkey Window（iTerm2 相当）

workspace `hotkey` の専用ウィンドウ。オーバーレイではなく通常の最大化ウィンドウ。

| キー | 動作 |
|------|------|
| `Ctrl+Opt+W` | Karabiner → `toggle-wezterm-hotkey` で表示/非表示トグル |

| 項目 | 設定 |
|------|------|
| 実装 | `modules/hotkey.lua` + `config/bin/toggle-wezterm-hotkey.zsh` |
| タイトル | `WezTerm Hotkey` |

`darwin-rebuild switch` で `~/.local/bin/toggle-wezterm-hotkey` がインストールされる。通常の WezTerm は Dock / `Cmd+N` から従来どおり。
