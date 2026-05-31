# WezTerm Keybindings

設定: [config/wezterm/wezterm.lua](../../config/wezterm/wezterm.lua)

## ウィンドウ

| 項目 | 値 |
| ---- | -- |
| 通常ウィンドウ起動 | 画面いっぱい（`gui-startup` で最大化、`modules/hotkey.lua`） |
| 背景透過 | `window_background_opacity = 0.55`（`Cmd+Shift+O` で一時調整可） |

## Hotkey Window

iTerm2 の Hotkey Window 相当。workspace `hotkey` のドロップダウンウィンドウ（通常ウィンドウとは別）。

| キー | 動作 |
| ---- | ---- |
| `Ctrl+Opt+W` | Karabiner → `toggle-wezterm-hotkey` で表示/非表示トグル |

| 項目 | 値 |
| ---- | -- |
| 実装 | `modules/hotkey.lua` + `config/bin/toggle-wezterm-hotkey.zsh` |
| レイアウト | 画面上部 40%・Floating ウィンドウレベル |
| 識別 | ウィンドウ名 `WezTerm Hotkey` |

`darwin-rebuild switch` で `~/.local/bin/toggle-wezterm-hotkey` がインストールされる。通常の WezTerm は Dock / `Cmd+N` から従来どおり。

## カスタム (このリポジトリで追加)

### ペイン

| キー           | 動作                                 |
| -------------- | ------------------------------------ |
| `Cmd+D`        | ペインを右に分割 (`SplitHorizontal`) |
| `Cmd+Shift+D`  | ペインを下に分割 (`SplitVertical`)   |
| `Cmd+Opt+H`    | 左のペインへフォーカス               |
| `Cmd+Opt+J`    | 下のペインへフォーカス               |
| `Cmd+Opt+K`    | 上のペインへフォーカス               |
| `Cmd+Opt+L`    | 右のペインへフォーカス               |
| `Ctrl+Shift+←` | ペインを左に5列リサイズ              |
| `Ctrl+Shift+↓` | ペインを下に5行リサイズ              |
| `Ctrl+Shift+↑` | ペインを上に5行リサイズ              |
| `Ctrl+Shift+→` | ペインを右に5列リサイズ              |
| `Cmd+W`        | ペイン閉じ (確認あり)                |
| `Cmd+Z`        | ペインズーム切替 (最大化)            |

### ウィンドウ・表示

| キー          | 動作                                          |
| ------------- | --------------------------------------------- |
| `Cmd+Enter`   | フルスクリーン切替                            |
| `Cmd+K`       | スクロールバッククリア                        |
| `Cmd+[`       | コピーモード起動                              |
| `Cmd+Shift+O` | 透過度設定モード起動 (setting_mode、下表参照) |
| `Cmd+Shift+R` | 設定リロード                                  |

### setting_mode 中 (`Cmd+Shift+O` で起動)

| キー  | 動作                                                      |
| ----- | --------------------------------------------------------- |
| `;`   | 透過度 +0.1                                               |
| `-`   | 透過度 -0.1                                               |
| `0`   | 透過度をリセット (`window_background_opacity` の値に戻す) |
| `Esc` | setting_mode を抜ける                                     |

## デフォルト (WezTerm 標準)

### タブ

| キー             | 動作               |
| ---------------- | ------------------ |
| `Cmd+T`          | 新規タブ           |
| `Cmd+Shift+[`    | 前のタブへ         |
| `Cmd+Shift+]`    | 次のタブへ         |
| `Cmd+1`〜`Cmd+9` | タブ番号でジャンプ |

### ウィンドウ

| キー    | 動作           |
| ------- | -------------- |
| `Cmd+N` | 新規ウィンドウ |
| `Cmd+M` | ミニマイズ     |

### 編集 / 検索

| キー               | 動作                                                            |
| ------------------ | --------------------------------------------------------------- |
| `Cmd+C`            | コピー                                                          |
| `Cmd+V`            | ペースト                                                        |
| `Cmd+F`            | 検索                                                            |
| `Cmd+P`            | コマンドパレット                                                |
| `Ctrl+Shift+Space` | QuickSelect (URL/ARN/Path/Hash/IP/UUID/メール等を 1 キーで抽出) |
| `Ctrl+Shift+U`     | 文字選択 (Unicode)                                              |

### フォント

| キー    | 動作                   |
| ------- | ---------------------- |
| `Cmd++` | フォントサイズ拡大     |
| `Cmd+-` | フォントサイズ縮小     |
| `Cmd+0` | フォントサイズリセット |

## コピーモード中

| キー                       | 動作                          |
| -------------------------- | ----------------------------- |
| `h/j/k/l` または `←/↓/↑/→` | カーソル移動                  |
| `v`                        | 選択開始 (vi-mode)            |
| `y`                        | yank (クリップボードへコピー) |
| `q` または `Esc`           | コピーモード終了              |
| `/`                        | 検索                          |
| `n` / `N`                  | 次/前の検索結果               |
