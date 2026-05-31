# Ghostty キーバインド

## Hotkey Window（iTerm2 相当）

Quick Terminal（オーバーレイ）は使わない。Karabiner から通常ウィンドウの表示/非表示をトグルする。

| キー | 動作 |
|------|------|
| `Ctrl+Opt+G` | Karabiner → `toggle-ghostty-hotkey` で表示/非表示トグル |

| 項目 | 説明 |
|------|------|
| 実装 | `config/bin/toggle-ghostty-hotkey.zsh` |
| アクセシビリティ | **Karabiner-Elements**（推奨。無しでも状態ファイルでフォールバック） |

## 通常ウィンドウ

`maximize = true` などは `config/ghostty/config` を参照。

## その他

| キー | 動作 |
|------|------|
| `Cmd+D` / `Cmd+Shift+D` | ペイン分割 |
| `Cmd+[` / `Cmd+]` | ペイン移動（前 / 次の split） |
| `Cmd+W` | ペイン閉じ（確認なし、`confirm-close-surface = false`） |
| `Ctrl+Shift+矢印` | ペインリサイズ（50px/回、`resize-overlay-duration = 150ms`） |
